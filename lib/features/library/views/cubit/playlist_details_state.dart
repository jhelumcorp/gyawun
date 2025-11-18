part of 'playlist_details_cubit.dart';

@immutable
sealed class PlaylistDetailsState {}

final class PlaylistDetailsInitial extends PlaylistDetailsState {}

final class PlaylistDetailsLoading extends PlaylistDetailsState {}

final class PlaylistDetailsSuccess extends PlaylistDetailsState {
  PlaylistDetailsSuccess(this.songs);
  final List<PlayableItem> songs;
}

final class PlaylistDetailsError extends PlaylistDetailsState {
  PlaylistDetailsError([this.message]);
  final String? message;
}
