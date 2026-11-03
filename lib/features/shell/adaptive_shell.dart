import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/l10n/l10n.dart';
import '../../app/theme/theme.dart';
import '../../core/widgets/brand_mark.dart';

class NavDestination {
  const NavDestination({required this.label, required this.icon, required this.selectedIcon, required this.hue});

  final String label;
  final IconData icon;
  final IconData selectedIcon;

  /// Each section owns a pop colour.
  final PopHue hue;
}

enum ShellLayout { phone, tablet, desktop }

ShellLayout shellLayoutFor(double width) {
  if (width >= AbsBreakpoint.desktop) return ShellLayout.desktop;
  if (width >= AbsBreakpoint.tablet) return ShellLayout.tablet;
  return ShellLayout.phone;
}

/// Floating sticker tab bar on phones, a navigation rail on tablets and a
/// collapsible side nav (with a Ctrl/Cmd+K command palette) on desktop.
class AdaptiveShell extends StatefulWidget {
  const AdaptiveShell({super.key, required this.shell, required this.destinations, this.floatingActionButton});

  final StatefulNavigationShell shell;
  final List<NavDestination> destinations;
  final Widget? floatingActionButton;

  @override
  State<AdaptiveShell> createState() => _AdaptiveShellState();
}

class _AdaptiveShellState extends State<AdaptiveShell> {
  bool _collapsed = false;

  void _go(int index) {
    if (index != widget.shell.currentIndex) HapticFeedback.selectionClick();
    widget.shell.goBranch(index, initialLocation: index == widget.shell.currentIndex);
  }

  Future<void> _openPalette() async {
    final index = await showDialog<int>(
      context: context,
      builder: (context) => _CommandPalette(destinations: widget.destinations),
    );
    if (index != null) _go(index);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final layout = shellLayoutFor(MediaQuery.sizeOf(context).width);
    final selected = widget.shell.currentIndex;

    final Widget scaffold = switch (layout) {
      ShellLayout.phone => Scaffold(
        extendBody: true,
        body: widget.shell,
        floatingActionButton: widget.floatingActionButton,
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(AbsSpace.x3, 0, AbsSpace.x3, AbsSpace.x3),
          child: _PopNavBar(destinations: widget.destinations, selected: selected, onSelect: _go),
        ),
      ),
      ShellLayout.tablet => Scaffold(
        floatingActionButton: widget.floatingActionButton,
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                selectedIndex: selected,
                onDestinationSelected: _go,
                labelType: NavigationRailLabelType.all,
                indicatorColor: c.pop(widget.destinations[selected].hue).fill,
                indicatorShape: const StadiumBorder(),
                leading: const Padding(
                  padding: EdgeInsets.symmetric(vertical: AbsSpace.x4),
                  child: BrandMark(size: AbsSpace.x10 + 4),
                ),
                destinations: [
                  for (final d in widget.destinations)
                    NavigationRailDestination(
                      icon: Icon(d.icon, color: c.textSecondary),
                      selectedIcon: Icon(d.selectedIcon, color: c.pop(d.hue).onFill),
                      label: Text(d.label),
                    ),
                ],
              ),
            ),
            VerticalDivider(width: AbsDepth.outline, thickness: AbsDepth.outline, color: c.border),
            Expanded(child: widget.shell),
          ],
        ),
      ),
      ShellLayout.desktop => CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyK, control: true): _openPalette,
          const SingleActivator(LogicalKeyboardKey.keyK, meta: true): _openPalette,
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            floatingActionButton: widget.floatingActionButton,
            body: Row(
              children: [
                _SideNav(
                  destinations: widget.destinations,
                  selected: selected,
                  collapsed: _collapsed,
                  onSelect: _go,
                  onToggle: () => setState(() => _collapsed = !_collapsed),
                  onSearch: _openPalette,
                ),
                VerticalDivider(width: AbsDepth.outline, thickness: AbsDepth.outline, color: c.border),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: AbsSpace.maxContentWidth),
                      child: widget.shell,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    };

    // Android back on a non-home tab goes to the first tab instead of closing
    // the app. Pops inside a tab's own stack are handled before this.
    return PopScope(
      canPop: selected == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && selected != 0) _go(0);
      },
      child: scaffold,
    );
  }
}

/// Floating sticker tab bar. The selected tab pops up in its section colour.
class _PopNavBar extends StatelessWidget {
  const _PopNavBar({required this.destinations, required this.selected, required this.onSelect});

  final List<NavDestination> destinations;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Container(
      height: AbsSize.bottomNavHeight,
      decoration: stickerDecoration(c, borderRadius: BorderRadius.circular(AbsRadius.sheet)),
      padding: const EdgeInsets.symmetric(horizontal: AbsSpace.x1),
      child: Row(
        children: [
          for (var i = 0; i < destinations.length; i++)
            Expanded(
              child: Semantics(
                selected: i == selected,
                button: true,
                label: destinations[i].label,
                onTap: () => onSelect(i),
                excludeSemantics: true,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onSelect(i),
                  child: _NavItem(destination: destinations[i], selected: i == selected, textStyle: t.caption),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.destination, required this.selected, required this.textStyle});

  final NavDestination destination;
  final bool selected;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final p = c.pop(destination.hue);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedScale(
          scale: selected ? 1 : 0.92,
          duration: AbsMotion.bouncy.duration,
          curve: AbsMotion.bouncy.curve,
          child: AnimatedContainer(
            duration: AbsMotion.quick.duration,
            curve: AbsMotion.quick.curve,
            width: 52,
            height: 30,
            decoration: BoxDecoration(
              color: selected ? p.fill : Colors.transparent,
              borderRadius: AbsRadius.pill,
              border: Border.all(color: selected ? (c.isDark ? p.deep : c.ink) : Colors.transparent, width: 1.5),
            ),
            child: Icon(
              selected ? destination.selectedIcon : destination.icon,
              size: 22,
              color: selected ? p.onFill : c.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          destination.label,
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
          textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.1),
          style: textStyle.copyWith(
            color: selected ? c.textPrimary : c.textSecondary,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SideNav extends StatelessWidget {
  const _SideNav({
    required this.destinations,
    required this.selected,
    required this.collapsed,
    required this.onSelect,
    required this.onToggle,
    required this.onSearch,
  });

  final List<NavDestination> destinations;
  final int selected;
  final bool collapsed;
  final ValueChanged<int> onSelect;
  final VoidCallback onToggle;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return AnimatedContainer(
      duration: AbsMotion.standard.duration,
      curve: AbsMotion.standard.curve,
      width: collapsed ? AbsSize.sideNavCollapsedWidth : AbsSize.sideNavWidth,
      color: c.bg,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AbsSpace.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const BrandMark(size: AbsSpace.x10 + 4),
                  if (!collapsed) ...[
                    const SizedBox(width: AbsSpace.x3),
                    Expanded(
                      child: Text(context.l10n.appName, style: t.title, overflow: TextOverflow.fade, softWrap: false),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AbsSpace.x6),
              _SideItem(
                icon: PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
                label: '${context.l10n.commonSearch}  Ctrl/⌘ K',
                collapsed: collapsed,
                hue: null,
                onTap: onSearch,
              ),
              const SizedBox(height: AbsSpace.x2),
              for (var i = 0; i < destinations.length; i++)
                _SideItem(
                  icon: i == selected ? destinations[i].selectedIcon : destinations[i].icon,
                  label: destinations[i].label,
                  collapsed: collapsed,
                  hue: i == selected ? destinations[i].hue : null,
                  onTap: () => onSelect(i),
                ),
              const Spacer(),
              _SideItem(
                icon: collapsed ? PhosphorIcons.caretDoubleRight() : PhosphorIcons.caretDoubleLeft(),
                label: '',
                collapsed: true,
                hue: null,
                onTap: onToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideItem extends StatelessWidget {
  const _SideItem({
    required this.icon,
    required this.label,
    required this.collapsed,
    required this.hue,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool collapsed;

  /// Non-null when selected.
  final PopHue? hue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final p = hue == null ? null : c.pop(hue!);
    final fg = p?.onFill ?? c.textSecondary;
    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x2),
      child: Material(
        color: p?.fill ?? Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AbsRadius.buttonAll,
          side: p == null ? BorderSide.none : BorderSide(color: c.isDark ? p.deep : c.ink, width: AbsDepth.outline),
        ),
        child: InkWell(
          borderRadius: AbsRadius.buttonAll,
          onTap: onTap,
          child: SizedBox(
            height: AbsSize.touchTarget,
            child: Row(
              children: [
                const SizedBox(width: AbsSpace.x3 + 2),
                Icon(icon, color: fg),
                if (!collapsed && label.isNotEmpty) ...[
                  const SizedBox(width: AbsSpace.x3),
                  Expanded(
                    child: Text(
                      label,
                      style: context.text.label.copyWith(color: p?.onFill ?? c.textPrimary),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Ctrl/Cmd+K palette. Jumps between sections; member and action search plug
/// in here as those features land.
class _CommandPalette extends StatefulWidget {
  const _CommandPalette({required this.destinations});

  final List<NavDestination> destinations;

  @override
  State<_CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends State<_CommandPalette> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final matches = [
      for (var i = 0; i < widget.destinations.length; i++)
        if (widget.destinations[i].label.toLowerCase().contains(_query.toLowerCase())) i,
    ];
    return Dialog(
      alignment: const Alignment(0, -0.5),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AbsSpace.x3),
              child: TextField(
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
                onSubmitted: (_) {
                  if (matches.isNotEmpty) Navigator.pop(context, matches.first);
                },
                decoration: InputDecoration(
                  hintText: context.l10n.commonSearch,
                  prefixIcon: Icon(PhosphorIcons.magnifyingGlass(), color: c.textSecondary),
                ),
              ),
            ),
            for (final i in matches)
              ListTile(
                leading: Icon(widget.destinations[i].icon, color: c.pop(widget.destinations[i].hue).text),
                title: Text(widget.destinations[i].label),
                onTap: () => Navigator.pop(context, i),
              ),
            const SizedBox(height: AbsSpace.x2),
          ],
        ),
      ),
    );
  }
}

/// Keeps every branch alive and cross-fades between them (fade-through:
/// outgoing fades out, incoming fades in while scaling up).
class FadeThroughBranches extends StatelessWidget {
  const FadeThroughBranches({super.key, required this.index, required this.children});

  final int index;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final reduced = AbsMotion.reduced(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        for (var i = 0; i < children.length; i++)
          IgnorePointer(
            ignoring: i != index,
            child: TickerMode(
              enabled: i == index,
              child: AnimatedOpacity(
                opacity: i == index ? 1 : 0,
                duration: AbsMotion.standard.duration,
                curve: i == index ? const Interval(0.35, 1, curve: Curves.easeOut) : const Interval(0, 0.35),
                child: AnimatedScale(
                  scale: i == index || reduced ? 1 : 0.94,
                  duration: AbsMotion.standard.duration,
                  curve: AbsMotion.standard.curve,
                  child: ExcludeSemantics(excluding: i != index, child: children[i]),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
