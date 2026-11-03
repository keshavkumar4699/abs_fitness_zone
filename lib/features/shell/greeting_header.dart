import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/l10n/l10n.dart';
import '../../app/providers.dart';
import '../../app/theme/theme.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/pop_decor.dart';

/// "Hey Keshav!" with a waving hand bubble and today's date (IST).
class GreetingHeader extends ConsumerWidget {
  const GreetingHeader({super.key, required this.name, this.hue = PopHue.lime, this.trailing});

  final String name;
  final PopHue hue;
  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final t = context.text;
    final today = DateFormat('EEEE, d MMMM', 'en_US').format(IstDates.today(now: ref.watch(clockProvider)()));
    return Row(
      children: [
        Wiggle(
          child: IconBubble(icon: PhosphorIcons.handWaving(PhosphorIconsStyle.fill), hue: hue, size: 52),
        ),
        const SizedBox(width: AbsSpace.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.greeting(name), style: t.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(today, style: t.label.copyWith(color: c.textSecondary)),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}
