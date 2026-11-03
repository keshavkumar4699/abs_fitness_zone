import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errors.dart';
import '../domain/app_user.dart';

/// Google sign-in for everyone (owner, front desk, trainers and members).
///
/// A Google account gets in when its verified email is on a staff record
/// (added by the owner) or a member record (entered by the desk). The first
/// sign-in links the login to that record through `link_my_account`.
abstract interface class AuthRepository {
  /// Emits the signed-in user (null when signed out). Emits again when the
  /// session or profile changes.
  Stream<AppUser?> watchUser();

  /// Opens Google sign-in. The session arrives later through [watchUser];
  /// a refused account is reported through [watchSignInError].
  Future<void> signInWithGoogle();

  /// Why the last Google sign-in didn't get in (null when there is nothing
  /// to explain). Replays the current value on listen.
  Stream<AppFailure?> watchSignInError();

  void clearSignInError();

  Future<void> signOut();

  /// Re-reads the profile.
  Future<void> refresh();
}

/// Where Google sign-in sends people back to on Android/iOS (registered as an
/// intent filter / URL scheme and in Supabase redirect URLs).
const kAuthRedirectUri = 'com.absfitnesszone.app://login-callback';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client, [this._cache]);

  final SupabaseClient _client;
  final SharedPreferences? _cache;
  final _refresh = StreamController<void>.broadcast();
  final _errors = StreamController<AppFailure?>.broadcast();
  AppFailure? _signInError;

  static const _cacheKey = 'cached_profile';

  void _writeCache(AppUser user) => _cache?.setString(_cacheKey, jsonEncode(user.toJson()));

  void _setSignInError(AppFailure? e) {
    _signInError = e;
    _errors.add(e);
  }

  /// The last profile seen for [userId], so the app still opens offline.
  AppUser? _readCache(String userId) {
    final raw = _cache?.getString(_cacheKey);
    if (raw == null) return null;
    try {
      final user = AppUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      return user.userId == userId ? user : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<AppUser?> watchUser() async* {
    // onAuthStateChange replays the initial session on listen.
    final events = StreamGroup.merge<Session?>([
      _client.auth.onAuthStateChange.map((e) => e.session),
      _refresh.stream.map((_) => _client.auth.currentSession),
    ]);
    await for (final session in events) {
      yield* _safeLoad(session);
    }
  }

  @override
  Stream<AppFailure?> watchSignInError() async* {
    yield _signInError;
    yield* _errors.stream;
  }

  @override
  void clearSignInError() => _setSignInError(null);

  /// Emits the profile, or an error event that does not end the stream.
  Stream<AppUser?> _safeLoad(Session? session) async* {
    try {
      yield await _loadProfile(session);
    } on NoProfileFailure catch (e) {
      _setSignInError(e);
      yield null;
    } on StaffDeactivatedFailure catch (e) {
      _setSignInError(e);
      yield null;
    } on SharedEmailFailure catch (e) {
      _setSignInError(e);
      yield null;
    } on GoogleOnlyFailure catch (e) {
      _setSignInError(e);
      yield null;
    } on NetworkFailure catch (e) {
      // Offline with a saved session: open with the cached profile instead of
      // locking the user out (writes still need a connection).
      final cached = session == null ? null : _readCache(session.user.id);
      if (cached != null) {
        yield cached;
      } else {
        yield* Stream<AppUser?>.error(e);
      }
    } catch (e) {
      yield* Stream<AppUser?>.error(e);
    }
  }

  Future<Map<String, dynamic>?> _profileRow(String userId) => _client
      .from('profiles')
      .select('id, role, name, phone, staff_id, member_id, staff:staff_id(is_active)')
      .eq('id', userId)
      .isFilter('archived_at', null)
      .maybeSingle();

  Future<AppUser?> _loadProfile(Session? session) async {
    if (session == null) return null;
    try {
      var row = await _profileRow(session.user.id);
      if (row == null) {
        // First sign-in with this Google account: link it to the gym record
        // with the same email, then read the new profile.
        try {
          await _client.rpc<String>('link_my_account');
        } on PostgrestException catch (e) {
          await _rejectSession();
          throw linkFailure(e);
        }
        row = await _profileRow(session.user.id);
        if (row == null) {
          await _rejectSession();
          throw const NoProfileFailure();
        }
      }
      final user = AppUser.fromJson(row);
      // Deactivated staff keep their login row but must not get in. (RLS hides
      // the staff row from inactive staff, so a missing embed means inactive.)
      final staff = row['staff'];
      if (user.role.isStaff && (staff is! Map || staff['is_active'] != true)) {
        await _rejectSession();
        throw const StaffDeactivatedFailure();
      }
      _writeCache(user);
      _signInError = null;
      return user;
    } on AppFailure {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw _mapNetwork(e);
    }
  }

  /// Authenticated with Google but not allowed in: sign out rather than
  /// leave a half-session behind.
  Future<void> _rejectSession() async {
    await _cache?.remove(_cacheKey);
    try {
      await _client.auth.signOut();
    } catch (_) {
      await _client.auth.signOut(scope: SignOutScope.local);
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    _setSignInError(null);
    try {
      final launched = await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        // On the web the Supabase site URL is used; on phones come back to the app.
        redirectTo: kIsWeb ? null : kAuthRedirectUri,
        // Always show the account picker: desk phones are shared.
        queryParams: const {'prompt': 'select_account'},
      );
      if (!launched) throw const SignInCancelledFailure();
    } on AppFailure {
      rethrow;
    } on AuthException catch (e) {
      throw authFailure(e);
    } catch (e) {
      throw _mapNetwork(e);
    }
  }

  @override
  Future<void> signOut() async {
    await _cache?.remove(_cacheKey);
    try {
      await _client.auth.signOut();
    } catch (_) {
      // Offline: drop the local session anyway so the device is signed out.
      await _client.auth.signOut(scope: SignOutScope.local);
    }
  }

  @override
  Future<void> refresh() async => _refresh.add(null);
}

/// Maps `link_my_account` refusals to failures the welcome screen explains.
AppFailure linkFailure(PostgrestException e) => switch (e.code) {
  'P0002' => const NoProfileFailure(),
  'AB001' => const StaffDeactivatedFailure(),
  'AB002' => const SharedEmailFailure(),
  '42501' => const GoogleOnlyFailure(),
  _ => ServerFailure(e.message),
};

/// Maps Supabase Auth errors to failures the UI can explain.
AppFailure authFailure(AuthException e) {
  if (e.code == 'over_request_rate_limit' || e.statusCode == '429') return const RateLimitedFailure();
  // The optional sign-up hook refuses unknown Gmails with a 403.
  if (e.statusCode == '403' || e.code == 'signup_disabled') return const NoProfileFailure();
  return ServerFailure(e.message);
}

Object _mapNetwork(Object e) {
  if (e is AppFailure) return e;
  final text = e.toString();
  if (text.contains('SocketException') || text.contains('ClientException') || text.contains('Failed host lookup')) {
    return const NetworkFailure();
  }
  if (e is TimeoutException) return const NetworkFailure();
  return ServerFailure(text);
}

/// Used when the build has no Supabase URL/key: nobody can sign in, but the
/// app still opens (welcome screen and the component gallery work).
class UnconfiguredAuthRepository implements AuthRepository {
  const UnconfiguredAuthRepository();

  @override
  Stream<AppUser?> watchUser() => Stream.value(null);

  @override
  Future<void> signInWithGoogle() async => throw const NotConfiguredFailure();

  @override
  Stream<AppFailure?> watchSignInError() => Stream.value(null);

  @override
  void clearSignInError() {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> refresh() async {}
}

/// Minimal stream merge (avoids an extra dependency for one use).
abstract final class StreamGroup {
  static Stream<T> merge<T>(List<Stream<T>> streams) {
    late final StreamController<T> controller;
    final subs = <StreamSubscription<T>>[];
    controller = StreamController<T>(
      onListen: () {
        var done = 0;
        for (final s in streams) {
          subs.add(
            s.listen(
              controller.add,
              onError: controller.addError,
              onDone: () {
                if (++done == streams.length) controller.close();
              },
            ),
          );
        }
      },
      onCancel: () async {
        for (final s in subs) {
          await s.cancel();
        }
      },
    );
    return controller.stream;
  }
}
