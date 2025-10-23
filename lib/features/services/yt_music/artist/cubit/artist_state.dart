part of 'artist_cubit.dart';

@immutable
sealed class ArtistState {}

final class ArtistInitial extends ArtistState {}
final class ArtistLoading extends ArtistState {}
final class ArtistSuccess extends ArtistState {
  final YTArtistPage data;
  final bool loadingMore;
  ArtistSuccess(this.data,{this.loadingMore=false});
}
final class ArtistError extends ArtistState {
  final String? message;
  ArtistError([this.message]);
}