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

PopHue roleHue(UserRole role) => switch (role) {
  UserRole.owner => PopHue.lime,
  UserRole.frontDesk => PopHue.sky,
  UserRole.trainer => PopHue.bubblegum,
  UserRole.member => PopHue.grape,
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

    Widget item(IconData icon, String title, String subtitle, String route, PopHue hue) => Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x3),
      child: AbsCard(
        onTap: () => context.push(route),
        padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x4, vertical: AbsSpace.x3),
        child: Row(
          children: [
            IconBubble(icon: icon, hue: hue),
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
            Icon(PhosphorIcons.caretRight(PhosphorIconsStyle.bold), color: c.textSecondary, size: AbsSize.iconSmall),
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
            hue: roleHue(user.role),
            child: Row(
              children: [
                AbsAvatar(name: user.name, size: AbsSpace.x14),
                const SizedBox(width: AbsSpace.x4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: t.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: AbsSpace.x1),
                      PopSticker(label: roleLabel(l, user.role), hue: roleHue(user.role)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AbsSpace.x4),
          if (user.role.isOwner)
            item(
              PhosphorIcons.usersThree(PhosphorIconsStyle.bold),
              l.moreStaff,
              l.moreStaffSubtitle,
              Routes.staffTeam,
              PopHue.sky,
            ),
          if (user.role.isDesk)
            item(
              PhosphorIcons.whatsappLogo(PhosphorIconsStyle.bold),
              l.waTitle,
              l.waMoreSubtitle,
              Routes.whatsApp,
              PopHue.mint,
            ),
          if (user.role.isDesk)
            item(
              PhosphorIcons.lockKey(PhosphorIconsStyle.bold),
              l.moreDayClose,
              l.moreDayCloseSubtitle,
              Routes.dayClose,
              PopHue.grape,
            ),
          if (user.role.isDesk)
            item(
              PhosphorIcons.clockCounterClockwise(PhosphorIconsStyle.bold),
              l.morePaymentHistory,
              l.morePaymentHistorySubtitle,
              Routes.paymentHistory,
              PopHue.sky,
            ),
          if (user.role.isOwner)
            item(
              PhosphorIcons.receipt(PhosphorIconsStyle.bold),
              l.moreExpenses,
              l.moreExpensesSubtitle,
              Routes.expenses,
              PopHue.coral,
            ),
          item(
            PhosphorIcons.tag(PhosphorIconsStyle.bold),
            l.morePlans,
            l.morePlansSubtitle,
            Routes.membershipPlans,
            PopHue.lime,
          ),
          if (user.role.isDesk)
            item(
              PhosphorIcons.qrCode(PhosphorIconsStyle.bold),
              l.moreGymQr,
              l.moreGymQrSubtitle,
              Routes.gymQr,
              PopHue.mint,
            ),
          if (user.role.isDesk)
            item(
              PhosphorIcons.fileArrowUp(PhosphorIconsStyle.bold),
              l.moreImport,
              l.moreImportSubtitle,
              Routes.memberImport,
              PopHue.tangerine,
            ),
          if (user.role.isOwner)
            item(
              PhosphorIcons.storefront(PhosphorIconsStyle.bold),
              l.moreGymProfile,
              l.moreGymProfileSubtitle,
              Routes.gymProfile,
              PopHue.grape,
            ),
          if (user.role.isOwner)
            item(
              PhosphorIcons.squaresFour(PhosphorIconsStyle.bold),
              l.moreGallery,
              l.moreGallerySubtitle,
              Routes.gallery,
              PopHue.bubblegum,
            ),
          const AppearanceCard(),
          const SizedBox(height: AbsSpace.x6),
          AbsButton.secondary(
            label: l.commonSignOut,
            icon: PhosphorIcons.signOut(PhosphorIconsStyle.bold),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
    );
  }
}
