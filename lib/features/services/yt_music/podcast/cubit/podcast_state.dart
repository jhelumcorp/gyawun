part of 'podcast_cubit.dart';

@immutable
sealed class PodcastState {}

final class PodcastInitial extends PodcastState {}

final class PodcastLoading extends PodcastState {}

final class PodcastSuccess extends PodcastState {
  PodcastSuccess(this.data, {this.loadingMore = false});
  final YTPodcastPage data;
  final bool loadingMore;
}

final class PodcastError extends PodcastState {
  PodcastError([this.message]);
  final String? message;
}
