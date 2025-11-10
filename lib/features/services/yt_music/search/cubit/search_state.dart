part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchSuccess extends SearchState {
  SearchSuccess(this.data, {this.loadingMore = false});
  final YTSearchPage data;
  final bool loadingMore;
}

final class SearchError extends SearchState {
  SearchError([this.message]);
  final String? message;
}
