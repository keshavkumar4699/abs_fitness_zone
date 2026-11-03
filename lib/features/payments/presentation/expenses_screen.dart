import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/widgets.dart';
import '../../members/presentation/member_ui.dart' show dateLabel;
import '../application/payments_providers.dart';
import '../data/payments_repository.dart';
import '../domain/payment_models.dart';
import 'payment_ui.dart';

/// Owner expenses (2.12) by month, feeding profit in reports.
class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  late DateTime _month = () {
    final t = IstDates.today();
    return DateTime.utc(t.year, t.month);
  }();

  void _shift(int months) => setState(() => _month = DateTime.utc(_month.year, _month.month + months));

  Future<void> _delete(Expense e) async {
    final l = context.l10n;
    try {
      await ref.read(paymentsRepositoryProvider).deleteExpense(e.id!);
      ref.invalidate(expensesForMonthProvider(_month));
      if (mounted) showAbsSnackbar(context, l.expenseDeleted, tone: SnackTone.success);
    } catch (err) {
      if (mounted) showAbsSnackbar(context, friendlyError(l, err), tone: SnackTone.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    final c = context.colors;
    final list = ref.watch(expensesForMonthProvider(_month));
    final monthLabel = DateFormat('MMMM yyyy').format(_month);
    final today = IstDates.today();
    final isCurrent = _month.year == today.year && _month.month == today.month;
    final total = (list.value ?? const <Expense>[]).fold(0, (a, e) => a + e.amountPaise);
    final p = c.pop(PopHue.coral);

    return Scaffold(
      appBar: AppBar(title: Text(l.expensesTitle)),
      floatingActionButton: Padding(
        // Clear of the floating tab bar.
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: FloatingActionButton.extended(
          key: const ValueKey('add-expense'),
          onPressed: () async {
            final saved = await showExpenseSheet(context, month: _month);
            if (saved == true) ref.invalidate(expensesForMonthProvider(_month));
          },
          icon: Icon(PhosphorIcons.plus(PhosphorIconsStyle.bold)),
          label: Text(l.expenseAdd),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          context.screenPadding,
          AbsSpace.x2,
          context.screenPadding,
          MediaQuery.paddingOf(context).bottom + AbsSpace.x14 * 2,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(AbsSpace.x5),
            decoration: stickerDecoration(c, color: p.fill, lip: c.isDark ? p.deep : c.ink),
            child: Row(
              children: [
                IconButton(
                  tooltip: l.previousMonth,
                  icon: Icon(PhosphorIcons.caretLeft(PhosphorIconsStyle.bold), color: p.onFill),
                  onPressed: () => _shift(-1),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(l.expensesTotal(monthLabel), style: t.label.copyWith(color: p.onFill)),
                      CountUp(
                        key: const ValueKey('expenses-total'),
                        value: total,
                        format: (v) => Money.format(v.round()),
                        style: t.numericOf(t.displayL).copyWith(color: p.onFill),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l.nextMonth,
                  icon: Icon(PhosphorIcons.caretRight(PhosphorIconsStyle.bold), color: p.onFill),
                  onPressed: isCurrent ? null : () => _shift(1),
                ),
              ],
            ),
          ),
          const SizedBox(height: AbsSpace.x4),
          AsyncView<List<Expense>>(
            value: list,
            onRetry: () => ref.invalidate(expensesForMonthProvider(_month)),
            loading: const SizedBox(height: 240, child: SkeletonList(itemCount: 3)),
            isEmpty: (v) => v.isEmpty,
            empty: EmptyState(
              title: l.expensesEmptyTitle,
              message: l.expensesEmptyBody,
              illustration: EmptyIllustration.receipt,
              hue: PopHue.coral,
            ),
            data: (items) => Column(
              children: [
                for (final (i, e) in items.indexed)
                  Entrance(
                    index: i,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: AbsSpace.x2),
                      child: AbsCard(
                        padding: const EdgeInsets.fromLTRB(AbsSpace.x4, AbsSpace.x3, AbsSpace.x1, AbsSpace.x3),
                        child: Row(
                          children: [
                            IconBubble(icon: expenseIcon(e.category), hue: PopHue.coral, size: 40),
                            const SizedBox(width: AbsSpace.x3),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(expenseCategoryName(l, e.category), style: t.heading),
                                  Text(
                                    [
                                      dateLabel(e.spentOn),
                                      if (e.note != null && e.note!.isNotEmpty) e.note!,
                                    ].join(' · '),
                                    style: t.caption.copyWith(color: c.textSecondary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Text(Money.format(e.amountPaise), style: t.numericOf(t.heading)),
                            IconButton(
                              tooltip: l.expenseDelete,
                              icon: Icon(PhosphorIcons.trash(PhosphorIconsStyle.bold), size: AbsSize.iconSmall),
                              onPressed: () => _delete(e),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool?> showExpenseSheet(BuildContext context, {required DateTime month}) => showAbsBottomSheet<bool>(
  context: context,
  expandToFull: true,
  builder: (context, controller) => _ExpenseSheet(controller: controller, month: month),
);

class _ExpenseSheet extends ConsumerStatefulWidget {
  const _ExpenseSheet({required this.controller, required this.month});

  final ScrollController controller;
  final DateTime month;

  @override
  ConsumerState<_ExpenseSheet> createState() => _ExpenseSheetState();
}

class _ExpenseSheetState extends ConsumerState<_ExpenseSheet> {
  String _category = 'rent';
  final _amount = TextEditingController();
  final _note = TextEditingController();
  late DateTime _date = () {
    final today = IstDates.today();
    final inMonth = today.year == widget.month.year && today.month == widget.month.month;
    return inMonth ? today : DateTime.utc(widget.month.year, widget.month.month + 1, 0);
  }();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l = context.l10n;
    final amount = Money.parse(_amount.text) ?? 0;
    if (amount <= 0) return setState(() => _error = l.amountRequired);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(paymentsRepositoryProvider)
          .addExpense(
            Expense(
              category: _category,
              amountPaise: amount,
              spentOn: _date,
              note: _note.text.trim().isEmpty ? null : _note.text.trim(),
            ),
          );
      if (!mounted) return;
      showAbsSnackbar(context, l.expenseSaved, tone: SnackTone.success);
      Navigator.pop(context, true);
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
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: widget.controller,
            padding: EdgeInsets.symmetric(horizontal: context.screenPadding),
            children: [
              Text(l.expenseAdd, style: context.text.title),
              const SizedBox(height: AbsSpace.x4),
              Text(l.expenseCategory, style: context.text.label.copyWith(color: context.colors.textSecondary)),
              const SizedBox(height: AbsSpace.x2),
              PopSingleChips<String>(
                options: expenseCategories,
                labelOf: (c) => expenseCategoryName(l, c),
                value: _category,
                allowEmpty: false,
                hue: PopHue.coral,
                onChanged: (c) => setState(() => _category = c ?? 'other'),
              ),
              const SizedBox(height: AbsSpace.x4),
              AbsTextField(
                key: const ValueKey('expense-amount'),
                label: l.expenseAmount,
                controller: _amount,
                prefixText: '₹',
                numeric: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: AbsSpace.x3),
              DateField(
                label: l.expenseDate,
                value: _date,
                allowClear: false,
                last: IstDates.today(),
                onChanged: (d) => setState(() => _date = d ?? _date),
              ),
              const SizedBox(height: AbsSpace.x3),
              AbsTextField(label: l.expenseNote, controller: _note),
              if (_error != null) ...[
                const SizedBox(height: AbsSpace.x2),
                Text(_error!, style: context.text.label.copyWith(color: context.colors.danger)),
              ],
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(context.screenPadding, AbsSpace.x2, context.screenPadding, AbsSpace.x4),
          child: AbsButton(
            key: const ValueKey('expense-save'),
            label: l.commonSave,
            hue: PopHue.coral,
            isLoading: _busy,
            onPressed: _save,
          ),
        ),
      ],
    );
  }
}
