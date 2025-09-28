import 'package:drift/drift.dart';
import 'package:playlist_manager/playlist_manager.dart';

class PlaylistService {
  final PlaylistRepository repo;

  PlaylistService(this.repo);

  // Create a local playlist
  Future<int> createLocal(String title) async {
    return await repo.createLocalPlaylist(title);
  }

  // Create a remote playlist
  Future<int> createRemote(
    String title,
    MusicProvider source,
    Map<String, dynamic> endpoint,
  ) async {
    return await repo.createRemotePlaylist(
      title: title,
      source: source,
      endpoint: endpoint,
    );
  }

  // Add song to local playlist
  Future<int> addSong(
    int playlistId,
    String title,
    MusicProvider source, {
    int? durationMs,
    int? position,
  }) async {
    final songId = await repo.db
        .into(repo.db.songs)
        .insert(
          SongsCompanion.insert(
            title: title,
            source: source,
            durationMs: Value(durationMs ?? 0),
          ),
        );

    return await repo.addSongToLocalPlaylist(
      playlistId: playlistId,
      songId: songId,
      position: position,
    );
  }

  // Get songs of a playlist
  Future<List<PlaylistEntry>> getSongs(int playlistId) async {
    return await repo.getSongsOfLocalPlaylist(playlistId);
  }

  // Reorder songs in a playlist
  Future<void> reorderSongs(int playlistId, List<int> newOrder) async {
    await repo.reorderPlaylistSongs(playlistId: playlistId, newOrder: newOrder);
  }

  // Watch all playlists
  Stream<List<Playlist>> watchAll() {
    return repo.watchAllPlaylists();
  }

  // Get playlist by ID
  Future<Playlist?> getPlaylist(int id) async {
    return await repo.getPlaylistById(id);
  }
}
