import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/widgets.dart';
import '../../members/application/members_providers.dart';
import '../../members/data/members_repository.dart';
import '../../members/domain/models.dart';
import '../../members/presentation/member_ui.dart';
import '../../members/presentation/widgets/member_photo.dart';
import 'check_in_result.dart';
import 'scanner_view.dart';

/// Front-desk check-in (1.12): scan the member's QR card, or search.
/// Trainers can check in their own members the same way.
class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  String _query = '';
  Timer? _debounce;
  bool _busy = false;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _checkIn(String memberId) async {
    if (_busy) return;
    final l = context.l10n;
    setState(() => _busy = true);
    try {
      final r = await ref.read(membersRepositoryProvider).checkIn(memberId);
      ref
        ..invalidate(dashboardProvider)
        ..invalidate(memberAttendanceProvider(memberId));
      if (mounted) await showCheckInResult(context, r);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _onCode(String raw) {
    final id = memberIdFromQr(raw);
    if (id == null) {
      showAbsSnackbar(context, context.l10n.checkInUnknownCode, tone: SnackTone.error);
      return;
    }
    _checkIn(id);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final results = _query.length < 2
        ? null
        : ref.watch(memberListProvider(MemberQuery(search: _query))).whenData((p) => p.items);
    return Scaffold(
      appBar: AppBar(title: Text(l.checkInTitle)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, AbsSpace.x10),
        children: [
          SizedBox(
            height: 260,
            child: ScannerView(onCode: _onCode, hint: l.checkInScanHint, paused: _busy),
          ),
          const SizedBox(height: AbsSpace.x5),
          AbsTextField(
            label: l.checkInSearch,
            onChanged: (v) {
              _debounce?.cancel();
              _debounce = Timer(AbsMotion.standard.duration, () {
                if (mounted) setState(() => _query = v.trim());
              });
            },
          ),
          const SizedBox(height: AbsSpace.x3),
          if (results != null)
            AsyncView<List<Member>>(
              value: results,
              onRetry: () => ref.invalidate(memberListProvider),
              loading: const SizedBox(height: 160, child: SkeletonList(itemCount: 2)),
              empty: Padding(
                padding: const EdgeInsets.all(AbsSpace.x4),
                child: Text(l.membersNoMatchBody, style: context.text.body.copyWith(color: c.textSecondary)),
              ),
              data: (items) => Column(
                children: [
                  for (final m in items)
                    MemberTile(
                      name: m.name,
                      plan: '${m.memberCode} · ${m.planName ?? l.noPlan}',
                      status: pillFor(m.status),
                      daysLeft: m.status.isCurrent ? m.daysLeft() : null,
                      avatar: MemberPhoto(name: m.name, path: m.photoPath),
                      onTap: () => _checkIn(m.id),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
