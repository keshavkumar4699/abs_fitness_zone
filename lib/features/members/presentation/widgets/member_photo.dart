import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/member_tile.dart';
import '../../application/members_providers.dart';

/// Avatar that loads a private member photo through a short-lived signed URL
/// and falls back to coloured initials.
class MemberPhoto extends ConsumerWidget {
  const MemberPhoto({super.key, required this.name, required this.path, this.size = 46, this.ringColor});

  final String name;
  final String? path;
  final double size;
  final Color? ringColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = path == null ? null : ref.watch(photoUrlProvider(path)).value;
    return AbsAvatar(name: name, imageUrl: url, size: size, ringColor: ringColor);
  }
}
