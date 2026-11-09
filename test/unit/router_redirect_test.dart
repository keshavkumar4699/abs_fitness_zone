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
      for (final r in [Routes.welcome, Routes.gallery]) {
        expect(go(signedOut, r), isNull, reason: r);
      }
    });

    test('old login links go to welcome (Google is the only way in)', () {
      for (final r in ['/login/staff', '/login/member', '/set-password']) {
        expect(go(signedOut, r), Routes.welcome, reason: r);
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
      expect(go(const AsyncData(deskUser), Routes.welcome), Routes.staffHome);
    });

    test('cannot open member pages', () {
      expect(go(const AsyncData(trainerUser), Routes.meHome), Routes.staffHome);
    });

    test('WhatsApp is for the front desk and owner; its settings for the owner', () {
      for (final r in [
        Routes.whatsApp,
        Routes.whatsAppBroadcast,
        Routes.whatsAppTemplates,
        Routes.memberMessages('m-1'),
      ]) {
        expect(go(const AsyncData(ownerUser), r), isNull, reason: r);
        expect(go(const AsyncData(deskUser), r), isNull, reason: r);
        expect(go(const AsyncData(trainerUser), r), Routes.staffMore, reason: r);
      }
      expect(go(const AsyncData(ownerUser), Routes.whatsAppSettings), isNull);
      expect(go(const AsyncData(deskUser), Routes.whatsAppSettings), Routes.whatsApp);
    });

    test('only the owner manages staff', () {
      expect(go(const AsyncData(ownerUser), Routes.staffTeam), isNull);
      expect(go(const AsyncData(deskUser), Routes.staffTeam), Routes.staffMore);
      expect(go(const AsyncData(trainerUser), Routes.staffTeam), Routes.staffMore);
    });

    test('only the owner opens expenses and the gym profile', () {
      expect(go(const AsyncData(ownerUser), Routes.expenses), isNull);
      expect(go(const AsyncData(deskUser), Routes.expenses), Routes.staffMore);
      expect(go(const AsyncData(deskUser), Routes.gymProfile), Routes.staffMore);
    });

    test('trainers cannot open payment pages', () {
      expect(go(const AsyncData(deskUser), Routes.dayClose), isNull);
      expect(go(const AsyncData(trainerUser), Routes.dayClose), Routes.staffPayments);
      expect(go(const AsyncData(trainerUser), Routes.invoiceDetail('x')), Routes.staffPayments);
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
      for (final r in [Routes.staffHome, Routes.staffTeam, Routes.staffPayments]) {
        expect(go(const AsyncData(memberUser), r), Routes.meHome, reason: r);
      }
    });
  });
}
