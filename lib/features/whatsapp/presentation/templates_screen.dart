import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../settings/data/gym_settings_repository.dart';
import '../application/whatsapp_providers.dart';
import '../data/whatsapp_repository.dart';
import '../domain/message_text.dart';
import '../domain/whatsapp_models.dart';
import 'broadcast_screen.dart' show MessageBubble;
import 'whatsapp_ui.dart';

/// Template manager (8.1): every automatic message in English and Hindi,
/// with a live preview. The owner edits; the front desk reads.
class TemplatesScreen extends ConsumerWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final owner = ref.watch(currentUserProvider).value?.role.isOwner ?? false;
    final templates = ref.watch(messageTemplatesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.waTemplatesTitle)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(messageTemplatesProvider.future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            context.screenPadding,
            AbsSpace.x2,
            context.screenPadding,
            MediaQuery.paddingOf(context).bottom + AbsSpace.x8,
          ),
          children: [
            if (!owner) ...[
              Text(l.waTemplateReadOnly, style: t.caption.copyWith(color: c.textSecondary)),
              const SizedBox(height: AbsSpace.x3),
            ],
            AsyncView<List<MessageTemplate>>(
              value: templates,
              onRetry: () => ref.invalidate(messageTemplatesProvider),
              loading: const SizedBox(height: 480, child: SkeletonList(itemCount: 5)),
              empty: EmptyState(
                title: l.waTemplatesEmptyTitle,
                message: l.waTemplatesEmptyBody,
                illustration: EmptyIllustration.receipt,
                hue: PopHue.mint,
              ),
              data: (list) {
                final keys = <String>[];
                for (final x in list) {
                  if (!keys.contains(x.key)) keys.add(x.key);
                }
                return Column(
                  children: [
                    for (final key in keys)
                      _TemplateCard(
                        key: ValueKey('tpl-$key'),
                        templateKey: key,
                        variants: list.where((x) => x.key == key).toList()
                          ..sort((a, b) => a.language.compareTo(b.language)),
                        editable: owner,
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplateCard extends ConsumerWidget {
  const _TemplateCard({super.key, required this.templateKey, required this.variants, required this.editable});

  final String templateKey;
  final List<MessageTemplate> variants;
  final bool editable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final category = variants.first.category;
    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: AbsCard(
        padding: const EdgeInsets.all(AbsSpace.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconBubble(icon: messageKindIcon(templateKey), hue: messageKindHue(templateKey), size: 36),
                const SizedBox(width: AbsSpace.x3),
                Expanded(child: Text(messageKindLabel(l, templateKey), style: t.heading)),
                PopSticker(
                  label: categoryLabel(l, category),
                  hue: category == MessageCategory.marketing ? PopHue.bubblegum : PopHue.sky,
                ),
              ],
            ),
            for (final v in variants)
              InkWell(
                key: ValueKey('tpl-${v.key}-${v.language}'),
                borderRadius: AbsRadius.buttonAll,
                onTap: () => showTemplateEditor(context, v, editable: editable),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AbsSpace.x3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 64,
                        child: Text(
                          v.language == 'hi' ? l.waTemplateHindi : l.waTemplateEnglish,
                          style: t.label.copyWith(color: c.textSecondary),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          v.body,
                          style: t.body.copyWith(color: v.isEnabled ? null : c.textSecondary),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!v.isEnabled) ...[
                        const SizedBox(width: AbsSpace.x2),
                        PopSticker(label: l.waTemplateOff, hue: PopHue.grape),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Future<void> showTemplateEditor(BuildContext context, MessageTemplate template, {required bool editable}) =>
    showAbsBottomSheet<void>(
      context: context,
      expandToFull: true,
      builder: (context, controller) => _TemplateEditor(template: template, editable: editable, scroll: controller),
    );

class _TemplateEditor extends ConsumerStatefulWidget {
  const _TemplateEditor({required this.template, required this.editable, required this.scroll});

  final MessageTemplate template;
  final bool editable;
  final ScrollController scroll;

  @override
  ConsumerState<_TemplateEditor> createState() => _TemplateEditorState();
}

class _TemplateEditorState extends ConsumerState<_TemplateEditor> {
  final _form = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.template.title);
  late final _body = TextEditingController(text: widget.template.body)..addListener(() => setState(() {}));
  late final _meta = TextEditingController(text: widget.template.metaTemplateName ?? '');
  late bool _enabled = widget.template.isEnabled;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _meta.dispose();
    super.dispose();
  }

  void _insert(String v) {
    final sel = _body.selection;
    final at = sel.isValid ? sel.start : _body.text.length;
    final end = sel.isValid ? sel.end : _body.text.length;
    _body.value = TextEditingValue(
      text: _body.text.replaceRange(at, end, '{$v}'),
      selection: TextSelection.collapsed(offset: at + v.length + 2),
    );
  }

  Future<void> _save() async {
    final l = context.l10n;
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(whatsAppRepositoryProvider)
          .saveTemplate(
            widget.template.copyWith(
              title: _title.text,
              body: _body.text,
              metaTemplateName: _meta.text,
              isEnabled: _enabled,
            ),
          );
      ref.invalidate(messageTemplatesProvider);
      if (!mounted) return;
      Navigator.of(context).pop();
      showAbsSnackbar(context, l.waTemplateSaved, tone: SnackTone.success);
    } catch (e) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, e), tone: SnackTone.error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final tpl = widget.template;
    final gym = ref.watch(publicGymProfileProvider).value?['gym_name'] as String? ?? l.gymName;
    final vars = kMessageVariables[tpl.key] ?? kBroadcastVariables;
    final metaBody = metaTemplateBody(_body.text.trim());
    const gap = SizedBox(height: AbsSpace.x4);
    return Form(
      key: _form,
      child: ListView(
        controller: widget.scroll,
        padding: EdgeInsets.fromLTRB(
          context.screenPadding,
          AbsSpace.x2,
          context.screenPadding,
          MediaQuery.viewInsetsOf(context).bottom + AbsSpace.x8,
        ),
        children: [
          Text(messageKindLabel(l, tpl.key), style: t.title),
          Text(
            '${tpl.language == 'hi' ? l.waTemplateHindi : l.waTemplateEnglish} · ${categoryLabel(l, tpl.category)}',
            style: t.caption.copyWith(color: c.textSecondary),
          ),
          gap,
          AbsTextField(
            label: l.waTemplateTitle,
            controller: _title,
            enabled: widget.editable,
            maxLength: 60,
            validator: (v) => (v ?? '').trim().length < 2 ? l.waNeedTitle : null,
          ),
          gap,
          TextFormField(
            key: const ValueKey('tpl-body'),
            controller: _body,
            enabled: widget.editable,
            minLines: 3,
            maxLines: 8,
            maxLength: 1000,
            decoration: InputDecoration(labelText: l.waTemplateText),
            validator: (v) => (v ?? '').trim().length < 2 ? l.waNeedMessage : null,
          ),
          if (widget.editable) ...[
            Text(l.waInsertVariable, style: t.caption.copyWith(color: c.textSecondary)),
            const SizedBox(height: AbsSpace.x2),
            Wrap(
              spacing: AbsSpace.x2,
              runSpacing: AbsSpace.x2,
              children: [
                for (final v in vars) PopChip(label: '{$v}', selected: false, hue: PopHue.sky, onTap: () => _insert(v)),
              ],
            ),
          ],
          gap,
          Text(l.waTemplatePreview, style: t.heading),
          const SizedBox(height: AbsSpace.x2),
          MessageBubble(
            text: renderMessage(_body.text.trim(), sampleVariables(firstName: l.waSampleName, gym: gym)),
          ),
          gap,
          SwitchListTile(
            key: const ValueKey('tpl-enabled'),
            contentPadding: EdgeInsets.zero,
            title: Text(l.waTemplateEnabled, style: t.body),
            value: _enabled,
            onChanged: widget.editable ? (v) => setState(() => _enabled = v) : null,
          ),
          gap,
          AbsTextField(
            label: l.waTemplateMetaName,
            controller: _meta,
            enabled: widget.editable,
            maxLength: 512,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-z0-9_]'))],
            helperText: l.waTemplateMetaHelp,
          ),
          const SizedBox(height: AbsSpace.x2),
          InkWell(
            borderRadius: AbsRadius.buttonAll,
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: metaBody));
              if (context.mounted) showAbsSnackbar(context, l.waCopied);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AbsSpace.x2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(metaBody, style: t.caption.copyWith(color: c.textSecondary)),
                  ),
                  const SizedBox(width: AbsSpace.x2),
                  Icon(PhosphorIcons.copy(PhosphorIconsStyle.bold), size: AbsSize.iconSmall, color: c.textSecondary),
                ],
              ),
            ),
          ),
          if (widget.editable) ...[
            gap,
            AbsButton(
              key: const ValueKey('tpl-save'),
              label: l.commonSave,
              hue: PopHue.mint,
              isLoading: _saving,
              onPressed: _saving ? null : _save,
            ),
          ],
        ],
      ),
    );
  }
}
