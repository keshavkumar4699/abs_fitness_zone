import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/dates.dart';

part 'models.freezed.dart';
part 'models.g.dart';

/// Computed by the database status engine.
enum MemberStatus {
  active,
  expiring,
  expired,
  frozen,
  cancelled,
  inactive,
  pending,
  upcoming;

  static MemberStatus parse(String? v) =>
      MemberStatus.values.firstWhere((s) => s.name == v, orElse: () => MemberStatus.inactive);

  /// Counts as a current, paying member.
  bool get isCurrent => this == active || this == expiring;
}

DateTime? _date(Object? v) => v == null || v == '' ? null : DateTime.parse(v as String);
String? _dateOut(DateTime? d) => d == null
    ? null
    : '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
MemberStatus _status(Object? v) => MemberStatus.parse(v as String?);
String _statusOut(MemberStatus s) => s.name;

/// A row of `members` (1.1) with the engine's snapshot of the current plan.
@freezed
abstract class Member with _$Member {
  const Member._();

  const factory Member({
    required String id,
    @JsonKey(name: 'member_code') required String memberCode,
    required String name,
    required String phone,
    @JsonKey(name: 'alt_phone') String? altPhone,
    String? email,
    String? gender,
    @JsonKey(fromJson: _date, toJson: _dateOut) DateTime? dob,
    String? address,
    @JsonKey(name: 'emergency_name') String? emergencyName,
    @JsonKey(name: 'emergency_relation') String? emergencyRelation,
    @JsonKey(name: 'emergency_phone') String? emergencyPhone,
    @JsonKey(name: 'blood_group') String? bloodGroup,
    @JsonKey(name: 'photo_url') String? photoPath,
    String? goal,
    String? level,
    @JsonKey(name: 'diet_pref') String? dietPref,
    @Default('en') String language,
    @JsonKey(name: 'trainer_id') String? trainerId,
    String? batch,
    String? source,
    @JsonKey(fromJson: _status, toJson: _statusOut) @Default(MemberStatus.inactive) MemberStatus status,
    @JsonKey(name: 'joined_on', fromJson: _date, toJson: _dateOut) DateTime? joinedOn,
    String? notes,
    @JsonKey(name: 'plan_name') String? planName,
    @JsonKey(name: 'membership_start', fromJson: _date, toJson: _dateOut) DateTime? membershipStart,
    @JsonKey(name: 'membership_end', fromJson: _date, toJson: _dateOut) DateTime? membershipEnd,
    @JsonKey(name: 'current_membership_id') String? currentMembershipId,
    @JsonKey(name: 'whatsapp_opt_out') @Default(false) bool whatsappOptOut,
    @JsonKey(name: 'archived_at') DateTime? archivedAt,
    @JsonKey(name: 'dues_paise') @Default(0) int duesPaise,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

  /// Days until the current membership ends (negative once expired).
  int? daysLeft({DateTime? now}) => membershipEnd == null ? null : IstDates.daysUntil(membershipEnd!, now: now);

  /// Share of the current membership already used, 0..1.
  double usedFraction({DateTime? now}) {
    final s = membershipStart;
    final e = membershipEnd;
    if (s == null || e == null) return 0;
    final total = e.difference(s).inDays + 1;
    final left = (daysLeft(now: now) ?? 0) + 1;
    return total <= 0 ? 1 : (1 - left / total).clamp(0.0, 1.0);
  }

  bool get isArchived => archivedAt != null;
}

@freezed
abstract class Plan with _$Plan {
  const Plan._();

  const factory Plan({
    required String id,
    required String name,
    @JsonKey(name: 'duration_value') required int durationValue,
    @JsonKey(name: 'duration_unit') @Default('months') String durationUnit,
    @JsonKey(name: 'price_paise') required int pricePaise,
    @JsonKey(name: 'joining_fee_paise') @Default(0) int joiningFeePaise,
    @JsonKey(name: 'gst_rate') @Default(0) num gstRate,
    @JsonKey(name: 'includes_pt') @Default(false) bool includesPt,
    @JsonKey(name: 'sessions_limit') int? sessionsLimit,
    @JsonKey(name: 'freeze_days_allowed') @Default(0) int freezeDaysAllowed,
    @Default('lime') String color,
    String? description,
    @JsonKey(name: 'is_archived') @Default(false) bool isArchived,
  }) = _Plan;

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);

  /// End date for a membership starting on [start] (inclusive), matching
  /// `plan_end_date()` in the database.
  DateTime endFor(DateTime start) {
    if (durationUnit == 'months') {
      final target = DateTime.utc(start.year, start.month + durationValue, 1);
      final lastDay = DateTime.utc(target.year, target.month + 1, 0).day;
      final day = start.day > lastDay ? lastDay : start.day;
      return DateTime.utc(target.year, target.month, day).subtract(const Duration(days: 1));
    }
    return DateTime.utc(start.year, start.month, start.day).add(Duration(days: durationValue - 1));
  }
}

@freezed
abstract class Addon with _$Addon {
  const factory Addon({
    required String id,
    required String name,
    @JsonKey(name: 'price_paise') required int pricePaise,
    @Default('other') String kind,
    @JsonKey(name: 'is_archived') @Default(false) bool isArchived,
  }) = _Addon;

  factory Addon.fromJson(Map<String, dynamic> json) => _$AddonFromJson(json);
}

@freezed
abstract class MembershipFreeze with _$MembershipFreeze {
  const factory MembershipFreeze({
    required String id,
    @JsonKey(name: 'from_date', fromJson: _date, toJson: _dateOut) required DateTime? fromDate,
    @JsonKey(name: 'to_date', fromJson: _date, toJson: _dateOut) required DateTime? toDate,
    String? reason,
  }) = _MembershipFreeze;

  factory MembershipFreeze.fromJson(Map<String, dynamic> json) => _$MembershipFreezeFromJson(json);
}

@freezed
abstract class Membership with _$Membership {
  const Membership._();

  const factory Membership({
    required String id,
    @JsonKey(name: 'member_id') required String memberId,
    @JsonKey(name: 'plan_id') required String planId,
    @JsonKey(name: 'plan_name') required String planName,
    @JsonKey(name: 'start_date', fromJson: _date, toJson: _dateOut) required DateTime? startDate,
    @JsonKey(name: 'end_date', fromJson: _date, toJson: _dateOut) required DateTime? endDate,
    @JsonKey(fromJson: _status, toJson: _statusOut) @Default(MemberStatus.active) MemberStatus status,
    @JsonKey(name: 'price_paise') @Default(0) int pricePaise,
    @JsonKey(name: 'joining_fee_paise') @Default(0) int joiningFeePaise,
    @JsonKey(name: 'addons_paise') @Default(0) int addonsPaise,
    @JsonKey(name: 'discount_paise') @Default(0) int discountPaise,
    @JsonKey(name: 'discount_reason') String? discountReason,
    @JsonKey(name: 'freeze_days_used') @Default(0) int freezeDaysUsed,
    @Default('new') String source,
    @JsonKey(name: 'cancelled_reason') String? cancelledReason,
    @JsonKey(name: 'membership_freezes') @Default([]) List<MembershipFreeze> freezes,
  }) = _Membership;

  factory Membership.fromJson(Map<String, dynamic> json) => _$MembershipFromJson(json);

  int get totalPaise => pricePaise + joiningFeePaise + addonsPaise - discountPaise;

  /// The freeze covering [today] or starting later, if any.
  MembershipFreeze? openFreeze(DateTime today) {
    for (final f in freezes) {
      if (f.toDate != null && !f.toDate!.isBefore(DateTime(today.year, today.month, today.day))) return f;
    }
    return null;
  }
}

@freezed
abstract class MemberHealth with _$MemberHealth {
  const factory MemberHealth({
    @JsonKey(name: 'member_id') required String memberId,
    @JsonKey(name: 'height_cm') num? heightCm,
    @JsonKey(name: 'weight_kg') num? weightKg,
    String? conditions,
    String? injuries,
    String? medications,
    @Default(<String, dynamic>{}) Map<String, dynamic> parq,
    @JsonKey(name: 'doctor_clearance') @Default(false) bool doctorClearance,
  }) = _MemberHealth;

  factory MemberHealth.fromJson(Map<String, dynamic> json) => _$MemberHealthFromJson(json);
}

@freezed
abstract class Measurement with _$Measurement {
  const factory Measurement({
    String? id,
    @JsonKey(name: 'member_id') required String memberId,
    @JsonKey(name: 'measured_on', fromJson: _date, toJson: _dateOut) required DateTime? measuredOn,
    @JsonKey(name: 'weight_kg') num? weightKg,
    @JsonKey(name: 'body_fat') num? bodyFat,
    num? chest,
    num? waist,
    num? hips,
    num? arms,
    num? thighs,
    String? notes,
  }) = _Measurement;

  factory Measurement.fromJson(Map<String, dynamic> json) => _$MeasurementFromJson(json);
}

@freezed
abstract class Attendance with _$Attendance {
  const factory Attendance({
    required String id,
    @JsonKey(name: 'member_id') required String memberId,
    @JsonKey(fromJson: _date, toJson: _dateOut) required DateTime? day,
    @JsonKey(name: 'checked_in_at') required DateTime checkedInAt,
    @JsonKey(name: 'checked_out_at') DateTime? checkedOutAt,
    required String method,
    @JsonKey(includeToJson: false) String? memberName,
  }) = _Attendance;

  factory Attendance.fromJson(Map<String, dynamic> json) => _$AttendanceFromJson(json);
}

@freezed
abstract class MemberEvent with _$MemberEvent {
  const factory MemberEvent({
    required int id,
    required String kind,
    required String title,
    @Default(<String, dynamic>{}) Map<String, dynamic> data,
    required DateTime at,
  }) = _MemberEvent;

  factory MemberEvent.fromJson(Map<String, dynamic> json) => _$MemberEventFromJson(json);
}

/// What `check_in` / `self_check_in` return, for the success or warning screen.
@freezed
abstract class CheckInResult with _$CheckInResult {
  const CheckInResult._();

  const factory CheckInResult({
    @JsonKey(name: 'member_id') required String memberId,
    required String name,
    @JsonKey(name: 'member_code') required String memberCode,
    @JsonKey(name: 'photo_url') String? photoPath,
    @JsonKey(fromJson: _status, toJson: _statusOut) required MemberStatus status,
    @JsonKey(name: 'plan_name') String? planName,
    @JsonKey(name: 'days_left') int? daysLeft,
    @Default(false) bool already,
    @JsonKey(name: 'checked_out_at') DateTime? checkedOutAt,
    @JsonKey(name: 'dues_paise') @Default(0) int duesPaise,
  }) = _CheckInResult;

  factory CheckInResult.fromJson(Map<String, dynamic> json) => _$CheckInResultFromJson(json);

  /// Expired, cancelled, inactive or never had a plan: let the desk know.
  bool get needsAttention => !status.isCurrent;

  /// Unpaid fees to mention at the desk (2.9).
  bool get hasDues => duesPaise > 0;
}

@freezed
abstract class DashboardCounts with _$DashboardCounts {
  const factory DashboardCounts({
    @Default(0) int active,
    @Default(0) int expiring,
    @Default(0) int expired,
    @Default(0) int frozen,
    @Default(0) int total,
    @JsonKey(name: 'new_this_month') @Default(0) int newThisMonth,
    @JsonKey(name: 'checkins_today') @Default(0) int checkinsToday,
  }) = _DashboardCounts;

  factory DashboardCounts.fromJson(Map<String, dynamic> json) => _$DashboardCountsFromJson(json);
}

enum ActionReason { overdue, renewalDue, expired, birthday, absent }

@freezed
abstract class NeedsAction with _$NeedsAction {
  const factory NeedsAction({
    @JsonKey(name: 'member_id') required String memberId,
    required String name,
    required String phone,
    @JsonKey(name: 'photo_url') String? photoPath,
    @JsonKey(fromJson: _reason, toJson: _reasonOut) required ActionReason reason,
    String? detail,
  }) = _NeedsAction;

  factory NeedsAction.fromJson(Map<String, dynamic> json) => _$NeedsActionFromJson(json);
}

ActionReason _reason(Object? v) => switch (v) {
  'overdue' => ActionReason.overdue,
  'renewal_due' => ActionReason.renewalDue,
  'expired' => ActionReason.expired,
  'birthday' => ActionReason.birthday,
  _ => ActionReason.absent,
};
String _reasonOut(ActionReason r) => switch (r) {
  ActionReason.overdue => 'overdue',
  ActionReason.renewalDue => 'renewal_due',
  ActionReason.expired => 'expired',
  ActionReason.birthday => 'birthday',
  ActionReason.absent => 'absent',
};

enum MemberSort { name, endDate, joined }

/// Search + filters for the members list (1.13). Serialisable so filters can
/// be saved on the device.
@freezed
abstract class MemberQuery with _$MemberQuery {
  const MemberQuery._();

  const factory MemberQuery({
    @Default('') String search,
    @Default(<String>[]) List<String> statuses,
    String? planName,
    String? trainerId,
    String? batch,
    String? gender,
    @Default(false) bool birthdayThisMonth,
    @JsonKey(fromJson: _date, toJson: _dateOut) DateTime? joinedFrom,
    @JsonKey(fromJson: _date, toJson: _dateOut) DateTime? joinedTo,
    @Default(MemberSort.name) MemberSort sort,
    @Default(false) bool includeArchived,
  }) = _MemberQuery;

  factory MemberQuery.fromJson(Map<String, dynamic> json) => _$MemberQueryFromJson(json);

  /// Number of filters set besides search and sort (for the filter badge).
  int get activeFilters =>
      (statuses.isEmpty ? 0 : 1) +
      (planName == null ? 0 : 1) +
      (trainerId == null ? 0 : 1) +
      (batch == null ? 0 : 1) +
      (gender == null ? 0 : 1) +
      (birthdayThisMonth ? 1 : 0) +
      (joinedFrom == null && joinedTo == null ? 0 : 1) +
      (includeArchived ? 1 : 0);
}

/// Input for the add-member flow.
class NewMember {
  NewMember({
    required this.member,
    this.health,
    this.planId,
    this.startDate,
    this.discountPaise = 0,
    this.discountReason,
    this.addonIds = const [],
  });

  final Map<String, dynamic> member;
  final Map<String, dynamic>? health;
  final String? planId;
  final DateTime? startDate;
  final int discountPaise;
  final String? discountReason;
  final List<String> addonIds;
}

/// Result of importing one spreadsheet row.
class ImportRowResult {
  const ImportRowResult({required this.row, required this.status, this.message, this.memberCode});

  factory ImportRowResult.fromJson(Map<String, dynamic> j) => ImportRowResult(
    row: (j['row'] as num).toInt(),
    status: j['status'] as String,
    message: j['message'] as String?,
    memberCode: j['member_code'] as String?,
  );

  final int row;

  /// imported | duplicate | error
  final String status;
  final String? message;
  final String? memberCode;
}

String? dateParam(DateTime? d) => _dateOut(d);

/// What `check_out` returns: the visit that just ended.
@freezed
abstract class CheckOutResult with _$CheckOutResult {
  const factory CheckOutResult({
    @JsonKey(name: 'member_id') required String memberId,
    @JsonKey(name: 'checked_in_at') required DateTime checkedInAt,
    @JsonKey(name: 'checked_out_at') required DateTime checkedOutAt,
    @Default(0) int minutes,
  }) = _CheckOutResult;

  factory CheckOutResult.fromJson(Map<String, dynamic> json) => _$CheckOutResultFromJson(json);
}
