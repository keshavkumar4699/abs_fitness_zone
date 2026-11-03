import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/l10n/l10n.dart';
import '../../app/routes.dart';
import '../../app/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../auth/application/auth_providers.dart';
import '../auth/domain/app_user.dart';
import 'greeting_header.dart';

/// Staff home. Until the dashboard lands (counts in M1, revenue in M2) it
/// shows a colourful "get started" checklist of the things that work today.
class StaffHomeScreen extends ConsumerWidget {
  const StaffHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    if (user == null) return const SizedBox.shrink();
    final l = context.l10n;
    final t = context.text;
    final first = user.name.split(' ').first;

    final steps = <(IconData, String, String, PopHue, String)>[
      if (user.role.isOwner)
        (
          PhosphorIcons.usersThree(PhosphorIconsStyle.bold),
          l.homeStepInvite,
          l.homeStepInviteBody,
          PopHue.sky,
          Routes.staffTeam,
        ),
      if (user.role.isDesk)
        (
          PhosphorIcons.password(PhosphorIconsStyle.bold),
          l.homeStepPin,
          l.homeStepPinBody,
          PopHue.tangerine,
          Routes.memberPin,
        ),
      (
        PhosphorIcons.palette(PhosphorIconsStyle.bold),
        l.homeStepLook,
        l.homeStepLookBody,
        PopHue.bubblegum,
        Routes.staffMore,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            context.screenPadding,
            AbsSpace.x4,
            context.screenPadding,
            MediaQuery.paddingOf(context).bottom + AbsSpace.x8,
          ),
          children: [
            GreetingHeader(name: first),
            const SizedBox(height: AbsSpace.x6),
            if (user.role == UserRole.trainer) ...[
              _ComingCard(body: l.homeTrainerBody),
            ] else ...[
              Text(l.homeGetStarted, style: t.title),
              const SizedBox(height: AbsSpace.x3),
              for (var i = 0; i < steps.length; i++)
                Entrance(
                  index: i,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AbsSpace.x3),
                    child: _StepCard(
                      number: i + 1,
                      icon: steps[i].$1,
                      title: steps[i].$2,
                      body: steps[i].$3,
                      hue: steps[i].$4,
                      onTap: () =>
                          steps[i].$5 == Routes.staffMore ? context.go(steps[i].$5) : context.push(steps[i].$5),
                    ),
                  ),
                ),
              const SizedBox(height: AbsSpace.x3),
              _ComingCard(body: l.homeComingBody),
            ],
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.body,
    required this.hue,
    required this.onTap,
  });

  final int number;
  final IconData icon;
  final String title;
  final String body;
  final PopHue hue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return AbsCard(
      hue: hue,
      onTap: onTap,
      padding: const EdgeInsets.all(AbsSpace.x4),
      child: Row(
        children: [
          IconBubble(icon: icon, hue: hue, size: 48),
          const SizedBox(width: AbsSpace.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: t.heading),
                Text(body, style: t.caption.copyWith(color: c.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: AbsSpace.x2),
          PopSticker(label: '$number', hue: hue, numeric: true),
        ],
      ),
    );
  }
}

class _ComingCard extends StatelessWidget {
  const _ComingCard({required this.body});

  final String body;

  @override
  Widget build(BuildContext context) {
    final t = context.text;
    return AbsCard(
      hue: PopHue.grape,
      solid: true,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.homeComingTitle,
                  style: t.title.copyWith(color: context.colors.pop(PopHue.grape).onFill),
                ),
                const SizedBox(height: AbsSpace.x1),
                Text(body, style: t.body.copyWith(color: context.colors.pop(PopHue.grape).onFill)),
              ],
            ),
          ),
          const SizedBox(width: AbsSpace.x3),
          StickerIllustration(icon: PhosphorIcons.rocketLaunch(PhosphorIconsStyle.bold), hue: PopHue.lime, size: 88),
        ],
      ),
    );
  }
}
