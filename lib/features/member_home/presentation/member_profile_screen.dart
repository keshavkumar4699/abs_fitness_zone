import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/theme/theme.dart';
import '../../../core/utils/phone.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../settings/presentation/appearance_card.dart';
import '../data/my_member_repository.dart';

class MemberProfileScreen extends ConsumerWidget {
  const MemberProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final member = ref.watch(myMemberProvider);

    Widget card(String name, String code, String phone) => AbsCard(
      hue: PopHue.grape,
      child: Row(
        children: [
          AbsAvatar(name: name, size: AbsSpace.x14),
          const SizedBox(width: AbsSpace.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(name, style: t.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: AbsSpace.x1),
                Text('${l.profileMemberCode} · $code', style: t.numericOf(t.label).copyWith(color: c.textSecondary)),
                Text(Phone.display(phone), style: t.numericOf(t.caption).copyWith(color: c.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.profileTitle)),
      body: AbsRefresh(
        onRefresh: () => ref.refresh(myMemberProvider.future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            context.screenPadding,
            AbsSpace.x2,
            context.screenPadding,
            MediaQuery.paddingOf(context).bottom + AbsSpace.x6,
          ),
          children: [
            AsyncView<MyMember?>(
              value: member,
              onRetry: () => ref.invalidate(myMemberProvider),
              loading: SkeletonBlock(child: card('Member name', 'ABS-0000', '+910000000000')),
              isEmpty: (m) => m == null,
              empty: const SizedBox.shrink(),
              data: (m) => card(m!.name, m.memberCode, m.phone),
            ),
            const SizedBox(height: AbsSpace.x4),
            const AppearanceCard(),
            const SizedBox(height: AbsSpace.x6),
            AbsButton.secondary(
              label: l.commonSignOut,
              icon: PhosphorIcons.signOut(PhosphorIconsStyle.bold),
              onPressed: () => ref.read(authRepositoryProvider).signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
