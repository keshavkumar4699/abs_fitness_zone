import 'package:abs_fitness/app/l10n/gen/app_localizations_en.dart';
import 'package:abs_fitness/core/errors.dart';
import 'package:abs_fitness/features/auth/data/auth_repository.dart';
import 'package:abs_fitness/features/auth/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('memberLoginFailure', () {
    test('401 with attempts left → InvalidPinFailure', () {
      final f = memberLoginFailure(401, {'attempts_left': 3});
      expect(f, isA<InvalidPinFailure>().having((e) => e.attemptsLeft, 'attemptsLeft', 3));
    });

    test('423 → LockedFailure with the server time', () {
      final f = memberLoginFailure(423, {'locked_until': '2026-11-02T10:15:00Z'});
      expect(f, isA<LockedFailure>().having((e) => e.until, 'until', DateTime.utc(2026, 11, 2, 10, 15)));
    });

    test('400 and 401 without details → InvalidCredentialsFailure', () {
      expect(memberLoginFailure(400, null), isA<InvalidCredentialsFailure>());
      expect(memberLoginFailure(401, {'attempts_left': null}), isA<InvalidCredentialsFailure>());
    });
  });

  test('friendlyError explains each failure in plain language', () {
    final l = AppLocalizationsEn();
    expect(friendlyError(l, const InvalidPinFailure(1)), contains('1 attempt left'));
    expect(friendlyError(l, const InvalidPinFailure(3)), contains('3 attempts left'));
    expect(friendlyError(l, LockedFailure(DateTime.utc(2026, 11, 2, 10, 15))), contains('3:45 pm'));
    expect(friendlyError(l, const NetworkFailure()), l.commonNetworkError);
    expect(friendlyError(l, StateError('boom')), l.commonGenericError);
  });

  test('AppUser parses a profiles row', () {
    final u = AppUser.fromJson({
      'id': 'abc',
      'role': 'front_desk',
      'name': 'Neha',
      'phone': null,
      'staff_id': 's1',
      'member_id': null,
      'must_set_password': true,
    });
    expect(u.role, UserRole.frontDesk);
    expect(u.role.isDesk, isTrue);
    expect(u.role.canSeeRevenue, isFalse);
    expect(u.mustSetPassword, isTrue);
  });
}
