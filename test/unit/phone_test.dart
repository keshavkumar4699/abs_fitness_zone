import 'package:abs_fitness/core/utils/phone.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('normalises common Indian mobile formats to +91', () {
    for (final input in ['9876543210', '98765 43210', '+91-98765-43210', '09876543210', '919876543210']) {
      expect(Phone.normalize(input), '+919876543210', reason: input);
    }
  });

  test('rejects landlines, short numbers and non-Indian prefixes', () {
    for (final input in ['5876543210', '987654321', '+1 415 555 0100', '', 'phone']) {
      expect(Phone.normalize(input), isNull, reason: input);
    }
  });

  test('display and local formats', () {
    expect(Phone.display('+919876543210'), '+91 98765 43210');
    expect(Phone.local('+919876543210'), '9876543210');
  });
}
