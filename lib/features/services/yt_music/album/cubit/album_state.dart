part of 'album_cubit.dart';

@immutable
sealed class AlbumState {}

final class AlbumInitial extends AlbumState {}

final class AlbumLoading extends AlbumState {}

final class AlbumSuccess extends AlbumState {
  AlbumSuccess(this.data, {this.loadingMore = false});
  final dp.Page data;
  final bool loadingMore;
}

final class AlbumError extends AlbumState {
  AlbumError([this.message]);
  final String? message;
}
