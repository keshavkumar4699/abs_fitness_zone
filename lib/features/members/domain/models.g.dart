// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Member _$MemberFromJson(Map<String, dynamic> json) => _Member(
  id: json['id'] as String,
  memberCode: json['member_code'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  altPhone: json['alt_phone'] as String?,
  email: json['email'] as String?,
  gender: json['gender'] as String?,
  dob: _date(json['dob']),
  address: json['address'] as String?,
  emergencyName: json['emergency_name'] as String?,
  emergencyRelation: json['emergency_relation'] as String?,
  emergencyPhone: json['emergency_phone'] as String?,
  bloodGroup: json['blood_group'] as String?,
  photoPath: json['photo_url'] as String?,
  goal: json['goal'] as String?,
  level: json['level'] as String?,
  dietPref: json['diet_pref'] as String?,
  language: json['language'] as String? ?? 'en',
  trainerId: json['trainer_id'] as String?,
  batch: json['batch'] as String?,
  source: json['source'] as String?,
  status: json['status'] == null ? MemberStatus.inactive : _status(json['status']),
  joinedOn: _date(json['joined_on']),
  notes: json['notes'] as String?,
  planName: json['plan_name'] as String?,
  membershipStart: _date(json['membership_start']),
  membershipEnd: _date(json['membership_end']),
  currentMembershipId: json['current_membership_id'] as String?,
  whatsappOptOut: json['whatsapp_opt_out'] as bool? ?? false,
  archivedAt: json['archived_at'] == null ? null : DateTime.parse(json['archived_at'] as String),
  duesPaise: (json['dues_paise'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$MemberToJson(_Member instance) => <String, dynamic>{
  'id': instance.id,
  'member_code': instance.memberCode,
  'name': instance.name,
  'phone': instance.phone,
  'alt_phone': instance.altPhone,
  'email': instance.email,
  'gender': instance.gender,
  'dob': _dateOut(instance.dob),
  'address': instance.address,
  'emergency_name': instance.emergencyName,
  'emergency_relation': instance.emergencyRelation,
  'emergency_phone': instance.emergencyPhone,
  'blood_group': instance.bloodGroup,
  'photo_url': instance.photoPath,
  'goal': instance.goal,
  'level': instance.level,
  'diet_pref': instance.dietPref,
  'language': instance.language,
  'trainer_id': instance.trainerId,
  'batch': instance.batch,
  'source': instance.source,
  'status': _statusOut(instance.status),
  'joined_on': _dateOut(instance.joinedOn),
  'notes': instance.notes,
  'plan_name': instance.planName,
  'membership_start': _dateOut(instance.membershipStart),
  'membership_end': _dateOut(instance.membershipEnd),
  'current_membership_id': instance.currentMembershipId,
  'whatsapp_opt_out': instance.whatsappOptOut,
  'archived_at': instance.archivedAt?.toIso8601String(),
  'dues_paise': instance.duesPaise,
};

_Plan _$PlanFromJson(Map<String, dynamic> json) => _Plan(
  id: json['id'] as String,
  name: json['name'] as String,
  durationValue: (json['duration_value'] as num).toInt(),
  durationUnit: json['duration_unit'] as String? ?? 'months',
  pricePaise: (json['price_paise'] as num).toInt(),
  joiningFeePaise: (json['joining_fee_paise'] as num?)?.toInt() ?? 0,
  gstRate: json['gst_rate'] as num? ?? 0,
  includesPt: json['includes_pt'] as bool? ?? false,
  sessionsLimit: (json['sessions_limit'] as num?)?.toInt(),
  freezeDaysAllowed: (json['freeze_days_allowed'] as num?)?.toInt() ?? 0,
  color: json['color'] as String? ?? 'lime',
  description: json['description'] as String?,
  isArchived: json['is_archived'] as bool? ?? false,
);

Map<String, dynamic> _$PlanToJson(_Plan instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'duration_value': instance.durationValue,
  'duration_unit': instance.durationUnit,
  'price_paise': instance.pricePaise,
  'joining_fee_paise': instance.joiningFeePaise,
  'gst_rate': instance.gstRate,
  'includes_pt': instance.includesPt,
  'sessions_limit': instance.sessionsLimit,
  'freeze_days_allowed': instance.freezeDaysAllowed,
  'color': instance.color,
  'description': instance.description,
  'is_archived': instance.isArchived,
};

_Addon _$AddonFromJson(Map<String, dynamic> json) => _Addon(
  id: json['id'] as String,
  name: json['name'] as String,
  pricePaise: (json['price_paise'] as num).toInt(),
  kind: json['kind'] as String? ?? 'other',
  isArchived: json['is_archived'] as bool? ?? false,
);

Map<String, dynamic> _$AddonToJson(_Addon instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'price_paise': instance.pricePaise,
  'kind': instance.kind,
  'is_archived': instance.isArchived,
};

_MembershipFreeze _$MembershipFreezeFromJson(Map<String, dynamic> json) => _MembershipFreeze(
  id: json['id'] as String,
  fromDate: _date(json['from_date']),
  toDate: _date(json['to_date']),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$MembershipFreezeToJson(_MembershipFreeze instance) => <String, dynamic>{
  'id': instance.id,
  'from_date': _dateOut(instance.fromDate),
  'to_date': _dateOut(instance.toDate),
  'reason': instance.reason,
};

_Membership _$MembershipFromJson(Map<String, dynamic> json) => _Membership(
  id: json['id'] as String,
  memberId: json['member_id'] as String,
  planId: json['plan_id'] as String,
  planName: json['plan_name'] as String,
  startDate: _date(json['start_date']),
  endDate: _date(json['end_date']),
  status: json['status'] == null ? MemberStatus.active : _status(json['status']),
  pricePaise: (json['price_paise'] as num?)?.toInt() ?? 0,
  joiningFeePaise: (json['joining_fee_paise'] as num?)?.toInt() ?? 0,
  addonsPaise: (json['addons_paise'] as num?)?.toInt() ?? 0,
  discountPaise: (json['discount_paise'] as num?)?.toInt() ?? 0,
  discountReason: json['discount_reason'] as String?,
  freezeDaysUsed: (json['freeze_days_used'] as num?)?.toInt() ?? 0,
  source: json['source'] as String? ?? 'new',
  cancelledReason: json['cancelled_reason'] as String?,
  freezes:
      (json['membership_freezes'] as List<dynamic>?)
          ?.map((e) => MembershipFreeze.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$MembershipToJson(_Membership instance) => <String, dynamic>{
  'id': instance.id,
  'member_id': instance.memberId,
  'plan_id': instance.planId,
  'plan_name': instance.planName,
  'start_date': _dateOut(instance.startDate),
  'end_date': _dateOut(instance.endDate),
  'status': _statusOut(instance.status),
  'price_paise': instance.pricePaise,
  'joining_fee_paise': instance.joiningFeePaise,
  'addons_paise': instance.addonsPaise,
  'discount_paise': instance.discountPaise,
  'discount_reason': instance.discountReason,
  'freeze_days_used': instance.freezeDaysUsed,
  'source': instance.source,
  'cancelled_reason': instance.cancelledReason,
  'membership_freezes': instance.freezes.map((e) => e.toJson()).toList(),
};

_MemberHealth _$MemberHealthFromJson(Map<String, dynamic> json) => _MemberHealth(
  memberId: json['member_id'] as String,
  heightCm: json['height_cm'] as num?,
  weightKg: json['weight_kg'] as num?,
  conditions: json['conditions'] as String?,
  injuries: json['injuries'] as String?,
  medications: json['medications'] as String?,
  parq: json['parq'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  doctorClearance: json['doctor_clearance'] as bool? ?? false,
);

Map<String, dynamic> _$MemberHealthToJson(_MemberHealth instance) => <String, dynamic>{
  'member_id': instance.memberId,
  'height_cm': instance.heightCm,
  'weight_kg': instance.weightKg,
  'conditions': instance.conditions,
  'injuries': instance.injuries,
  'medications': instance.medications,
  'parq': instance.parq,
  'doctor_clearance': instance.doctorClearance,
};

_Measurement _$MeasurementFromJson(Map<String, dynamic> json) => _Measurement(
  id: json['id'] as String?,
  memberId: json['member_id'] as String,
  measuredOn: _date(json['measured_on']),
  weightKg: json['weight_kg'] as num?,
  bodyFat: json['body_fat'] as num?,
  chest: json['chest'] as num?,
  waist: json['waist'] as num?,
  hips: json['hips'] as num?,
  arms: json['arms'] as num?,
  thighs: json['thighs'] as num?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$MeasurementToJson(_Measurement instance) => <String, dynamic>{
  'id': instance.id,
  'member_id': instance.memberId,
  'measured_on': _dateOut(instance.measuredOn),
  'weight_kg': instance.weightKg,
  'body_fat': instance.bodyFat,
  'chest': instance.chest,
  'waist': instance.waist,
  'hips': instance.hips,
  'arms': instance.arms,
  'thighs': instance.thighs,
  'notes': instance.notes,
};

_Attendance _$AttendanceFromJson(Map<String, dynamic> json) => _Attendance(
  id: json['id'] as String,
  memberId: json['member_id'] as String,
  day: _date(json['day']),
  checkedInAt: DateTime.parse(json['checked_in_at'] as String),
  checkedOutAt: json['checked_out_at'] == null ? null : DateTime.parse(json['checked_out_at'] as String),
  method: json['method'] as String,
  memberName: json['memberName'] as String?,
);

Map<String, dynamic> _$AttendanceToJson(_Attendance instance) => <String, dynamic>{
  'id': instance.id,
  'member_id': instance.memberId,
  'day': _dateOut(instance.day),
  'checked_in_at': instance.checkedInAt.toIso8601String(),
  'checked_out_at': instance.checkedOutAt?.toIso8601String(),
  'method': instance.method,
};

_MemberEvent _$MemberEventFromJson(Map<String, dynamic> json) => _MemberEvent(
  id: (json['id'] as num).toInt(),
  kind: json['kind'] as String,
  title: json['title'] as String,
  data: json['data'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  at: DateTime.parse(json['at'] as String),
);

Map<String, dynamic> _$MemberEventToJson(_MemberEvent instance) => <String, dynamic>{
  'id': instance.id,
  'kind': instance.kind,
  'title': instance.title,
  'data': instance.data,
  'at': instance.at.toIso8601String(),
};

_CheckInResult _$CheckInResultFromJson(Map<String, dynamic> json) => _CheckInResult(
  memberId: json['member_id'] as String,
  name: json['name'] as String,
  memberCode: json['member_code'] as String,
  photoPath: json['photo_url'] as String?,
  status: _status(json['status']),
  planName: json['plan_name'] as String?,
  daysLeft: (json['days_left'] as num?)?.toInt(),
  already: json['already'] as bool? ?? false,
  checkedOutAt: json['checked_out_at'] == null ? null : DateTime.parse(json['checked_out_at'] as String),
  duesPaise: (json['dues_paise'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CheckInResultToJson(_CheckInResult instance) => <String, dynamic>{
  'member_id': instance.memberId,
  'name': instance.name,
  'member_code': instance.memberCode,
  'photo_url': instance.photoPath,
  'status': _statusOut(instance.status),
  'plan_name': instance.planName,
  'days_left': instance.daysLeft,
  'already': instance.already,
  'checked_out_at': instance.checkedOutAt?.toIso8601String(),
  'dues_paise': instance.duesPaise,
};

_DashboardCounts _$DashboardCountsFromJson(Map<String, dynamic> json) => _DashboardCounts(
  active: (json['active'] as num?)?.toInt() ?? 0,
  expiring: (json['expiring'] as num?)?.toInt() ?? 0,
  expired: (json['expired'] as num?)?.toInt() ?? 0,
  frozen: (json['frozen'] as num?)?.toInt() ?? 0,
  total: (json['total'] as num?)?.toInt() ?? 0,
  newThisMonth: (json['new_this_month'] as num?)?.toInt() ?? 0,
  checkinsToday: (json['checkins_today'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$DashboardCountsToJson(_DashboardCounts instance) => <String, dynamic>{
  'active': instance.active,
  'expiring': instance.expiring,
  'expired': instance.expired,
  'frozen': instance.frozen,
  'total': instance.total,
  'new_this_month': instance.newThisMonth,
  'checkins_today': instance.checkinsToday,
};

_NeedsAction _$NeedsActionFromJson(Map<String, dynamic> json) => _NeedsAction(
  memberId: json['member_id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  photoPath: json['photo_url'] as String?,
  reason: _reason(json['reason']),
  detail: json['detail'] as String?,
);

Map<String, dynamic> _$NeedsActionToJson(_NeedsAction instance) => <String, dynamic>{
  'member_id': instance.memberId,
  'name': instance.name,
  'phone': instance.phone,
  'photo_url': instance.photoPath,
  'reason': _reasonOut(instance.reason),
  'detail': instance.detail,
};

_MemberQuery _$MemberQueryFromJson(Map<String, dynamic> json) => _MemberQuery(
  search: json['search'] as String? ?? '',
  statuses: (json['statuses'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  planName: json['planName'] as String?,
  trainerId: json['trainerId'] as String?,
  batch: json['batch'] as String?,
  gender: json['gender'] as String?,
  birthdayThisMonth: json['birthdayThisMonth'] as bool? ?? false,
  joinedFrom: _date(json['joinedFrom']),
  joinedTo: _date(json['joinedTo']),
  sort: $enumDecodeNullable(_$MemberSortEnumMap, json['sort']) ?? MemberSort.name,
  includeArchived: json['includeArchived'] as bool? ?? false,
);

Map<String, dynamic> _$MemberQueryToJson(_MemberQuery instance) => <String, dynamic>{
  'search': instance.search,
  'statuses': instance.statuses,
  'planName': instance.planName,
  'trainerId': instance.trainerId,
  'batch': instance.batch,
  'gender': instance.gender,
  'birthdayThisMonth': instance.birthdayThisMonth,
  'joinedFrom': _dateOut(instance.joinedFrom),
  'joinedTo': _dateOut(instance.joinedTo),
  'sort': _$MemberSortEnumMap[instance.sort]!,
  'includeArchived': instance.includeArchived,
};

const _$MemberSortEnumMap = {MemberSort.name: 'name', MemberSort.endDate: 'endDate', MemberSort.joined: 'joined'};

_CheckOutResult _$CheckOutResultFromJson(Map<String, dynamic> json) => _CheckOutResult(
  memberId: json['member_id'] as String,
  checkedInAt: DateTime.parse(json['checked_in_at'] as String),
  checkedOutAt: DateTime.parse(json['checked_out_at'] as String),
  minutes: (json['minutes'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CheckOutResultToJson(_CheckOutResult instance) => <String, dynamic>{
  'member_id': instance.memberId,
  'checked_in_at': instance.checkedInAt.toIso8601String(),
  'checked_out_at': instance.checkedOutAt.toIso8601String(),
  'minutes': instance.minutes,
};
