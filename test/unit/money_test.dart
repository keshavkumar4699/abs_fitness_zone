import 'package:abs_fitness/core/utils/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Money.format', () {
    test('formats whole rupees with Indian grouping', () {
      expect(Money.format(12345600), '₹1,23,456');
      expect(Money.format(0), '₹0');
      expect(Money.format(150000), '₹1,500');
    });

    test('shows paise only when present', () {
      expect(Money.format(150050), '₹1,500.50');
      expect(Money.format(1), '₹0.01');
    });
  });

  group('Money.parse', () {
    test('parses rupee strings into paise', () {
      expect(Money.parse('1,250'), 125000);
      expect(Money.parse('₹ 1250.5'), 125050);
      expect(Money.parse('1250.05'), 125005);
      expect(Money.parse('0'), 0);
    });

    test('rejects invalid input', () {
      expect(Money.parse(''), isNull);
      expect(Money.parse('12.345'), isNull);
      expect(Money.parse('-5'), isNull);
      expect(Money.parse('abc'), isNull);
    });
  });

  group('Money.percentOf', () {
    test('uses basis points and rounds half up to the paisa', () {
      expect(Money.percentOf(100000, 1000), 10000); // 10% of ₹1,000
      expect(Money.percentOf(99999, 1800), 18000); // 18% of ₹999.99 = 17999.82 → 18000
      expect(Money.percentOf(333, 5000), 167); // 50% of 333 paise = 166.5 → 167
    });
  });
}
