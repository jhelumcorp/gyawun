import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:gyawun_music/core/errors/failure.dart';
import 'package:library_manager/library_manager.dart';

part 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit(this.libraryManager) : super(LibraryInitial()) {
    loadLibrary();
  }
  final LibraryManager libraryManager;

  Future<void> loadLibrary() async {
    try {
      final all = libraryManager.getAllPlaylists();

      final favorites = all.firstWhere((e) => e.type == PlaylistType.favorites);
      final history = all.firstWhere((e) => e.type == PlaylistType.history);
      final downloads = all.firstWhere((e) => e.type == PlaylistType.downloads);

      final custom = all
          .where((e) => e.type == PlaylistType.custom && e.origin == PlaylistOrigin.local)
          .toList();
      final remote = all.where((e) => e.origin == PlaylistOrigin.remote).toList();

      emit(
        LibrarySuccess(
          favorites: favorites,
          history: history,
          downloads: downloads,
          customPlaylists: custom,
          remotePlaylists: remote,
        ),
      );
    } catch (e) {
      emit(LibraryError(GeneralFailure(e.toString())));
    }
  }

  Future<void> createPlaylist(String id, String name) async {
    try {
      await libraryManager.createPlaylist(id: id, name: name);
      await loadLibrary(); // reload
    } catch (e) {
      emit(LibraryError(GeneralFailure(e.toString())));
    }
  }

  Future<void> deletePlaylist(Playlist playlist) async {
    final previousState = state;
    if (previousState is LibrarySuccess) {
      final updatedCustom = List<Playlist>.from(previousState.customPlaylists)..remove(playlist);
      emit(previousState.copyWith(customPlaylists: updatedCustom));
    }

    try {
      await libraryManager.deletePlaylist(playlist.id);
    } catch (e) {
      if (previousState is LibrarySuccess) {
        emit(previousState);
      }
      emit(LibraryError(GeneralFailure(e.toString())));
    }
  }
}
