import 'package:abs_fitness/app/l10n/gen/app_localizations_en.dart';
import 'package:abs_fitness/core/errors.dart';
import 'package:abs_fitness/features/auth/data/auth_repository.dart';
import 'package:abs_fitness/features/auth/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('linkFailure', () {
    PostgrestException err(String code) => PostgrestException(message: 'x', code: code);

    test('maps link_my_account refusals to explainable failures', () {
      expect(linkFailure(err('P0002')), isA<NoProfileFailure>());
      expect(linkFailure(err('AB001')), isA<StaffDeactivatedFailure>());
      expect(linkFailure(err('AB002')), isA<SharedEmailFailure>());
      expect(linkFailure(err('42501')), isA<GoogleOnlyFailure>());
      expect(linkFailure(err('XX000')), isA<ServerFailure>());
    });
  });

  group('authFailure', () {
    test('rate limits and refused sign-ups are explained', () {
      expect(authFailure(const AuthException('x', statusCode: '429')), isA<RateLimitedFailure>());
      expect(authFailure(const AuthException('x', code: 'over_request_rate_limit')), isA<RateLimitedFailure>());
      // The optional sign-up hook refuses unknown Gmails with a 403.
      expect(authFailure(const AuthException('x', statusCode: '403')), isA<NoProfileFailure>());
      expect(authFailure(const AuthException('x', statusCode: '500')), isA<ServerFailure>());
    });
  });

  test('friendlyError explains each failure in plain language', () {
    final l = AppLocalizationsEn();
    expect(friendlyError(l, const NoProfileFailure()), contains('add your Gmail'));
    expect(friendlyError(l, const SharedEmailFailure()), contains('more than one member'));
    expect(friendlyError(l, const GoogleOnlyFailure()), contains('Google'));
    expect(friendlyError(l, const StaffDeactivatedFailure()), contains('turned off'));
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
    });
    expect(u.role, UserRole.frontDesk);
    expect(u.role.isDesk, isTrue);
    expect(u.role.canSeeRevenue, isFalse);
  });
}
