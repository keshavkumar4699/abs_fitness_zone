import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/widgets.dart';
import '../../members/data/members_repository.dart';
import '../../members/domain/models.dart';
import '../application/payments_providers.dart';
import '../data/payments_repository.dart';
import '../domain/payment_models.dart';
import 'collect_sheet.dart' show CollectTarget;

/// Ad-hoc invoice (2.1): a PT pack, merchandise, an add-on bought later.
/// Pick the member, list the items, set the due date and any discount.
Future<bool?> showNewInvoiceSheet(BuildContext context, {CollectTarget? member}) => showAbsBottomSheet<bool>(
  context: context,
  expandToFull: true,
  builder: (context, controller) => _NewInvoiceSheet(member: member, scroll: controller),
);

class _NewInvoiceSheet extends ConsumerStatefulWidget {
  const _NewInvoiceSheet({required this.member, required this.scroll});

  final CollectTarget? member;
  final ScrollController scroll;

  @override
  ConsumerState<_NewInvoiceSheet> createState() => _NewInvoiceSheetState();
}

class _Line {
  final desc = TextEditingController();
  final amount = TextEditingController();
  int qty = 1;

  int get paise => (Money.parse(amount.text) ?? 0) * qty;

  void dispose() {
    desc.dispose();
    amount.dispose();
  }
}

class _NewInvoiceSheetState extends ConsumerState<_NewInvoiceSheet> {
  final _search = TextEditingController();
  final _discount = TextEditingController();
  final _reason = TextEditingController();
  final List<_Line> _lines = [_Line()];
  late CollectTarget? _member = widget.member;
  List<Member>? _results;
  Timer? _debounce;
  DateTime? _due;
  num _gst = 0;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    _discount.dispose();
    _reason.dispose();
    for (final x in _lines) {
      x.dispose();
    }
    super.dispose();
  }

  void _onSearch(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      final s = text.trim();
      if (s.isEmpty) {
        if (mounted) setState(() => _results = null);
        return;
      }
      try {
        final page = await ref.read(membersRepositoryProvider).list(offset: 0, query: MemberQuery(search: s));
        if (mounted && _search.text.trim() == s) setState(() => _results = page.items.take(8).toList());
      } catch (_) {
        if (mounted) setState(() => _results = const []);
      }
    });
  }

  int get _subtotal => _lines.fold<int>(0, (a, x) => a + x.paise);
  int get _total => (_subtotal - (Money.parse(_discount.text) ?? 0)).clamp(0, 1 << 40);

  Future<void> _pickDue() async {
    final today = IstDates.today();
    final picked = await showDatePicker(
      context: context,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      initialDate: _due ?? today.add(const Duration(days: 7)),
    );
    if (picked != null) setState(() => _due = DateTime.utc(picked.year, picked.month, picked.day));
  }

  Future<void> _create() async {
    final l = context.l10n;
    final lines = [
      for (final x in _lines)
        if (x.desc.text.trim().isNotEmpty && (Money.parse(x.amount.text) ?? 0) > 0)
          InvoiceLine(
            description: x.desc.text.trim(),
            unitPaise: Money.parse(x.amount.text)!,
            qty: x.qty,
            gstRate: _gst,
          ),
    ];
    final discount = Money.parse(_discount.text) ?? 0;
    if (lines.isEmpty) return setState(() => _error = l.newInvNeedLine);
    if (discount > 0 && _reason.text.trim().isEmpty) return setState(() => _error = l.newInvNeedReason);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final id = await ref
          .read(paymentsRepositoryProvider)
          .createInvoice(
            memberId: _member!.memberId,
            lines: lines,
            dueDate: _due,
            discountPaise: discount,
            discountReason: discount > 0 ? _reason.text.trim() : null,
          );
      ref.refreshPayments(memberId: _member!.memberId, invoiceId: id);
      if (!mounted) return;
      final router = GoRouter.of(context);
      showAbsSnackbar(context, l.newInvDone, tone: SnackTone.success);
      Navigator.of(context).pop(true);
      await router.push(Routes.invoiceDetail(id));
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = friendlyError(l, e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    final member = _member;
    return ListView(
      controller: widget.scroll,
      padding: EdgeInsets.fromLTRB(
        context.screenPadding,
        0,
        context.screenPadding,
        MediaQuery.viewInsetsOf(context).bottom + AbsSpace.x6,
      ),
      children: [
        Text(l.newInvTitle, style: t.title),
        const SizedBox(height: AbsSpace.x4),
        if (member == null) ..._memberStep(context) else ..._linesStep(context, member),
      ],
    );
  }

  List<Widget> _memberStep(BuildContext context) {
    final l = context.l10n;
    final results = _results;
    return [
      AbsTextField(
        key: const ValueKey('invoice-search'),
        label: l.collectSearchHint,
        controller: _search,
        autofocus: true,
        onChanged: _onSearch,
        suffix: Icon(PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold)),
      ),
      const SizedBox(height: AbsSpace.x4),
      if (results == null)
        Text(l.newInvPickMember, style: context.text.body.copyWith(color: context.colors.textSecondary))
      else if (results.isEmpty)
        Padding(
          padding: const EdgeInsets.all(AbsSpace.x6),
          child: Text(l.collectNoMembers, textAlign: TextAlign.center, style: context.text.body),
        )
      else
        for (final m in results)
          Padding(
            padding: const EdgeInsets.only(bottom: AbsSpace.x2),
            child: AbsCard(
              key: ValueKey('invoice-member-${m.id}'),
              onTap: () => setState(() => _member = CollectTarget.of(m)),
              padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x4, vertical: AbsSpace.x3),
              child: Row(
                children: [
                  AbsAvatar(name: m.name, size: 40),
                  const SizedBox(width: AbsSpace.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.name, style: context.text.heading, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(
                          m.memberCode,
                          style: context.text
                              .numericOf(context.text.caption)
                              .copyWith(color: context.colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    ];
  }

  List<Widget> _linesStep(BuildContext context, CollectTarget member) {
    final l = context.l10n;
    final t = context.text;
    final discount = Money.parse(_discount.text) ?? 0;
    const gap = SizedBox(height: AbsSpace.x3);
    return [
      Row(
        children: [
          AbsAvatar(name: member.name, size: 40),
          const SizedBox(width: AbsSpace.x3),
          Expanded(
            child: Text(member.name, style: t.heading, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          if (widget.member == null)
            TextButton(onPressed: () => setState(() => _member = null), child: Text(l.commonChange)),
        ],
      ),
      const SizedBox(height: AbsSpace.x4),
      for (final (i, x) in _lines.indexed) ...[
        Row(
          key: ValueKey('invoice-line-$i'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: AbsTextField(
                key: ValueKey('invoice-desc-$i'),
                label: l.newInvItem,
                controller: x.desc,
                maxLength: 80,
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: AbsSpace.x2),
            Expanded(
              flex: 2,
              child: AbsTextField(
                key: ValueKey('invoice-amount-$i'),
                label: l.newInvAmount,
                controller: x.amount,
                prefixText: '₹',
                numeric: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(l.newInvQty, style: t.caption.copyWith(color: context.colors.textSecondary)),
            IconButton(
              onPressed: x.qty <= 1 ? null : () => setState(() => x.qty--),
              icon: Icon(PhosphorIcons.minus(PhosphorIconsStyle.bold)),
            ),
            Text('${x.qty}', style: t.numericOf(t.body)),
            IconButton(
              key: ValueKey('invoice-qty-plus-$i'),
              onPressed: x.qty >= 99 ? null : () => setState(() => x.qty++),
              icon: Icon(PhosphorIcons.plus(PhosphorIconsStyle.bold)),
            ),
            const Spacer(),
            if (x.paise > 0) Text(Money.format(x.paise), style: t.numericOf(t.body)),
            if (_lines.length > 1)
              IconButton(
                tooltip: l.commonRemove,
                onPressed: () => setState(() => _lines.removeAt(i).dispose()),
                icon: Icon(PhosphorIcons.x(PhosphorIconsStyle.bold)),
              ),
          ],
        ),
      ],
      AbsButton.ghost(
        key: const ValueKey('invoice-add-line'),
        label: l.newInvAddLine,
        icon: PhosphorIcons.plus(PhosphorIconsStyle.bold),
        hue: PopHue.tangerine,
        onPressed: () => setState(() => _lines.add(_Line())),
      ),
      gap,
      Text(l.newInvDue, style: t.heading),
      const SizedBox(height: AbsSpace.x2),
      Wrap(
        spacing: AbsSpace.x2,
        runSpacing: AbsSpace.x2,
        children: [
          PopChip(
            label: l.newInvDueToday,
            selected: _due == null,
            hue: PopHue.sky,
            onTap: () => setState(() => _due = null),
          ),
          PopChip(
            label: _due == null ? l.waSchedulePick : IstDates.formatDate(_due!, isDateOnly: true),
            icon: PhosphorIcons.calendarBlank(PhosphorIconsStyle.bold),
            selected: _due != null,
            hue: PopHue.sky,
            onTap: _pickDue,
          ),
        ],
      ),
      gap,
      Text(l.newInvGst, style: t.heading),
      const SizedBox(height: AbsSpace.x2),
      PopSingleChips<num>(
        options: const [0, 5, 12, 18],
        labelOf: (r) => '$r%',
        value: _gst,
        allowEmpty: false,
        hue: PopHue.grape,
        onChanged: (r) => setState(() => _gst = r ?? _gst),
      ),
      const SizedBox(height: AbsSpace.x1),
      Text(l.newInvGstHelp, style: t.caption.copyWith(color: context.colors.textSecondary)),
      gap,
      AbsTextField(
        key: const ValueKey('invoice-discount'),
        label: l.newInvDiscount,
        controller: _discount,
        prefixText: '₹',
        numeric: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        onChanged: (_) => setState(() {}),
      ),
      if (discount > 0) ...[
        gap,
        AbsTextField(key: const ValueKey('invoice-reason'), label: l.newInvReason, controller: _reason, maxLength: 120),
      ],
      const SizedBox(height: AbsSpace.x4),
      Row(
        children: [
          Expanded(child: Text(l.newInvSubtotal, style: t.body)),
          Text(Money.format(_total), style: t.numericOf(t.title)),
        ],
      ),
      if (_error != null) ...[
        const SizedBox(height: AbsSpace.x2),
        Text(_error!, style: t.caption.copyWith(color: context.colors.danger)),
      ],
      const SizedBox(height: AbsSpace.x4),
      AbsButton(
        key: const ValueKey('invoice-create'),
        label: l.newInvCreate(Money.format(_total)),
        hue: PopHue.tangerine,
        icon: PhosphorIcons.receipt(PhosphorIconsStyle.bold),
        isLoading: _busy,
        onPressed: _busy || _subtotal <= 0 ? null : _create,
      ),
    ];
  }
}
