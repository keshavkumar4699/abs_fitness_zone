import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/widgets.dart';
import '../application/members_providers.dart';
import '../data/members_repository.dart';
import '../domain/models.dart';
import 'member_form.dart';

/// Edit a member's profile (desk / owner). Health is edited separately by the
/// owner or the member's trainer because front desk may not see it.
class EditMemberScreen extends ConsumerWidget {
  const EditMemberScreen({super.key, required this.memberId});

  final String memberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final member = ref.watch(memberProvider(memberId));
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.actionEdit)),
      body: AsyncView<Member>(
        value: member,
        onRetry: () => ref.invalidate(memberProvider(memberId)),
        empty: const SizedBox.shrink(),
        isEmpty: (_) => false,
        data: (m) => _EditForm(member: m),
      ),
    );
  }
}

class _EditForm extends ConsumerStatefulWidget {
  const _EditForm({required this.member});

  final Member member;

  @override
  ConsumerState<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends ConsumerState<_EditForm> {
  late final MemberFormData _data = MemberFormData.fromMember(widget.member);
  final _form = GlobalKey<FormState>();
  bool _busy = false;

  @override
  void dispose() {
    _data.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    final l = context.l10n;
    setState(() => _busy = true);
    try {
      final repo = ref.read(membersRepositoryProvider);
      await repo.update(widget.member.id, _data.memberJson());
      if (_data.photo != null) await repo.uploadPhoto(widget.member.id, _data.photo!);
      ref.refreshMember(widget.member.id);
      if (!mounted) return;
      showAbsSnackbar(context, l.saved, tone: SnackTone.success);
      context.pop();
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: ListView(
        padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x4, context.screenPadding, AbsSpace.x10),
        children: [
          MemberBasicsFields(data: _data, existingPhotoPath: widget.member.photoPath),
          const SizedBox(height: AbsSpace.x6),
          AbsButton(label: context.l10n.commonSave, hue: PopHue.sky, isLoading: _busy, onPressed: _save),
        ],
      ),
    );
  }
}
