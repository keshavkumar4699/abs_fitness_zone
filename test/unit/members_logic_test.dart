import 'package:abs_fitness/features/members/application/member_csv.dart';
import 'package:abs_fitness/features/members/domain/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Plan.endFor matches plan_end_date() in the database', () {
    Plan plan(int v, String unit) => Plan(id: 'p', name: 'P', durationValue: v, durationUnit: unit, pricePaise: 0);

    test('months clamp to month end like Postgres', () {
      expect(plan(1, 'months').endFor(DateTime.utc(2026, 1, 31)), DateTime.utc(2026, 2, 27));
      expect(plan(3, 'months').endFor(DateTime.utc(2026, 3, 1)), DateTime.utc(2026, 5, 31));
      expect(plan(12, 'months').endFor(DateTime.utc(2026, 11, 3)), DateTime.utc(2027, 11, 2));
    });

    test('days are inclusive', () {
      expect(plan(30, 'days').endFor(DateTime.utc(2026, 3, 1)), DateTime.utc(2026, 3, 30));
      expect(plan(1, 'days').endFor(DateTime.utc(2026, 3, 1)), DateTime.utc(2026, 3, 1));
    });
  });

  test('Member days left and used fraction use IST dates', () {
    final m = Member.fromJson({
      'id': '1',
      'member_code': 'ABS-0001',
      'name': 'Riya',
      'phone': '+919876500011',
      'status': 'active',
      'membership_start': '2026-11-01',
      'membership_end': '2026-11-30',
    });
    final now = DateTime.utc(2026, 11, 10, 20); // 11 Nov IST
    expect(m.daysLeft(now: now), 19);
    expect(m.usedFraction(now: now), closeTo(10 / 30, 0.001));
    expect(m.status.isCurrent, isTrue);
    expect(MemberStatus.parse('nonsense'), MemberStatus.inactive);
  });

  group('CSV import', () {
    test('detects semicolons, strips BOM and blank lines', () {
      final rows = parseCsv('﻿Name;Mobile\r\nRiya;98765 00011\r\n\r\n;;\r\nKabir;9876500012\r\n');
      expect(rows, [
        ['Name', 'Mobile'],
        ['Riya', '98765 00011'],
        ['Kabir', '9876500012'],
      ]);
    });

    test('auto-maps common header names', () {
      final map = autoMap(['Member Name', 'Mobile No.', 'Date of Joining', 'Package', 'Valid Till', 'Remarks']);
      expect(map[ImportField.name], 0);
      expect(map[ImportField.phone], 1);
      expect(map[ImportField.joinedOn], 2);
      expect(map[ImportField.plan], 3);
      expect(map[ImportField.endDate], 4);
      expect(map[ImportField.notes], 5);
      expect(map[ImportField.email], isNull);
    });

    test('reads Indian day-first dates and rejects impossible ones', () {
      expect(parseIndianDate('03/11/2026'), DateTime.utc(2026, 11, 3));
      expect(parseIndianDate('3-11-26'), DateTime.utc(2026, 11, 3));
      expect(parseIndianDate('2026-11-03'), DateTime.utc(2026, 11, 3));
      expect(parseIndianDate('31/02/2026'), isNull);
      expect(parseIndianDate('next week'), isNull);
      expect(parseIndianDate(''), isNull);
    });

    test('validates rows and flags phones repeated in the file', () {
      final rows = buildImportRows(
        [
          ['Riya Sen', '+91 98765 00011', '15/06/1998', 'Monthly'],
          ['', '9876500012', '', ''],
          ['Kabir', '12345', '', ''],
          ['Riya Again', '09876500011', '', ''],
          ['Asha', '9876500013', '32/13/2000', ''],
        ],
        {ImportField.name: 0, ImportField.phone: 1, ImportField.dob: 2, ImportField.plan: 3},
      );
      expect(rows[0].isValid, isTrue);
      expect(rows[0].toApi(), {
        'row': 2,
        'name': 'Riya Sen',
        'phone': '+919876500011',
        'dob': '1998-06-15',
        'plan': 'Monthly',
      });
      expect(rows[1].errors, contains('name is missing'));
      expect(rows[2].errors.single, contains('not a valid Indian mobile'));
      expect(rows[3].duplicateInFile, isTrue);
      expect(rows[4].errors.single, contains('not a date'));

      final report = importErrorReport(rows, const [
        ImportRowResult(row: 2, status: 'duplicate', message: 'phone already exists'),
      ]);
      final lines = report.trim().split('\n');
      expect(lines.first, 'row,name,phone,status,reason');
      expect(lines, hasLength(1 + 4 + 1));
      expect(report, contains('phone repeated in this file'));
      expect(report, contains('2,Riya Sen,+919876500011,duplicate,phone already exists'));
    });

    test('export quotes commas and quotes', () {
      final csv = membersToCsv([
        Member.fromJson({
          'id': '1',
          'member_code': 'ABS-0001',
          'name': 'Sen, Riya "R"',
          'phone': '+919876500011',
          'status': 'expiring',
          'plan_name': 'Monthly',
          'membership_end': '2026-11-30',
        }),
      ]);
      expect(csv.split('\n')[1], 'ABS-0001,"Sen, Riya ""R""",+919876500011,,,,expiring,Monthly,,2026-11-30,,');
    });
  });

  test('MemberQuery counts active filters and round-trips through JSON', () {
    const q = MemberQuery(search: 'riya', statuses: ['expiring'], batch: 'morning', birthdayThisMonth: true);
    expect(q.activeFilters, 3);
    expect(MemberQuery.fromJson(q.toJson()), q);
  });
}
