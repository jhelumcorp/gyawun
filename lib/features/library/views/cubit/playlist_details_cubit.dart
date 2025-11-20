import 'package:bloc/bloc.dart';
import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:library_manager/library_manager.dart';
import 'package:meta/meta.dart';

part 'playlist_details_state.dart';

class PlaylistDetailsCubit extends Cubit<PlaylistDetailsState> {
  PlaylistDetailsCubit(this._lb, this.id) : super(PlaylistDetailsInitial());
  final LibraryManager _lb;
  final String id;

  void fetchSongs() {
    final songs = _lb.getPlaylistItems(id);

    emit(PlaylistDetailsSuccess(songs));
  }

  Future<void> reorder(PlayableItem item, int oldIndex, int newIndex) async {
    if (state is PlaylistDetailsSuccess) {
      await _lb.moveSongToPosition(
        playlistId: id,
        itemId: item.id,
        provider: item.provider,
        newIndex: newIndex,
      );
      fetchSongs();
    }
  }

  Future<void> remove(String itemId, DataProvider provider) async {
    if (state is PlaylistDetailsSuccess) {
      await _lb.removeSongFromPlaylist(playlistId: id, itemId: itemId, provider: provider);
      fetchSongs();
    }
  }
}
