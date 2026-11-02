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

    return Scaffold(
      appBar: AppBar(title: Text(l.profileTitle)),
      body: AbsRefresh(
        onRefresh: () => ref.refresh(myMemberProvider.future),
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            context.screenPadding,
            AbsSpace.x2,
            context.screenPadding,
            MediaQuery.paddingOf(context).bottom + AbsSpace.x6,
          ),
          children: [
            SizedBox(
              height: 120,
              child: AsyncView(
                value: member,
                onRetry: () => ref.invalidate(myMemberProvider),
                loading: const SkeletonBlock(
                  child: AbsCard(
                    child: ListTile(title: Text('Member name'), subtitle: Text('ABS-0000')),
                  ),
                ),
                isEmpty: (m) => m == null,
                empty: const SizedBox.shrink(),
                data: (m) => AbsCard(
                  child: Row(
                    children: [
                      AbsAvatar(name: m!.name, size: AbsSpace.x14, ringColor: c.accent),
                      const SizedBox(width: AbsSpace.x4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(m.name, style: t.heading),
                            const SizedBox(height: AbsSpace.x1),
                            Text(
                              '${l.profileMemberCode} · ${m.memberCode}',
                              style: t.numericOf(t.label).copyWith(color: c.textSecondary),
                            ),
                            Text(
                              Phone.display(m.phone),
                              style: t.numericOf(t.caption).copyWith(color: c.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AbsSpace.x4),
            const AppearanceCard(),
            const SizedBox(height: AbsSpace.x6),
            AbsButton.secondary(
              label: l.commonSignOut,
              icon: PhosphorIcons.signOut(),
              onPressed: () => ref.read(authRepositoryProvider).signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
