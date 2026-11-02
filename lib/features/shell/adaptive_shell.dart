import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/l10n/l10n.dart';
import '../../app/theme/theme.dart';
import '../../core/widgets/brand_mark.dart';

class NavDestination {
  const NavDestination({required this.label, required this.icon, required this.selectedIcon});

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

enum ShellLayout { phone, tablet, desktop }

ShellLayout shellLayoutFor(double width) {
  if (width >= AbsBreakpoint.desktop) return ShellLayout.desktop;
  if (width >= AbsBreakpoint.tablet) return ShellLayout.tablet;
  return ShellLayout.phone;
}

/// Bottom navigation on phones, a navigation rail on tablets and a
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

    switch (layout) {
      case ShellLayout.phone:
        return Scaffold(
          extendBody: true,
          body: widget.shell,
          floatingActionButton: widget.floatingActionButton,
          bottomNavigationBar: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: AbsGlass.sigma, sigmaY: AbsGlass.sigma),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: c.bg.withValues(alpha: AbsGlass.opacity),
                  border: Border(
                    top: BorderSide(color: c.border, width: AbsSize.hairline),
                  ),
                ),
                child: NavigationBar(
                  selectedIndex: selected,
                  onDestinationSelected: _go,
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  destinations: [
                    for (final d in widget.destinations)
                      NavigationDestination(
                        icon: Icon(d.icon, color: c.textSecondary),
                        selectedIcon: Icon(d.selectedIcon, color: c.textPrimary),
                        label: d.label,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      case ShellLayout.tablet:
        return Scaffold(
          floatingActionButton: widget.floatingActionButton,
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  selectedIndex: selected,
                  onDestinationSelected: _go,
                  labelType: NavigationRailLabelType.all,
                  leading: const Padding(
                    padding: EdgeInsets.symmetric(vertical: AbsSpace.x4),
                    child: BrandMark(size: AbsSpace.x10),
                  ),
                  destinations: [
                    for (final d in widget.destinations)
                      NavigationRailDestination(
                        icon: Icon(d.icon, color: c.textSecondary),
                        selectedIcon: Icon(d.selectedIcon, color: c.textPrimary),
                        label: Text(d.label),
                      ),
                  ],
                ),
              ),
              VerticalDivider(width: AbsSize.hairline, color: c.border),
              Expanded(child: widget.shell),
            ],
          ),
        );
      case ShellLayout.desktop:
        return CallbackShortcuts(
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
                  VerticalDivider(width: AbsSize.hairline, color: c.border),
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
        );
    }
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
                  const BrandMark(size: AbsSpace.x10),
                  if (!collapsed) ...[
                    const SizedBox(width: AbsSpace.x3),
                    Expanded(
                      child: Text(context.l10n.appName, style: t.heading, overflow: TextOverflow.fade, softWrap: false),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AbsSpace.x6),
              _SideItem(
                icon: PhosphorIcons.magnifyingGlass(),
                label: '${context.l10n.commonSearch}  Ctrl/⌘ K',
                collapsed: collapsed,
                selected: false,
                onTap: onSearch,
              ),
              const SizedBox(height: AbsSpace.x2),
              for (var i = 0; i < destinations.length; i++)
                _SideItem(
                  icon: i == selected ? destinations[i].selectedIcon : destinations[i].icon,
                  label: destinations[i].label,
                  collapsed: collapsed,
                  selected: i == selected,
                  onTap: () => onSelect(i),
                ),
              const Spacer(),
              _SideItem(
                icon: collapsed ? PhosphorIcons.caretDoubleRight() : PhosphorIcons.caretDoubleLeft(),
                label: '',
                collapsed: true,
                selected: false,
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
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool collapsed;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AbsSpace.x1),
      child: Material(
        color: selected ? c.accent.withValues(alpha: AbsOpacity.subtleFill) : Colors.transparent,
        borderRadius: AbsRadius.buttonAll,
        child: InkWell(
          borderRadius: AbsRadius.buttonAll,
          onTap: onTap,
          child: SizedBox(
            height: AbsSize.touchTarget,
            child: Row(
              children: [
                const SizedBox(width: AbsSpace.x3),
                Icon(icon, color: selected ? c.textPrimary : c.textSecondary),
                if (!collapsed && label.isNotEmpty) ...[
                  const SizedBox(width: AbsSpace.x3),
                  Expanded(
                    child: Text(
                      label,
                      style: context.text.label.copyWith(color: selected ? c.textPrimary : c.textSecondary),
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

/// Ctrl/Cmd+K palette. In M0 it jumps between sections; member and action
/// search plug in here as those features land.
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
                leading: Icon(widget.destinations[i].icon),
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
/// outgoing fades out, incoming fades in while scaling up from 0.92).
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
                  scale: i == index || reduced ? 1 : 0.92,
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
