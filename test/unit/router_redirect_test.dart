import 'package:abs_fitness/app/routes.dart';
import 'package:abs_fitness/features/auth/domain/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

String? go(AsyncValue<AppUser?> auth, String location, {bool onboarded = true}) =>
    authRedirect(auth: auth, onboardingDone: onboarded, location: location);

void main() {
  const signedOut = AsyncData<AppUser?>(null);

  group('while loading', () {
    test('holds on the splash screen', () {
      expect(go(const AsyncLoading(), Routes.splash), isNull);
      expect(go(const AsyncLoading(), Routes.staffHome), Routes.splash);
    });

    test('an error before any value stays on splash (error + retry)', () {
      expect(go(AsyncError<AppUser?>(Exception(), StackTrace.empty), Routes.staffHome), Routes.splash);
    });
  });

  group('signed out', () {
    test('may open public pages', () {
      for (final r in [Routes.welcome, Routes.staffLogin, Routes.memberLogin, Routes.gallery]) {
        expect(go(signedOut, r), isNull, reason: r);
      }
    });

    test('is sent to welcome from anything else', () {
      for (final r in [Routes.splash, Routes.staffHome, Routes.meHome, Routes.staffTeam]) {
        expect(go(signedOut, r), Routes.welcome, reason: r);
      }
    });
  });

  group('staff', () {
    test('land on staff home', () {
      expect(go(const AsyncData(ownerUser), Routes.splash), Routes.staffHome);
      expect(go(const AsyncData(deskUser), Routes.staffLogin), Routes.staffHome);
    });

    test('cannot open member pages', () {
      expect(go(const AsyncData(trainerUser), Routes.meHome), Routes.staffHome);
    });

    test('must set a password first', () {
      final fresh = AsyncData<AppUser?>(deskUser.copyWith(mustSetPassword: true));
      expect(go(fresh, Routes.staffHome), Routes.setPassword);
      expect(go(fresh, Routes.setPassword), isNull);
    });

    test('only the owner manages staff', () {
      expect(go(const AsyncData(ownerUser), Routes.staffTeam), isNull);
      expect(go(const AsyncData(deskUser), Routes.staffTeam), Routes.staffMore);
      expect(go(const AsyncData(trainerUser), Routes.staffTeam), Routes.staffMore);
    });

    test('only owner and front desk set member PINs', () {
      expect(go(const AsyncData(ownerUser), Routes.memberPin), isNull);
      expect(go(const AsyncData(deskUser), Routes.memberPin), isNull);
      expect(go(const AsyncData(trainerUser), Routes.memberPin), Routes.staffMore);
    });

    test('gallery is reachable for the owner only once signed in', () {
      expect(go(const AsyncData(ownerUser), Routes.gallery), isNull);
      expect(go(const AsyncData(deskUser), Routes.gallery), Routes.staffHome);
    });
  });

  group('members', () {
    test('see onboarding once, then member home', () {
      expect(go(const AsyncData(memberUser), Routes.splash, onboarded: false), Routes.onboarding);
      expect(go(const AsyncData(memberUser), Routes.onboarding, onboarded: false), isNull);
      expect(go(const AsyncData(memberUser), Routes.onboarding), Routes.meHome);
    });

    test('cannot open staff pages', () {
      for (final r in [Routes.staffHome, Routes.staffTeam, Routes.memberPin]) {
        expect(go(const AsyncData(memberUser), r), Routes.meHome, reason: r);
      }
    });
  });
}
