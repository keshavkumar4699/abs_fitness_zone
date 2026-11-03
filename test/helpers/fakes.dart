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
  final _errors = StreamController<AppFailure?>.broadcast();
  AppFailure? _signInError;
  final calls = <String>[];

  /// The account the Google sign-in resolves to.
  AppUser googleResult = ownerUser;

  /// When set, Google sign-in completes but the gym refuses the account
  /// (reported like the real repository: through [watchSignInError]).
  AppFailure? refuseWith;

  /// Thrown by [signInWithGoogle] itself (e.g. the browser didn't open).
  Object? nextError;

  void _emit(AppUser? u) {
    _user = u;
    _controller.add(u);
  }

  void _setError(AppFailure? e) {
    _signInError = e;
    _errors.add(e);
  }

  @override
  Stream<AppUser?> watchUser() async* {
    yield _user;
    yield* _controller.stream;
  }

  @override
  Future<void> signInWithGoogle() async {
    calls.add('google');
    _setError(null);
    final e = nextError;
    nextError = null;
    if (e != null) throw e;
    final refused = refuseWith;
    if (refused != null) {
      _setError(refused);
      _emit(null);
      return;
    }
    _emit(googleResult);
  }

  @override
  Stream<AppFailure?> watchSignInError() async* {
    yield _signInError;
    yield* _errors.stream;
  }

  @override
  void clearSignInError() => _setError(null);

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
  Future<void> invite({required String name, required String email, String? phone, required UserRole role}) async {
    if (error != null) throw error!;
    if (staff.any((s) => s.email == email.trim().toLowerCase())) throw const StaffEmailTakenFailure();
    staff.add(StaffMember(id: 'new', name: name, email: email.trim().toLowerCase(), role: role, isActive: true));
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
