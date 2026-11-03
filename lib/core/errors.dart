import 'dart:async';

import '../app/l10n/l10n.dart';

/// Failures the UI knows how to explain. Repositories translate backend
/// errors into these so screens never show raw exception text.
sealed class AppFailure implements Exception {
  const AppFailure();
}

class NetworkFailure extends AppFailure {
  const NetworkFailure();
}

class NotConfiguredFailure extends AppFailure {
  const NotConfiguredFailure();
}

/// This Google account's email isn't on any staff or member record.
class NoProfileFailure extends AppFailure {
  const NoProfileFailure();
}

class StaffDeactivatedFailure extends AppFailure {
  const StaffDeactivatedFailure();
}

/// The Gmail is on more than one member record, so it can't pick one.
class SharedEmailFailure extends AppFailure {
  const SharedEmailFailure();
}

/// The login isn't a verified Google account (only Google is accepted).
class GoogleOnlyFailure extends AppFailure {
  const GoogleOnlyFailure();
}

/// The person closed the Google window or the sign-in didn't finish.
class SignInCancelledFailure extends AppFailure {
  const SignInCancelledFailure();
}

class RateLimitedFailure extends AppFailure {
  const RateLimitedFailure();
}

/// The staff email is already used by another account.
class StaffEmailTakenFailure extends AppFailure {
  const StaffEmailTakenFailure();
}

/// Another member already has this phone number.
class DuplicatePhoneFailure extends AppFailure {
  const DuplicatePhoneFailure();
}

/// A business rule in the database refused the change; [message] explains
/// it (e.g. "only 3 freeze days left on this plan").
class RuleFailure extends AppFailure {
  const RuleFailure(this.message);
  final String message;
}

/// The user may not perform this action (RLS / role check said no).
class NotAllowedFailure extends AppFailure {
  const NotAllowedFailure();
}

class NotFoundFailure extends AppFailure {
  const NotFoundFailure();
}

class ServerFailure extends AppFailure {
  const ServerFailure([this.message]);
  final String? message;

  @override
  String toString() => 'ServerFailure($message)';
}

/// Human-readable, localised message for any error.
String friendlyError(AppLocalizations l, Object error) {
  return switch (error) {
    NetworkFailure() || TimeoutException() => l.commonNetworkError,
    NotConfiguredFailure() => l.authNotConfigured,
    NoProfileFailure() => l.authNoProfile,
    StaffDeactivatedFailure() => l.authStaffDeactivated,
    SharedEmailFailure() => l.authSharedEmail,
    GoogleOnlyFailure() => l.authGoogleOnly,
    SignInCancelledFailure() => l.authCancelled,
    RateLimitedFailure() => l.authRateLimited,
    StaffEmailTakenFailure() => l.staffInviteEmailTaken,
    NotAllowedFailure() => l.commonNotAllowed,
    DuplicatePhoneFailure() => l.memberDuplicatePhone,
    RuleFailure(:final message) => _sentence(message),
    NotFoundFailure() => l.commonNotFound,
    _ => l.commonGenericError,
  };
}

String _sentence(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}${s.endsWith('.') ? '' : '.'}';
