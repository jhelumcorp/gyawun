part of 'album_cubit.dart';

@immutable
sealed class AlbumState {}

final class AlbumInitial extends AlbumState {}
final class AlbumLoading extends AlbumState {}
final class AlbumSuccess extends AlbumState {
  final YTAlbumPage data;
  final bool loadingMore;
  AlbumSuccess(this.data,{this.loadingMore=false});
}
final class AlbumError extends AlbumState {
  final String? message;
  AlbumError([this.message]);
}