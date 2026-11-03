import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/errors.dart';
import '../../../core/widgets/widgets.dart';
import '../application/workouts_providers.dart';
import 'assign_sheet.dart';

/// The gym's program library (5.3) with search; starters first.
class ProgramsView extends ConsumerStatefulWidget {
  const ProgramsView({super.key, this.footerPad = 0});

  final double footerPad;

  @override
  ConsumerState<ProgramsView> createState() => _ProgramsViewState();
}

class _ProgramsViewState extends ConsumerState<ProgramsView> {
  String _search = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final list = ref.watch(templateListProvider(_search));
    return AbsRefresh(
      onRefresh: () => ref.refresh(templateListProvider(_search).future),
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.extentAfter < 500) ref.read(templateListProvider(_search).notifier).loadMore();
          return false;
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(context.screenPadding, 0, context.screenPadding, widget.footerPad + AbsSpace.x6),
          children: [
            AbsTextField(
              label: l.progSearch,
              suffix: Icon(PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold)),
              onChanged: (v) {
                _debounce?.cancel();
                _debounce = Timer(AbsMotion.standard.duration, () => setState(() => _search = v.trim()));
              },
            ),
            const SizedBox(height: AbsSpace.x4),
            switch (list) {
              AsyncData(:final value) when value.items.isNotEmpty => Column(
                children: [
                  for (final (i, t) in value.items.indexed)
                    Entrance(
                      index: i,
                      child: TemplateCard(template: t, onTap: () => context.push(Routes.programDetail(t.id!))),
                    ),
                ],
              ),
              AsyncData() => EmptyState(
                title: l.progEmptyTitle,
                message: l.progEmptyBody,
                illustration: EmptyIllustration.dumbbell,
                hue: PopHue.bubblegum,
              ),
              AsyncError(:final error) => ErrorState(
                message: friendlyError(l, error),
                onRetry: () => ref.invalidate(templateListProvider(_search)),
              ),
              _ => const SizedBox(height: 400, child: SkeletonList(itemCount: 4)),
            },
          ],
        ),
      ),
    );
  }
}
