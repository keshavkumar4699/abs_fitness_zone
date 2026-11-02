import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errors.dart';
import '../../../core/utils/phone.dart';
import '../domain/app_user.dart';

/// Authentication for staff (email + password) and members (phone + PIN
/// verified by the `member-login` Edge Function, or an email magic link).
abstract interface class AuthRepository {
  /// Emits the signed-in user (null when signed out). Emits again when the
  /// session or profile changes.
  Stream<AppUser?> watchUser();

  Future<void> signInStaff({required String email, required String password});

  Future<void> signInMember({required String phone, required String pin});

  Future<void> sendMemberMagicLink({required String email});

  /// Sets a new password for the signed-in staff user and clears the
  /// forced-password flag.
  Future<void> setPassword(String newPassword);

  Future<void> signOut();

  /// Re-reads the profile (e.g. after the forced-password flag is cleared).
  Future<void> refresh();
}

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final SupabaseClient _client;
  final _refresh = StreamController<void>.broadcast();

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

  /// Emits the profile, or an error event that does not end the stream.
  Stream<AppUser?> _safeLoad(Session? session) async* {
    try {
      yield await _loadProfile(session);
    } on NoProfileFailure {
      yield null;
    } catch (e) {
      yield* Stream<AppUser?>.error(e);
    }
  }

  Future<AppUser?> _loadProfile(Session? session) async {
    if (session == null) return null;
    try {
      final row = await _client
          .from('profiles')
          .select('id, role, name, phone, staff_id, member_id, must_set_password')
          .eq('id', session.user.id)
          .isFilter('archived_at', null)
          .maybeSingle();
      if (row == null) {
        // Authenticated but not linked to the gym: sign out rather than leave
        // a half-session behind.
        await _client.auth.signOut();
        throw const NoProfileFailure();
      }
      return AppUser.fromJson(row);
    } on AppFailure {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw _mapNetwork(e);
    }
  }

  @override
  Future<void> signInStaff({required String email, required String password}) async {
    try {
      final res = await _client.auth.signInWithPassword(email: email.trim().toLowerCase(), password: password);
      await _loadProfile(res.session);
    } on AppFailure {
      rethrow;
    } on AuthException catch (e) {
      if (e.statusCode == '400' || e.code == 'invalid_credentials') throw const InvalidCredentialsFailure();
      throw ServerFailure(e.message);
    } catch (e) {
      throw _mapNetwork(e);
    }
  }

  @override
  Future<void> signInMember({required String phone, required String pin}) async {
    final normalized = Phone.normalize(phone);
    if (normalized == null) throw const InvalidCredentialsFailure();
    try {
      final res = await _client.functions.invoke('member-login', body: {'phone': normalized, 'pin': pin});
      final data = res.data as Map<String, dynamic>;
      final auth = await _client.auth.setSession(data['refresh_token'] as String);
      await _loadProfile(auth.session);
    } on AppFailure {
      rethrow;
    } on FunctionException catch (e) {
      throw memberLoginFailure(e.status, e.details);
    } on AuthException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw _mapNetwork(e);
    }
  }

  @override
  Future<void> sendMemberMagicLink({required String email}) async {
    try {
      await _client.auth.signInWithOtp(email: email.trim().toLowerCase(), shouldCreateUser: false);
    } on AuthException {
      // Never reveal whether the email exists; the UI always says "check inbox".
      return;
    } catch (e) {
      throw _mapNetwork(e);
    }
  }

  @override
  Future<void> setPassword(String newPassword) async {
    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
      await _client.rpc<void>('mark_password_set');
      _refresh.add(null);
    } on AuthException catch (e) {
      throw ServerFailure(e.message);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw _mapNetwork(e);
    }
  }

  @override
  Future<void> signOut() => _client.auth.signOut();

  @override
  Future<void> refresh() async => _refresh.add(null);
}

/// Maps the member-login function's error response to a failure.
/// 401 → wrong PIN (with attempts left), 423 → locked until a time.
AppFailure memberLoginFailure(int status, Object? details) {
  final body = details is Map ? details : const {};
  if (status == 423) {
    final until = DateTime.tryParse('${body['locked_until']}');
    return LockedFailure(until ?? DateTime.now().add(const Duration(minutes: 15)));
  }
  if (status == 401) {
    final left = body['attempts_left'];
    return left is int ? InvalidPinFailure(left) : const InvalidCredentialsFailure();
  }
  if (status == 400) return const InvalidCredentialsFailure();
  return ServerFailure('member-login $status');
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
  Future<void> signInStaff({required String email, required String password}) async =>
      throw const NotConfiguredFailure();

  @override
  Future<void> signInMember({required String phone, required String pin}) async => throw const NotConfiguredFailure();

  @override
  Future<void> sendMemberMagicLink({required String email}) async => throw const NotConfiguredFailure();

  @override
  Future<void> setPassword(String newPassword) async => throw const NotConfiguredFailure();

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
