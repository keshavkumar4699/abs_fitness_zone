import 'package:abs_fitness/features/whatsapp/data/whatsapp_repository.dart';
import 'package:abs_fitness/features/whatsapp/domain/message_text.dart';
import 'package:abs_fitness/features/whatsapp/domain/whatsapp_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('renderMessage matches the database _render', () {
    test('fills every occurrence and drops unknown variables', () {
      expect(
        renderMessage('Hi {first_name}, {first_name}! {unknown}See you at {gym_name}.', {
          'first_name': 'Riya',
          'gym_name': 'ABS Fitness Zone',
        }),
        'Hi Riya, Riya! See you at ABS Fitness Zone.',
      );
    });

    test('leaves braces that are not variables alone', () {
      expect(renderMessage('Price {₹500} or {A} or {}', const {}), 'Price {₹500} or {A} or {}');
    });
  });

  test('variables in order, and Meta numbering for API templates', () {
    const body = 'Hi {first_name}, {amount} for {invoice_no} is due on {due_date}. Pay: {pay_link}';
    expect(messageVariables(body), ['first_name', 'amount', 'invoice_no', 'due_date', 'pay_link']);
    expect(metaTemplateBody(body), 'Hi {{1}}, {{2}} for {{3}} is due on {{4}}. Pay: {{5}}');
  });

  test('every template has a sample value for each of its variables', () {
    final sample = sampleVariables(firstName: 'Riya', gym: 'ABS');
    for (final vars in [...kMessageVariables.values, kBroadcastVariables]) {
      for (final v in vars) {
        expect(sample.containsKey(v), isTrue, reason: v);
      }
    }
  });

  group('segments', () {
    test('serialise only what the kind needs', () {
      expect(const Segment('trainer', trainerId: 's-1', batch: 'x').toJson(), {'kind': 'trainer', 'trainer_id': 's-1'});
      expect(const Segment('batch', batch: 'morning').toJson(), {'kind': 'batch', 'batch': 'morning'});
      expect(const Segment('members', memberIds: ['m-1', 'm-2']).toJson(), {
        'kind': 'members',
        'member_ids': ['m-1', 'm-2'],
      });
      expect(Segment.all.toJson(), {'kind': 'all'});
    });

    test('round-trip and compare by value (used as a provider key)', () {
      final s = Segment.fromJson({'kind': 'trainer', 'trainer_id': 's-1'});
      expect(s, const Segment('trainer', trainerId: 's-1'));
      expect(s.hashCode, const Segment('trainer', trainerId: 's-1').hashCode);
      expect(Segment.fromJson(null), Segment.all);
    });

    test('a trainer or batch segment needs its pick before it can be sent', () {
      expect(const Segment('trainer').isComplete, isFalse);
      expect(const Segment('batch').isComplete, isFalse);
      expect(const Segment('members').isComplete, isFalse);
      expect(const Segment('active').isComplete, isTrue);
    });
  });

  test('settings read from whatsapp_settings() and write back to the settings table', () {
    final s = WhatsAppSettings.fromJson({
      'mode': 'api',
      'expiry_days': [7, 3, 0, -3],
      'due_days': [3, 0, -3],
      'automations': {'birthday': false},
      'prices': {'utility_per_100_paise': 1450, 'marketing_per_100_paise': 7850},
      'marketing_cap_paise': 20000,
    });
    expect(s.mode, WhatsAppMode.api);
    expect(s.automation('birthday'), isFalse);
    expect(s.automation('expiry'), isTrue);
    final rows = s.copyWith(expiryDays: [0, 7, -3]).toSettings();
    expect(rows['whatsapp_mode'], 'api');
    expect(rows['expiry_reminder_days'], [7, 0, -3]);
    expect((rows['whatsapp_automations']! as Map)['birthday'], isFalse);
    expect(rows['whatsapp_marketing_cap_paise'], 20000);
  });

  test('a queue row reads the member name from the joined row', () {
    final m = QueuedMessage.fromJson({
      'id': 'q-1',
      'member_id': 'm-1',
      'template_key': 'broadcast_0f9a',
      'language': 'hi',
      'category': 'marketing',
      'body': 'Hello',
      'channel': 'api',
      'scheduled_for': '2026-11-03T03:30:00+00:00',
      'status': 'delivered',
      'created_at': '2026-11-03T02:00:00+00:00',
      'member': {'name': 'Riya Sharma', 'phone': '+919876500001', 'photo_url': null},
    });
    expect(m.memberName, 'Riya Sharma');
    expect(m.memberPhone, '+919876500001');
    expect(m.kind, 'broadcast');
    expect(m.status.isDone, isTrue);
    expect(m.channel, MessageChannel.api);
  });

  test('the end of an IST day is 18:30 UTC', () {
    expect(endOfIstDay(DateTime.utc(2026, 11, 3)), DateTime.utc(2026, 11, 3, 18, 30));
  });
}
