import 'package:abs_fitness/app/env.dart';
import 'package:abs_fitness/core/utils/phone_input.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IndianMobileInputFormatter', () {
    test('keeps exactly the 10 local digits from pasted numbers', () {
      expect(IndianMobileInputFormatter.clean('+91 98765 43210'), '9876543210');
      expect(IndianMobileInputFormatter.clean('919876543210'), '9876543210');
      expect(IndianMobileInputFormatter.clean('09876543210'), '9876543210');
      expect(IndianMobileInputFormatter.clean('98765-43210'), '9876543210');
      expect(IndianMobileInputFormatter.clean('98765432109999'), '9876543210');
      expect(IndianMobileInputFormatter.clean('9876'), '9876');
    });
  });

  group('Env.isConfigured', () {
    Env env(String url, String key) => Env(name: 'dev', supabaseUrl: url, supabaseAnonKey: key, sentryDsn: '');

    test('rejects the example placeholders and blanks', () {
      expect(env('https://YOUR-PROJECT-REF.supabase.co', 'YOUR-ANON-KEY').isConfigured, isFalse);
      expect(env('', '').isConfigured, isFalse);
      expect(env('http://insecure.example', 'key').isConfigured, isFalse);
    });

    test('accepts a real-looking project and turns off after a startup error', () {
      final ok = env('https://abcd.supabase.co', 'sb_publishable_123');
      expect(ok.isConfigured, isTrue);
      expect(ok.withError('boom').isConfigured, isFalse);
    });
  });
}
