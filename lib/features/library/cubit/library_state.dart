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
  });
  final Playlist favorites;
  final Playlist history;
  final Playlist downloads;
  final List<Playlist> customPlaylists;
}

/// Error state
final class LibraryError extends LibraryState {
  LibraryError(this.message);
  final String message;
}
