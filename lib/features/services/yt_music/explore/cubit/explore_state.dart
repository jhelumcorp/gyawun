part of 'explore_cubit.dart';

@immutable
sealed class ExploreState {}

final class ExploreInitial extends ExploreState {}

final class ExploreLoading extends ExploreState {}

final class ExploreSuccess extends ExploreState {
  ExploreSuccess(this.data, {this.loadingMore = false});
  final List<Section> data;
  final bool loadingMore;
}

final class ExploreError extends ExploreState {
  ExploreError([this.message]);
  final String? message;
}
