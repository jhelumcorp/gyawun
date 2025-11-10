part of 'artist_cubit.dart';

@immutable
sealed class ArtistState {}

final class ArtistInitial extends ArtistState {}

final class ArtistLoading extends ArtistState {}

final class ArtistSuccess extends ArtistState {
  ArtistSuccess(this.data, {this.loadingMore = false});
  final YTArtistPage data;
  final bool loadingMore;
}

final class ArtistError extends ArtistState {
  ArtistError([this.message]);
  final String? message;
}
