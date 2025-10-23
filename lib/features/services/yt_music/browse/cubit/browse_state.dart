part of 'browse_cubit.dart';

@immutable
sealed class BrowseState {}

final class BrowseInitial extends BrowseState {}
final class BrowseLoading extends BrowseState {}
final class BrowseSuccess extends BrowseState {
  final YTBrowsePage data;
  final bool loadingMore;
  BrowseSuccess(this.data,{this.loadingMore=false});
}
final class BrowseError extends BrowseState {
  final String? message;
  BrowseError([this.message]);
}