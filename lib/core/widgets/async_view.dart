import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n/l10n.dart';
import '../../app/theme/theme.dart';
import '../errors.dart';
import 'skeleton_list.dart';
import 'states.dart';

/// Renders all four required screen states for an [AsyncValue]:
/// loading (skeleton), empty, error (message + retry) and data, cross-fading
/// between them (200 ms) instead of popping.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    super.key,
    required this.value,
    required this.data,
    required this.onRetry,
    required this.empty,
    this.isEmpty,
    this.loading,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback onRetry;
  final Widget empty;
  final bool Function(T data)? isEmpty;
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    final Widget child;
    final String key;
    switch (value) {
      case AsyncData(:final value):
        final blank = isEmpty?.call(value) ?? (value is Iterable && value.isEmpty);
        child = blank ? empty : data(value);
        key = blank ? 'empty' : 'data';
      case AsyncError(:final error):
        child = ErrorState(message: friendlyError(context.l10n, error), onRetry: onRetry);
        key = 'error';
      default:
        child = loading ?? const SkeletonList();
        key = 'loading';
    }
    return AnimatedSwitcher(
      duration: AbsMotion.crossFade,
      switchInCurve: AbsMotion.quick.curve,
      switchOutCurve: AbsMotion.quick.curve,
      child: KeyedSubtree(key: ValueKey(key), child: child),
    );
  }
}
