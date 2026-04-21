import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/legacy.dart';
import '../../export/core.dart';

class PullToRefreshState<T> {
  final List<T> visibleList;
  final bool isLoading;
  final bool isCanLoadMoreItem;
  final String? errorMessage;

  PullToRefreshState({
    required this.visibleList,
    required this.isLoading,
    required this.isCanLoadMoreItem,
    this.errorMessage,
  });

  PullToRefreshState<T> copyWith({
    List<T>? visibleList,
    bool? isLoading,
    bool? isCanLoadMoreItem,
    String? errorMessage,
  }) {
    return PullToRefreshState<T>(
      visibleList: visibleList ?? this.visibleList,
      isLoading: isLoading ?? this.isLoading,
      isCanLoadMoreItem: isCanLoadMoreItem ?? this.isCanLoadMoreItem,
      errorMessage: errorMessage,
    );
  }
}

class PullToRefreshNotifier<T> extends StateNotifier<PullToRefreshState<T>> {
  final Future<List<T>> Function(int page) fetchPage;
  final int pageSize;
  int page = 0;

  PullToRefreshNotifier({required this.fetchPage, this.pageSize = 20})
      : super(
    PullToRefreshState(
      visibleList: [],
      isLoading: false,
      isCanLoadMoreItem: true,
    ),
  );

  List<T> get visibleItems => state.visibleList;

  bool get canLoadMore => state.isCanLoadMoreItem;

  bool get isLoading => state.isLoading;

  Future<List<T>> loadMore({bool isFetchUntilHasEnoughData = true}) async {
    if (!state.isCanLoadMoreItem) {
      return [];
    }

    if (state.isLoading) return [];

    state = state.copyWith(isLoading: true);
    try {
      final List<T> buffer = [];
      final int minRequired = SizeAppUtils().isTablet ? 10 : 5;

      const int maxFetchRounds = 2; // prevent infinite loop
      int fetchCount = 0;

      if (!isFetchUntilHasEnoughData) {
        final pageData = await fetchPage(page);
        page++;
        fetchCount++;
        buffer.addAll(pageData);
      } else {
        while (buffer.length < minRequired && fetchCount < maxFetchRounds) {
          final pageData = await fetchPage(page);
          page++;
          fetchCount++;

          // Data source has nothing left to return
          if (pageData.isEmpty) {
            break;
          }

          buffer.addAll(pageData);
        }
      }

      // out of data
      if (buffer.isEmpty) {
        state = state.copyWith(isLoading: false, isCanLoadMoreItem: false);
        return [];
      }

      if (!mounted) return [];

      state = state.copyWith(
        visibleList: [...state.visibleList, ...buffer],
        isLoading: false,
      );

      Fluttertoast.cancel();
      return buffer;
    } catch (e) {
      // Handle Error
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return [];
    }
  }

  Future<void> loadMoreIfEmpty() async {
    if (state.visibleList.isEmpty) {
      await loadMore();
    }
  }

  void removeItem(T item) {
    state.visibleList.remove(item);
    final newList = List<T>.from(state.visibleList);
    state = state.copyWith(visibleList: newList);
  }

  void removeItemById(bool Function(T item) filterRemoveFn) {
    state.visibleList.removeWhere(filterRemoveFn);
    final newList = List<T>.from(state.visibleList);
    state = state.copyWith(visibleList: newList);
  }

  void addToFirst(T item) {
    state.visibleList.insert(0, item);
    state = state.copyWith(visibleList: state.visibleList);
  }

  void filterByCondition(bool Function(T item) filterRemoveFn) {
    state = state.copyWith(
      visibleList: state.visibleList.where(filterRemoveFn).toList(),
    );
  }

  bool isExistItem(bool Function(T item) filterRemoveFn) {
    return state.visibleList.any(filterRemoveFn);
  }

  List<T> getAllItem() {
    return state.visibleList;
  }

  void updateItem(bool Function(T item) filterUpdateFn, T newItem) {
    final index = state.visibleList.indexWhere(filterUpdateFn);

    if (index != -1) {
      final newList = List<T>.from(state.visibleList);

      newList[index] = newItem;

      state = state.copyWith(visibleList: newList);
    }
  }

  Future<void> refresh() async {
    //Reset state to initial values
    page = 0;
    state = state.copyWith(
      visibleList: [],
      isLoading: false,
      isCanLoadMoreItem: true,
    );

    //Load the first page again
    await loadMore();
  }
}
