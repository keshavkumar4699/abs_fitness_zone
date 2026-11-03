import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/utils/phone.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../shell/greeting_header.dart';
import '../data/my_member_repository.dart';

/// Member home: greeting and a colourful digital member card. Workouts, diet
/// and progress join in later milestones.
class MemberHomeScreen extends ConsumerWidget {
  const MemberHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider).value;
    final member = ref.watch(myMemberProvider);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: AbsRefresh(
          onRefresh: () => ref.refresh(myMemberProvider.future),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              context.screenPadding,
              AbsSpace.x4,
              context.screenPadding,
              MediaQuery.paddingOf(context).bottom + AbsSpace.x8,
            ),
            children: [
              GreetingHeader(name: (user?.name ?? '').split(' ').first),
              const SizedBox(height: AbsSpace.x6),
              AsyncView<MyMember?>(
                value: member,
                onRetry: () => ref.invalidate(myMemberProvider),
                loading: const SkeletonBlock(
                  child: MemberCard(name: 'Member name', code: 'ABS-0000', phone: '+910000000000'),
                ),
                isEmpty: (m) => m == null,
                empty: const SizedBox.shrink(),
                data: (m) => MemberCard(name: m!.name, code: m.memberCode, phone: m.phone),
              ),
              const SizedBox(height: AbsSpace.x5),
              AbsCard(
                hue: PopHue.bubblegum,
                child: Row(
                  children: [
                    IconBubble(icon: PhosphorIcons.barbell(PhosphorIconsStyle.bold), hue: PopHue.bubblegum),
                    const SizedBox(width: AbsSpace.x3),
                    Expanded(child: Text(l.memberHomeComingBody, style: context.text.body)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Digital membership card: candy gradient sticker with name, ID and phone.
class MemberCard extends StatelessWidget {
  const MemberCard({super.key, required this.name, required this.code, required this.phone});

  final String name;
  final String code;
  final String phone;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final ink = c.pop(PopHue.grape).onFill;
    return Semantics(
      container: true,
      label: '${context.l10n.memberCardTitle}: $name, $code',
      child: Container(
        padding: const EdgeInsets.all(AbsSpace.x5),
        decoration: stickerDecoration(c, color: c.pop(PopHue.grape).fill).copyWith(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [c.pop(PopHue.grape).fill, c.pop(PopHue.bubblegum).fill, c.pop(PopHue.tangerine).fill],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const BrandMark(size: 40),
                const SizedBox(width: AbsSpace.x3),
                Expanded(
                  child: Text(
                    context.l10n.memberCardTitle.toUpperCase(),
                    style: t.label.copyWith(color: ink, letterSpacing: 1.5),
                  ),
                ),
                Icon(PhosphorIcons.sparkle(PhosphorIconsStyle.fill), color: ink),
              ],
            ),
            const SizedBox(height: AbsSpace.x6),
            Text(
              name,
              style: t.displayL.copyWith(color: ink, fontSize: 30),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AbsSpace.x2),
            Wrap(
              spacing: AbsSpace.x2,
              runSpacing: AbsSpace.x2,
              children: [
                PopSticker(label: code, hue: PopHue.lime, numeric: true),
                PopSticker(label: Phone.display(phone), hue: PopHue.sky, numeric: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
