import 'dart:convert';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/utils/modals.dart';
import 'package:gyawun_music/features/library/cubit/library_cubit.dart';
import 'package:gyawun_music/features/library/widgets/library_tile.dart';
import 'package:gyawun_music/features/settings/widgets/group_title.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => LibraryCubit(sl()), child: const Libraryview());
  }
}

class Libraryview extends StatelessWidget {
  const Libraryview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryCubit, LibraryState>(
      builder: (context, state) {
        if (state is LibraryInitial) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state is LibraryError) {
          return Scaffold(body: Center(child: Text("Error: ${state.message}")));
        }

        if (state is LibrarySuccess) {
          return _LibrarySuccessView(state: state);
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _LibrarySuccessView extends StatelessWidget {
  const _LibrarySuccessView({required this.state});
  final LibrarySuccess state;

  @override
  Widget build(BuildContext context) {
    final favorites = state.favorites;
    final history = state.history;
    final downloads = state.downloads;
    final playlists = state.customPlaylists;
    final remotePlaylists = state.remotePlaylists;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 100,

              flexibleSpace: FlexibleSpaceBar(
                title: Text("Library", style: Theme.of(context).appBarTheme.titleTextStyle),
                // expandedTitleScale: 1.5,
                titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
              ),
            ),
          ];
        },
        body: CustomScrollView(
          slivers: [
            const SliverGroupTitle(title: "Default"),

            // favourites
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: LibraryTile(
                  leadingIcon: const Icon(FluentIcons.heart_24_filled, size: 30),
                  subtitle: favorites.description,
                  title: "Favourites",
                  isFirst: true,
                  onTap: () {
                    context.push('/library/playlists/${favorites.name}/${favorites.id}');
                  },
                ),
              ),
            ),

            // history
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: LibraryTile(
                  leadingIcon: const Icon(Icons.queue_music, size: 30),
                  title: "History",
                  subtitle: history.description,
                ),
              ),
            ),

            // downloads
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: LibraryTile(
                  leadingIcon: const Icon(FluentIcons.cloud_arrow_down_24_filled, size: 30),
                  title: "Downloads",
                  subtitle: downloads.description,
                  isLast: true,
                ),
              ),
            ),

            if (playlists.isNotEmpty) const SliverGroupTitle(title: "Custom"),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final itemIndex = index ~/ 2;

                  if (index.isEven) {
                    final playlist = playlists[itemIndex];

                    return LibraryTile(
                      title: playlist.name,
                      isFirst: itemIndex == 0,
                      isLast: itemIndex == playlists.length - 1,
                      onTap: () {
                        context.push('/library/playlists/${playlist.name}/${playlist.id}');
                      },
                    );
                  }

                  return const SizedBox(height: 1);
                }, childCount: playlists.length * 2 - 1),
              ),
            ),
            if (remotePlaylists.isNotEmpty) const SliverGroupTitle(title: "Remote"),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.separated(
                itemCount: remotePlaylists.length,
                itemBuilder: (context, index) {
                  final playlist = remotePlaylists[index];

                  return LibraryTile(
                    title: playlist.name,
                    isFirst: index == 0,
                    isLast: index == remotePlaylists.length - 1,
                    onTap: () {
                      if (playlist.extraJson != null) {
                        context.push(
                          '/ytmusic/playlist/${jsonEncode(playlist.extraJson!.endpoint)}',
                        );
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 1),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: StreamBuilder(
        stream: sl<MediaPlayer>().hasQueueItemsStream,
        builder: (context, asyncSnapshot) {
          return Padding(
            padding: EdgeInsets.only(bottom: asyncSnapshot.data == true ? 80 : 0),
            child: FloatingActionButton(
              onPressed: () async {
                final name = await Modals.showCreatePlaylistModal(context);
                if (context.mounted && name != null) {
                  final id = '$name-${DateTime.now().millisecondsSinceEpoch}';
                  await context.read<LibraryCubit>().createPlaylist(id, name);
                }
              },
              child: const Icon(FluentIcons.add_24_filled),
            ),
          );
        },
      ),
    );
  }
}
