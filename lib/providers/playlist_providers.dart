import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gyawun_music/services/playlist_service/playlist_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:playlist_manager/playlist_manager.dart';

part 'playlist_providers.g.dart';

@riverpod
PlaylistService playlistService(Ref ref) {
  final db = PlaylistDatabase();
  final repo = PlaylistRepository(db);

  return PlaylistService(repo);
}

// // Provide DAO
// @riverpod
// PlaylistDao playlistDao(Ref ref) {
//   final db = ref.watch(appDatabaseProvider);
//   return PlaylistDao(db);
// }

// // Create user Playlist

// @riverpod
// class UserPlaylist extends _$UserPlaylist {
//   Future<int> create(String title, {String? image}) async {
//     final dao = ref.read(playlistDaoProvider);
//     return dao.createUserPlaylist(title: title, image: image);
//   }

//   @override
//   FutureOr<int> build() {
//     // nothing to initialize
//     return 0;
//   }
// }

// //  Create remote playlist

// @riverpod
// class CreateRemotePlaylist extends _$CreateRemotePlaylist {
//   Future<void> toggle({
//     required String title,
//     String? remoteId,
//     Map<String, dynamic>? endpoint,
//     String? image,
//     required MusicProvider provider,
//     int itemCount = 0,
//   }) async {
//     final dao = ref.watch(playlistDaoProvider);
//     return dao.toggleRemotePlaylist(
//       title: title,
//       remoteId: remoteId,
//       endpoint: endpoint,
//       image: image,
//       provider: provider,
//       itemCount: itemCount,
//     );
//   }

//   @override
//   FutureOr<int> build() {
//     return 0;
//   }
// }

// // Watch all playlists
// @riverpod
// Stream<List<Playlist>> playlists(Ref ref) {
//   final dao = ref.watch(playlistDaoProvider);
//   return dao.watchAllPlaylists();
// }

// class WatchPlaylistParam {
//   MusicProvider provider;
//   String? remoteId;
//   Map<String, dynamic>? endpoint;
//   WatchPlaylistParam(this.provider, this.remoteId, this.endpoint);
// }

// final watchPlaylistExistsProvider =
//     StreamProvider.family<Playlist?, WatchPlaylistParam>((ref, params) {
//       final dao = ref.watch(playlistDaoProvider);
//       return dao.watchRemotePlaylist(
//         provider: params.provider,
//         remoteId: params.remoteId,
//         endpoint: params.endpoint,
//       );
//     });

// // Watch a single playlist
// @riverpod
// Stream<Playlist?> playlist(Ref ref, int id) {
//   final dao = ref.watch(playlistDaoProvider);
//   return dao.watchPlaylist(id);
// }
