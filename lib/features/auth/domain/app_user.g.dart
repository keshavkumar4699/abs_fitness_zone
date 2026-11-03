// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  userId: json['id'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  name: json['name'] as String,
  phone: json['phone'] as String?,
  staffId: json['staff_id'] as String?,
  memberId: json['member_id'] as String?,
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.userId,
  'role': _$UserRoleEnumMap[instance.role]!,
  'name': instance.name,
  'phone': instance.phone,
  'staff_id': instance.staffId,
  'member_id': instance.memberId,
};

const _$UserRoleEnumMap = {
  UserRole.owner: 'owner',
  UserRole.frontDesk: 'front_desk',
  UserRole.trainer: 'trainer',
  UserRole.member: 'member',
};
