import 'dart:async';

import '../app/l10n/l10n.dart';
import 'utils/dates.dart';

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

class InvalidCredentialsFailure extends AppFailure {
  const InvalidCredentialsFailure();
}

class InvalidPinFailure extends AppFailure {
  const InvalidPinFailure(this.attemptsLeft);
  final int attemptsLeft;
}

class LockedFailure extends AppFailure {
  const LockedFailure(this.until);
  final DateTime until;
}

class NoProfileFailure extends AppFailure {
  const NoProfileFailure();
}

class StaffDeactivatedFailure extends AppFailure {
  const StaffDeactivatedFailure();
}

class SamePasswordFailure extends AppFailure {
  const SamePasswordFailure();
}

class WeakPasswordFailure extends AppFailure {
  const WeakPasswordFailure();
}

class RateLimitedFailure extends AppFailure {
  const RateLimitedFailure();
}

/// The staff email is already used by another account.
class StaffEmailTakenFailure extends AppFailure {
  const StaffEmailTakenFailure();
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
    InvalidCredentialsFailure() => l.authInvalidCredentials,
    InvalidPinFailure(:final attemptsLeft) => l.authInvalidPin(attemptsLeft),
    LockedFailure(:final until) => l.authLocked(IstDates.formatTime(until)),
    NoProfileFailure() => l.authNoProfile,
    StaffDeactivatedFailure() => l.authStaffDeactivated,
    SamePasswordFailure() => l.authSamePassword,
    WeakPasswordFailure() => l.authWeakPassword,
    RateLimitedFailure() => l.authRateLimited,
    StaffEmailTakenFailure() => l.staffInviteEmailTaken,
    NotAllowedFailure() => l.commonNotAllowed,
    NotFoundFailure() => l.memberPinNotFound,
    _ => l.commonGenericError,
  };
}
