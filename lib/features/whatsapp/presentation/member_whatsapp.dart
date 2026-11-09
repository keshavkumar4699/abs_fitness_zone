import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/widgets.dart';
import '../application/whatsapp_providers.dart';
import '../data/whatsapp_repository.dart';
import '../domain/whatsapp_models.dart';
import 'whatsapp_ui.dart';

/// WhatsApp on/off for one member (8.12). The switch moves at once and
/// moves back with an error if the server refuses.
class WhatsAppOptOutTile extends ConsumerStatefulWidget {
  const WhatsAppOptOutTile({super.key, required this.memberId, required this.optedOut, required this.onSaved});

  final String memberId;
  final bool optedOut;
  final VoidCallback onSaved;

  @override
  ConsumerState<WhatsAppOptOutTile> createState() => _WhatsAppOptOutTileState();
}

class _WhatsAppOptOutTileState extends ConsumerState<WhatsAppOptOutTile> {
  late bool _on = !widget.optedOut;

  @override
  void didUpdateWidget(WhatsAppOptOutTile old) {
    super.didUpdateWidget(old);
    if (old.optedOut != widget.optedOut) _on = !widget.optedOut;
  }

  Future<void> _set(bool on) async {
    final l = context.l10n;
    setState(() => _on = on);
    try {
      await ref.read(whatsAppRepositoryProvider).setOptOut(memberId: widget.memberId, optOut: !on);
      widget.onSaved();
      if (mounted) showAbsSnackbar(context, on ? l.waOptInDone : l.waOptOutDone, tone: SnackTone.success);
    } catch (e) {
      if (!mounted) return;
      setState(() => _on = !on);
      showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    return SwitchListTile(
      key: const ValueKey('wa-opt'),
      contentPadding: EdgeInsets.zero,
      secondary: IconBubble(icon: PhosphorIcons.whatsappLogo(PhosphorIconsStyle.bold), hue: PopHue.mint, size: 36),
      title: Text(l.waOptIn, style: t.heading),
      subtitle: Text(_on ? l.waOptInBody : l.waOptedOut, style: t.caption.copyWith(color: c.textSecondary)),
      value: _on,
      onChanged: _set,
    );
  }
}

/// Member detail (front desk, owner): WhatsApp on/off and the last few
/// messages, with the full log one tap away.
class MemberWhatsAppCard extends ConsumerWidget {
  const MemberWhatsAppCard({super.key, required this.memberId, required this.optedOut, required this.onSaved});

  final String memberId;
  final bool optedOut;
  final VoidCallback onSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final recent = ref.watch(messageLogProvider(memberId, LogFilter.all));
    return AbsCard(
      key: const ValueKey('wa-member-card'),
      padding: const EdgeInsets.fromLTRB(AbsSpace.x4, AbsSpace.x2, AbsSpace.x4, AbsSpace.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WhatsAppOptOutTile(memberId: memberId, optedOut: optedOut, onSaved: onSaved),
          switch (recent) {
            AsyncData(:final value) when value.items.isNotEmpty => Column(
              children: [
                for (final m in value.items.take(3))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AbsSpace.x1),
                    child: Row(
                      children: [
                        Icon(messageKindIcon(m.kind), size: AbsSize.iconSmall, color: c.textSecondary),
                        const SizedBox(width: AbsSpace.x2),
                        Expanded(
                          child: Text(
                            '${messageKindLabel(l, m.kind)} · ${messageWhen(l, m)}',
                            style: t.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopSticker(label: messageStatusLabel(l, m.status), hue: messageStatusHue(m.status)),
                      ],
                    ),
                  ),
              ],
            ),
            AsyncData() => Text(l.waLogEmptyTitle, style: t.caption.copyWith(color: c.textSecondary)),
            AsyncError() => const SizedBox.shrink(),
            _ => const SkeletonBlock(child: SizedBox(height: 48, width: double.infinity)),
          },
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              key: const ValueKey('wa-member-log'),
              onPressed: () => context.push(Routes.memberMessages(memberId)),
              child: Text(l.waMemberMessages),
            ),
          ),
        ],
      ),
    );
  }
}

/// A broadcast segment for members picked in the list (bulk WhatsApp).
Segment selectedMembers(Iterable<String> ids) => Segment('members', memberIds: [...ids]);
