import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/widgets.dart';
import '../../members/data/members_repository.dart';
import '../../members/application/members_providers.dart';
import 'check_in_result.dart';
import 'scanner_view.dart';

/// Member self check-in: scan today's gym code at the desk.
class MemberCheckInScreen extends ConsumerStatefulWidget {
  const MemberCheckInScreen({super.key});

  @override
  ConsumerState<MemberCheckInScreen> createState() => _MemberCheckInScreenState();
}

class _MemberCheckInScreenState extends ConsumerState<MemberCheckInScreen> {
  bool _busy = false;

  Future<void> _onCode(String code) async {
    if (_busy) return;
    final l = context.l10n;
    setState(() => _busy = true);
    try {
      final r = await ref.read(membersRepositoryProvider).selfCheckIn(code);
      ref.invalidate(memberAttendanceProvider(r.memberId));
      if (!mounted) return;
      await showCheckInResult(context, r);
      if (mounted) Navigator.of(context).maybePop();
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.memberCheckInTitle)),
      body: Padding(
        padding: EdgeInsets.all(context.screenPadding),
        child: Column(
          children: [
            Expanded(
              child: ScannerView(onCode: _onCode, hint: l.memberCheckInHint, hue: PopHue.lime, paused: _busy),
            ),
            const SizedBox(height: AbsSpace.x6),
          ],
        ),
      ),
    );
  }
}
