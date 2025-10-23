part of 'podcast_cubit.dart';

@immutable
sealed class PodcastState {}

final class PodcastInitial extends PodcastState {}
final class PodcastLoading extends PodcastState {}
final class PodcastSuccess extends PodcastState {
  final YTPodcastPage data;
  final bool loadingMore;
  PodcastSuccess(this.data,{this.loadingMore=false});
}
final class PodcastError extends PodcastState {
  final String? message;
  PodcastError([this.message]);
}