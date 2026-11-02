import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../app/theme/theme.dart';

/// Sliver header that collapses from a large title + search field into a
/// compact sticky search field on scroll. The sticky part uses the glass blur.
class SearchBarHero extends StatelessWidget {
  const SearchBarHero({
    super.key,
    required this.title,
    required this.hint,
    this.controller,
    this.onChanged,
    this.leading,
    this.actions = const [],
  });

  /// Usually a back button, shown before the title.
  final Widget? leading;
  final String title;
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    return SliverPersistentHeader(
      pinned: true,
      delegate: _Delegate(
        title: title,
        hint: hint,
        controller: controller,
        onChanged: onChanged,
        leading: leading,
        actions: actions,
        topInset: topInset,
        textScale: textScale,
      ),
    );
  }
}

class _Delegate extends SliverPersistentHeaderDelegate {
  _Delegate({
    required this.title,
    required this.hint,
    required this.controller,
    required this.onChanged,
    required this.leading,
    required this.actions,
    required this.topInset,
    required this.textScale,
  });

  final Widget? leading;

  final String title;
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final List<Widget> actions;
  final double topInset;
  final double textScale;

  double get _field => AbsSize.touchTarget;
  double get _titleBlock => (AbsSpace.x14 - AbsSpace.x2) * textScale;

  @override
  double get minExtent => topInset + _field + AbsSpace.x4;

  @override
  double get maxExtent => minExtent + _titleBlock;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final c = context.colors;
    final t = context.text;
    final collapse = (shrinkOffset / _titleBlock).clamp(0.0, 1.0);
    final pad = context.screenPadding;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AbsGlass.sigma, sigmaY: AbsGlass.sigma),
        child: Container(
          color: c.bg.withValues(alpha: collapse > 0 ? AbsGlass.opacity : 1),
          padding: EdgeInsets.fromLTRB(pad, topInset, pad, AbsSpace.x2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Opacity(
                  opacity: 1 - collapse,
                  child: Transform.translate(
                    offset: Offset(0, -AbsSpace.x3 * collapse),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          if (leading != null) ...[leading!, const SizedBox(width: AbsSpace.x1)],
                          Expanded(
                            child: Text(
                              title,
                              style: t.displayL.copyWith(fontSize: t.title.fontSize! * 1.3),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ...actions,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: _field,
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  style: t.body,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: t.body.copyWith(color: c.textSecondary),
                    prefixIcon: Icon(PhosphorIcons.magnifyingGlass(), color: c.textSecondary),
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: AbsRadius.pill,
                      borderSide: BorderSide(color: c.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AbsRadius.pill,
                      borderSide: BorderSide(color: c.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AbsRadius.pill,
                      borderSide: BorderSide(color: c.accentText),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_Delegate old) =>
      old.title != title ||
      old.hint != hint ||
      old.topInset != topInset ||
      old.textScale != textScale ||
      old.actions != actions;
}
