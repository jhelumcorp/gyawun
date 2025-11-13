part of 'browse_cubit.dart';

@immutable
sealed class BrowseState {}

final class BrowseInitial extends BrowseState {}

final class BrowseLoading extends BrowseState {}

final class BrowseSuccess extends BrowseState {
  BrowseSuccess(this.data, {this.loadingMore = false});
  final Page data;
  final bool loadingMore;
}

final class BrowseError extends BrowseState {
  BrowseError([this.message]);
  final String? message;
}
