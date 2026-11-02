import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../app/l10n/l10n.dart';
import '../../../app/routes.dart';
import '../../../app/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/app_user.dart';
import 'appearance_card.dart';

String roleLabel(AppLocalizations l, UserRole role) => switch (role) {
  UserRole.owner => l.roleOwner,
  UserRole.frontDesk => l.roleFrontDesk,
  UserRole.trainer => l.roleTrainer,
  UserRole.member => l.roleMember,
};

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final user = ref.watch(currentUserProvider).value;
    if (user == null) return const SizedBox.shrink();

    Widget item(IconData icon, String title, String subtitle, String route) => Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: AbsCard(
        onTap: () => context.push(route),
        padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x4, vertical: AbsSpace.x3),
        child: Row(
          children: [
            Icon(icon, color: c.accentText),
            const SizedBox(width: AbsSpace.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: t.heading),
                  Text(subtitle, style: t.caption.copyWith(color: c.textSecondary)),
                ],
              ),
            ),
            Icon(PhosphorIcons.caretRight(), color: c.textSecondary, size: AbsSize.iconSmall),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.moreTitle)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          context.screenPadding,
          AbsSpace.x2,
          context.screenPadding,
          MediaQuery.paddingOf(context).bottom + AbsSpace.x6,
        ),
        children: [
          AbsCard(
            child: Row(
              children: [
                AbsAvatar(name: user.name, size: AbsSpace.x14, ringColor: c.accent),
                const SizedBox(width: AbsSpace.x4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: t.heading),
                      const SizedBox(height: AbsSpace.x1),
                      InfoPill(label: roleLabel(l, user.role), color: c.accentText),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AbsSpace.x4),
          if (user.role.isOwner) item(PhosphorIcons.usersThree(), l.moreStaff, l.moreStaffSubtitle, Routes.staffTeam),
          if (user.role.isDesk)
            item(PhosphorIcons.password(), l.moreMemberPin, l.moreMemberPinSubtitle, Routes.memberPin),
          if (user.role.isOwner)
            item(PhosphorIcons.squaresFour(), l.moreGallery, l.moreGallerySubtitle, Routes.gallery),
          const AppearanceCard(),
          const SizedBox(height: AbsSpace.x6),
          AbsButton.secondary(
            label: l.commonSignOut,
            icon: PhosphorIcons.signOut(),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
    );
  }
}
