import 'dart:async';

import 'package:abs_fitness/core/errors.dart';
import 'package:abs_fitness/core/paging.dart';
import 'package:abs_fitness/features/auth/data/auth_repository.dart';
import 'package:abs_fitness/features/auth/domain/app_user.dart';
import 'package:abs_fitness/features/settings/data/staff_repository.dart';

const ownerUser = AppUser(userId: 'u-owner', role: UserRole.owner, name: 'Keshav Kumar', staffId: 's-owner');
const deskUser = AppUser(userId: 'u-desk', role: UserRole.frontDesk, name: 'Neha Desk', staffId: 's-desk');
const trainerUser = AppUser(userId: 'u-trainer', role: UserRole.trainer, name: 'Vikram Trainer', staffId: 's-tr');
const memberUser = AppUser(userId: 'u-member', role: UserRole.member, name: 'Aarav Sharma', memberId: 'm-1');

/// In-memory auth used by widget tests.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository([AppUser? initial]) : _user = initial;

  AppUser? _user;
  final _controller = StreamController<AppUser?>.broadcast();
  final calls = <String>[];

  /// Users that sign-in calls resolve to.
  AppUser staffResult = ownerUser;
  AppUser memberResult = memberUser;
  Object? nextError;

  void _emit(AppUser? u) {
    _user = u;
    _controller.add(u);
  }

  @override
  Stream<AppUser?> watchUser() async* {
    yield _user;
    yield* _controller.stream;
  }

  Future<void> _maybeThrow() async {
    final e = nextError;
    nextError = null;
    if (e != null) throw e;
  }

  @override
  Future<void> signInStaff({required String email, required String password}) async {
    calls.add('staff:$email');
    await _maybeThrow();
    _emit(staffResult);
  }

  @override
  Future<void> signInMember({required String phone, required String pin}) async {
    calls.add('member:$phone:$pin');
    await _maybeThrow();
    _emit(memberResult);
  }

  @override
  Future<void> sendMemberMagicLink({required String email}) async => calls.add('link:$email');

  @override
  Future<void> setPassword(String newPassword) async {
    calls.add('password');
    await _maybeThrow();
    if (_user != null) _emit(_user!.copyWith(mustSetPassword: false));
  }

  @override
  Future<void> signOut() async {
    calls.add('signOut');
    _emit(null);
  }

  @override
  Future<void> refresh() async => _emit(_user);
}

class FakeStaffRepository implements StaffRepository {
  FakeStaffRepository(this.staff);

  final List<StaffMember> staff;
  Object? error;

  @override
  Future<Paged<StaffMember>> list({required int offset, String query = ''}) async {
    if (error != null) throw error!;
    final q = query.toLowerCase();
    final all = staff.where((s) => s.name.toLowerCase().contains(q) || s.email.contains(q)).toList();
    final page = all.skip(offset).take(kPageSize).toList();
    return Paged(page, hasMore: offset + page.length < all.length);
  }

  @override
  Future<String> invite({required String name, required String email, String? phone, required UserRole role}) async {
    if (error != null) throw error!;
    staff.add(StaffMember(id: 'new', name: name, email: email, role: role, isActive: true));
    return 'Temp9Pass2xy';
  }

  @override
  Future<List<StaffMember>> trainers() async => staff.where((s) => s.role == UserRole.trainer && s.isActive).toList();

  @override
  Future<void> setActive({required String staffId, required bool active}) async {
    if (error != null) throw error!;
    final i = staff.indexWhere((s) => s.id == staffId);
    final s = staff[i];
    staff[i] = StaffMember(id: s.id, name: s.name, email: s.email, phone: s.phone, role: s.role, isActive: active);
  }
}

const sampleStaff = [
  StaffMember(id: '1', name: 'Keshav Kumar', email: 'owner@absfitness.in', role: UserRole.owner, isActive: true),
  StaffMember(id: '2', name: 'Neha Singh', email: 'desk@absfitness.in', role: UserRole.frontDesk, isActive: true),
  StaffMember(id: '3', name: 'Vikram Rao', email: 'vikram@absfitness.in', role: UserRole.trainer, isActive: true),
  StaffMember(id: '4', name: 'Pooja Mehta', email: 'pooja@absfitness.in', role: UserRole.trainer, isActive: false),
];

const networkDown = NetworkFailure();

/// Alias so tests read naturally.
typedef InvalidPinFailureForTest = InvalidPinFailure;
