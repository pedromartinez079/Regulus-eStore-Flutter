import 'package:flutter_riverpod/legacy.dart';

class Filter {
  final List<bool> filter;

  const Filter({
    required this.filter,
  });
}

class FilterNotifier extends StateNotifier<Filter> {
  FilterNotifier()
    : super(const Filter(filter: [],));

  void setFilter(Filter filter) {
    state = filter;
  }

  List getFilter() { return state.filter; }
}

final filterProvider =
  StateNotifierProvider<FilterNotifier, Filter>((ref) {
    return FilterNotifier();
  });