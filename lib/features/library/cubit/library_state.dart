part of 'library_cubit.dart';

@immutable
sealed class LibraryState {}

/// Initial loading state
final class LibraryInitial extends LibraryState {}

/// Loaded successfully
final class LibrarySuccess extends LibraryState {
  LibrarySuccess({
    required this.favorites,
    required this.history,
    required this.downloads,
    required this.customPlaylists,
    required this.remotePlaylists,
  });
  final Playlist favorites;
  final Playlist history;
  final Playlist downloads;
  final List<Playlist> customPlaylists;
  final List<Playlist> remotePlaylists;

  LibrarySuccess copyWith({
    Playlist? favorites,
    Playlist? history,
    Playlist? downloads,
    List<Playlist>? customPlaylists,
    List<Playlist>? remotePlaylists,
  }) {
    return LibrarySuccess(
      favorites: favorites ?? this.favorites,
      history: history ?? this.history,
      downloads: downloads ?? this.downloads,
      customPlaylists: customPlaylists ?? this.customPlaylists,
      remotePlaylists: remotePlaylists ?? this.remotePlaylists,
    );
  }
}

/// Error state
final class LibraryError extends LibraryState {
  LibraryError(this.failure);
  final Failure failure;
}
