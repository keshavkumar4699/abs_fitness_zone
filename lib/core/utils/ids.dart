import 'dart:math';

final _rng = Random.secure();

/// A random version-4 UUID, made on the phone (workout client ids).
String newUuid() {
  final b = List<int>.generate(16, (_) => _rng.nextInt(256));
  b[6] = (b[6] & 0x0f) | 0x40;
  b[8] = (b[8] & 0x3f) | 0x80;
  String hex(int from, int to) => [for (final x in b.sublist(from, to)) x.toRadixString(16).padLeft(2, '0')].join();
  return '${hex(0, 4)}-${hex(4, 6)}-${hex(6, 8)}-${hex(8, 10)}-${hex(10, 16)}';
}
