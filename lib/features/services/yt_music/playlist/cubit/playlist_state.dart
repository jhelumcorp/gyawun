part of 'playlist_cubit.dart';

@immutable
sealed class PlaylistState {}

final class PlaylistInitial extends PlaylistState {}

final class PlaylistLoading extends PlaylistState {}

final class PlaylistSuccess extends PlaylistState {
  PlaylistSuccess(this.data, {this.loadingMore = false});
  final Page data;
  final bool loadingMore;
}

final class PlaylistError extends PlaylistState {
  PlaylistError([this.message]);
  final String? message;
}
