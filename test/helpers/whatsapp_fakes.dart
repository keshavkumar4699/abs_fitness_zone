import 'package:abs_fitness/core/errors.dart';
import 'package:abs_fitness/core/paging.dart';
import 'package:abs_fitness/features/whatsapp/data/whatsapp_repository.dart';
import 'package:abs_fitness/features/whatsapp/domain/message_text.dart';
import 'package:abs_fitness/features/whatsapp/domain/whatsapp_models.dart';

/// In-memory WhatsApp backend: a queue, log, templates, festivals and
/// broadcasts that follow the database rules the screens rely on.
class FakeWhatsAppRepository implements WhatsAppRepository {
  FakeWhatsAppRepository({List<QueuedMessage>? queue, WhatsAppSettings? settings})
    : store = queue ?? sampleQueue(),
      current = settings ?? const WhatsAppSettings(automations: {'expiry': true});

  final List<QueuedMessage> store;
  WhatsAppSettings current;
  final List<MessageTemplate> templateList = sampleTemplates();
  final List<Festival> festivalList = [
    Festival(id: 'f-1', name: 'Chhath Puja', localName: 'छठ पूजा', day: DateTime.utc(2026, 11, 15)),
    Festival(id: 'f-2', name: 'Christmas', day: DateTime.utc(2026, 12, 25)),
  ];
  final List<Broadcast> broadcastList = [];
  final List<String> calls = [];
  final Map<String, bool> optOut = {};
  Object? error;
  int _seq = 100;

  /// Members and how many reach WhatsApp, per segment kind.
  Map<String, SegmentCount> counts = const {
    'all': SegmentCount(total: 5, reachable: 4),
    'active': SegmentCount(total: 3, reachable: 3),
    'members': SegmentCount(total: 2, reachable: 2),
  };

  void _maybeThrow() {
    final e = error;
    if (e != null) throw e;
  }

  @override
  Future<WhatsAppSettings> settings() async {
    _maybeThrow();
    return current;
  }

  @override
  Future<void> saveSettings(WhatsAppSettings s) async {
    _maybeThrow();
    calls.add('settings:${s.mode.wire}');
    current = s;
  }

  @override
  Future<Paged<QueuedMessage>> queue({required DateTime day, int offset = 0}) async {
    _maybeThrow();
    final open = store.where((m) => m.channel == MessageChannel.link && m.status == MessageStatus.queued).toList()
      ..sort((a, b) => a.scheduledFor.compareTo(b.scheduledFor));
    final page = open.skip(offset).take(kPageSize).toList();
    return Paged(page, hasMore: offset + page.length < open.length);
  }

  @override
  Future<Paged<QueuedMessage>> log({String? memberId, Set<MessageStatus> statuses = const {}, int offset = 0}) async {
    _maybeThrow();
    final rows =
        store
            .where((m) => memberId == null || m.memberId == memberId)
            .where((m) => statuses.isEmpty || statuses.contains(m.status))
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final page = rows.skip(offset).take(kPageSize).toList();
    return Paged(page, hasMore: offset + page.length < rows.length);
  }

  @override
  Future<QueueSummary> summary({required DateTime day}) async {
    _maybeThrow();
    return QueueSummary(
      toSend: store.where((m) => m.channel == MessageChannel.link && m.status == MessageStatus.queued).length,
      sentToday: store.where((m) => m.status.isDone).length,
    );
  }

  int _index(String id) {
    final i = store.indexWhere((m) => m.id == id);
    if (i < 0) throw const NotFoundFailure();
    return i;
  }

  @override
  Future<void> mark(String id, MessageStatus status) async {
    _maybeThrow();
    calls.add('mark:$id:${status.name}');
    final i = _index(id);
    store[i] = store[i].copyWith(
      status: status,
      sentAt: status == MessageStatus.sent ? DateTime.utc(2026, 11, 3, 4, 31) : null,
    );
  }

  @override
  Future<Map<String, int>> buildToday() async {
    _maybeThrow();
    calls.add('build');
    return {'expiry': 0, 'dues': 0, 'birthday': 0, 'festival': 0};
  }

  @override
  Future<void> sendNow() async {
    _maybeThrow();
    calls.add('send-now');
  }

  @override
  Future<void> logManual({required String memberId, required String body, String? replaces}) async {
    _maybeThrow();
    if (replaces != null) {
      final i = store.indexWhere(
        (m) =>
            m.memberId == memberId &&
            m.status == MessageStatus.queued &&
            m.channel == MessageChannel.link &&
            m.templateKey.startsWith(replaces),
      );
      if (i >= 0) {
        calls.add('replace:${store[i].id}');
        store[i] = store[i].copyWith(status: MessageStatus.sent);
        return;
      }
    }
    calls.add('manual:$memberId');
    store.add(
      QueuedMessage(
        id: 'q-${_seq++}',
        memberId: memberId,
        templateKey: 'manual',
        body: body,
        status: MessageStatus.sent,
        source: 'manual',
        scheduledFor: DateTime.utc(2026, 11, 3, 4, 30),
        sentAt: DateTime.utc(2026, 11, 3, 4, 30),
        createdAt: DateTime.utc(2026, 11, 3, 4, 30),
      ),
    );
  }

  @override
  Future<void> setOptOut({required String memberId, required bool optOut}) async {
    _maybeThrow();
    calls.add('opt:$memberId:$optOut');
    this.optOut[memberId] = optOut;
  }

  @override
  Future<List<MessageTemplate>> templates() async {
    _maybeThrow();
    return [...templateList];
  }

  @override
  Future<void> saveTemplate(MessageTemplate t) async {
    _maybeThrow();
    calls.add('template:${t.key}:${t.language}');
    final i = templateList.indexWhere((x) => x.id == t.id);
    if (i < 0) throw const NotAllowedFailure();
    templateList[i] = t;
  }

  @override
  Future<List<Festival>> festivals() async {
    _maybeThrow();
    return [...festivalList]..sort((a, b) => a.day.compareTo(b.day));
  }

  @override
  Future<void> saveFestival(Festival f) async {
    _maybeThrow();
    calls.add('festival:${f.name}');
    if (f.id.isEmpty) {
      festivalList.add(f.copyWith(id: 'f-${_seq++}'));
    } else {
      festivalList[festivalList.indexWhere((x) => x.id == f.id)] = f;
    }
  }

  @override
  Future<void> deleteFestival(String id) async {
    _maybeThrow();
    calls.add('festival-delete:$id');
    festivalList.removeWhere((x) => x.id == id);
  }

  @override
  Future<SegmentCount> segmentCount(Segment s) async {
    _maybeThrow();
    return counts[s.kind] ?? const SegmentCount(total: 1, reachable: 1);
  }

  @override
  Future<BroadcastResult> broadcast({
    required String title,
    required String body,
    required MessageCategory category,
    required Segment segment,
    DateTime? scheduledFor,
  }) async {
    _maybeThrow();
    calls.add('broadcast:${segment.kind}:${category.wire}:${segment.memberIds.join(',')}');
    final n = counts[segment.kind] ?? const SegmentCount(total: 1, reachable: 1);
    broadcastList.insert(
      0,
      Broadcast(
        id: 'b-${_seq++}',
        title: title,
        body: body,
        category: category,
        segment: segment,
        scheduledFor: scheduledFor ?? DateTime.utc(2026, 11, 3, 4, 30),
        queued: n.reachable,
        skipped: n.total - n.reachable,
        createdAt: DateTime.utc(2026, 11, 3, 4, 30),
      ),
    );
    return BroadcastResult(queued: n.reachable, skipped: n.total - n.reachable);
  }

  @override
  Future<Paged<Broadcast>> broadcasts({int offset = 0}) async {
    _maybeThrow();
    return Paged(broadcastList.skip(offset).take(kPageSize).toList(), hasMore: false);
  }

  @override
  Future<WhatsAppCost> costThisMonth() async {
    _maybeThrow();
    return const WhatsAppCost(
      utilitySent: 40,
      marketingSent: 120,
      freeWindowSent: 12,
      linkSent: 85,
      utilityPaise: 580,
      marketingPaise: 9420,
      capPaise: 20000,
    );
  }
}

/// Today's free-mode queue for the sample members (3 Nov 2026, 9:00 IST).
List<QueuedMessage> sampleQueue() {
  final nine = DateTime.utc(2026, 11, 3, 3, 30);
  QueuedMessage q(String id, String member, String name, String phone, String key, String body, {int minute = 0}) =>
      QueuedMessage(
        id: id,
        memberId: member,
        memberName: name,
        memberPhone: phone,
        templateKey: key,
        category: key == 'birthday' ? MessageCategory.marketing : MessageCategory.utility,
        body: body,
        scheduledFor: nine.add(Duration(minutes: minute)),
        createdAt: DateTime.utc(2026, 11, 3, 2, minute),
      );
  return [
    q(
      'q-1',
      'm-2',
      'Priya Verma',
      '+919876500002',
      'expiry_soon',
      'Hi Priya, your Monthly membership at ABS Fitness Zone ends on 6 Nov 2026 (3 days left). Renew at the desk or reply here to keep going 💪',
    ),
    q(
      'q-2',
      'm-3',
      'Rohit Yadav',
      '+919876500003',
      'dues_reminder',
      'Hi Rohit, ₹1,500 for INV-0003 is due on 1 Nov 2026 at ABS Fitness Zone. Pay by UPI: upi://pay?pa=absfitness@okhdfc&am=1500.00 or at the desk. Thank you!',
      minute: 1,
    ),
    q(
      'q-3',
      'm-1',
      'Aarav Sharma',
      '+919876500001',
      'birthday',
      'Happy birthday, Aarav! 🎂 Everyone at ABS Fitness Zone wishes you a strong, healthy year ahead.',
      minute: 2,
    ),
    QueuedMessage(
      id: 'q-9',
      memberId: 'm-4',
      memberName: 'Sneha Kumari',
      memberPhone: '+919876500004',
      templateKey: 'payment_received',
      body: "Hi Sneha, we've received ₹4,000 (receipt RCP-0009). Thank you for training with ABS Fitness Zone!",
      status: MessageStatus.read,
      channel: MessageChannel.api,
      scheduledFor: DateTime.utc(2026, 11, 2, 12),
      sentAt: DateTime.utc(2026, 11, 2, 12),
      readAt: DateTime.utc(2026, 11, 2, 12, 5),
      createdAt: DateTime.utc(2026, 11, 2, 12),
    ),
  ];
}

List<MessageTemplate> sampleTemplates() {
  MessageTemplate t(String key, String lang, String title, String body, {bool marketing = false}) => MessageTemplate(
    id: '$key-$lang',
    key: key,
    language: lang,
    title: title,
    body: body,
    category: marketing ? MessageCategory.marketing : MessageCategory.utility,
    isSystem: true,
  );
  return [
    t(
      'expiry_soon',
      'en',
      'Membership ending soon',
      'Hi {first_name}, your {plan} membership at {gym_name} ends on {end_date} ({days} days left). Renew at the desk or reply here to keep going 💪',
    ),
    t(
      'expiry_soon',
      'hi',
      'मेंबरशिप ख़त्म होने वाली है',
      'नमस्ते {first_name}, {gym_name} में आपकी {plan} मेंबरशिप {end_date} को ख़त्म हो रही है ({days} दिन बाकी)।',
    ),
    t(
      'birthday',
      'en',
      'Birthday wishes',
      'Happy birthday, {first_name}! 🎂 Everyone at {gym_name} wishes you a strong, healthy year ahead.',
      marketing: true,
    ),
  ];
}

/// Records wa.me launches instead of leaving the app.
class FakeLauncher {
  final List<(String, String)> opened = [];
  bool works = true;

  Future<bool> call(String phone, String text) async {
    if (!works) return false;
    opened.add((phone, text));
    return true;
  }
}

/// The sample body rendered for a member, as the database would.
String rendered(String body, String firstName) =>
    renderMessage(body, sampleVariables(firstName: firstName, gym: 'ABS Fitness Zone'));
