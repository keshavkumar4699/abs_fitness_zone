import 'package:abs_fitness/core/utils/dates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('converts UTC instants to IST wall-clock time', () {
    final ist = IstDates.toIst(DateTime.utc(2026, 11, 2, 18, 45));
    expect([ist.year, ist.month, ist.day, ist.hour, ist.minute], [2026, 11, 3, 0, 15]);
  });

  test('IST date rolls over at 18:30 UTC', () {
    expect(IstDates.istDate(DateTime.utc(2026, 11, 2, 18, 29)), DateTime.utc(2026, 11, 2));
    expect(IstDates.istDate(DateTime.utc(2026, 11, 2, 18, 30)), DateTime.utc(2026, 11, 3));
  });

  test('daysUntil counts IST calendar days', () {
    final now = DateTime.utc(2026, 11, 2, 20); // 3 Nov, 01:30 IST
    expect(IstDates.daysUntil(DateTime(2026, 11, 10), now: now), 7);
    expect(IstDates.daysUntil(DateTime(2026, 11, 3), now: now), 0);
    expect(IstDates.daysUntil(DateTime(2026, 11, 1), now: now), -2);
  });

  test('formats dates and times in IST', () {
    final instant = DateTime.utc(2026, 11, 2, 13, 15);
    expect(IstDates.formatDate(instant), '2 Nov 2026');
    expect(IstDates.formatTime(instant), '6:45 pm');
    expect(IstDates.formatDateTime(instant), '2 Nov, 6:45 pm');
  });
}
