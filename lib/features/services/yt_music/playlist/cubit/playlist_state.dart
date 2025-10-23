part of 'playlist_cubit.dart';

@immutable
sealed class PlaylistState {}

final class PlaylistInitial extends PlaylistState {}
final class PlaylistLoading extends PlaylistState {}
final class PlaylistSuccess extends PlaylistState {
  final YTPlaylistPage data;
  final bool loadingMore;
  PlaylistSuccess(this.data,{this.loadingMore=false});
}
final class PlaylistError extends PlaylistState {
  final String? message;
  PlaylistError([this.message]);
}