/// Every list loads in pages of 30 (spec rule 4).
const kPageSize = 30;

class Paged<T> {
  const Paged(this.items, {required this.hasMore, this.loadingMore = false});

  final List<T> items;
  final bool hasMore;
  final bool loadingMore;

  bool get isEmpty => items.isEmpty;

  Paged<T> copyWith({List<T>? items, bool? hasMore, bool? loadingMore}) =>
      Paged(items ?? this.items, hasMore: hasMore ?? this.hasMore, loadingMore: loadingMore ?? this.loadingMore);
}

/// Strips characters that have meaning inside a PostgREST `or=(...)` filter
/// so user search text can never alter the query structure.
String sanitizeSearch(String input) => input.replaceAll(RegExp(r'[,()%*\\.:"]'), ' ').trim();
