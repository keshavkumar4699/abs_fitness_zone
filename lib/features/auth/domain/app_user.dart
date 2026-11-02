import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

enum UserRole {
  @JsonValue('owner')
  owner,
  @JsonValue('front_desk')
  frontDesk,
  @JsonValue('trainer')
  trainer,
  @JsonValue('member')
  member;

  bool get isStaff => this != UserRole.member;
  bool get isDesk => this == UserRole.owner || this == UserRole.frontDesk;
  bool get isOwner => this == UserRole.owner;

  /// Revenue and profit are owner-only (front desk sees the dashboard minus
  /// revenue; trainers never see payments).
  bool get canSeeRevenue => this == UserRole.owner;

  String get wire => switch (this) {
    UserRole.owner => 'owner',
    UserRole.frontDesk => 'front_desk',
    UserRole.trainer => 'trainer',
    UserRole.member => 'member',
  };

  static UserRole fromWire(String value) =>
      UserRole.values.firstWhere((r) => r.wire == value, orElse: () => throw ArgumentError.value(value, 'role'));
}

/// The signed-in person, built from their `profiles` row.
@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    @JsonKey(name: 'id') required String userId,
    required UserRole role,
    required String name,
    String? phone,
    @JsonKey(name: 'staff_id') String? staffId,
    @JsonKey(name: 'member_id') String? memberId,
    @JsonKey(name: 'must_set_password') @Default(false) bool mustSetPassword,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
}
