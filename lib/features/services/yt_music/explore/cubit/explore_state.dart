part of 'explore_cubit.dart';

@immutable
sealed class ExploreState {}

final class ExploreInitial extends ExploreState {}
final class ExploreLoading extends ExploreState {}
final class ExploreSuccess extends ExploreState {
  final List<YTSection> data;
  final bool loadingMore;
  ExploreSuccess(this.data,{this.loadingMore=false});
}
final class ExploreError extends ExploreState {
  final String? message;
  ExploreError([this.message]);
}