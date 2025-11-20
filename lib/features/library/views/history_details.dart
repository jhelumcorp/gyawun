import 'dart:ui';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/utils/modals.dart';
import 'package:gyawun_music/features/library/views/cubit/history_details_cubit.dart';
import 'package:gyawun_music/features/library/widgets/library_song_tile.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';

class HistoryDetailsScreen extends StatelessWidget {
  const HistoryDetailsScreen({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistoryDetailsCubit(sl())..fetchSongs(),
      child: HistoryDetailsView(name: name),
    );
  }
}

class HistoryDetailsView extends StatelessWidget {
  const HistoryDetailsView({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HistoryDetailsCubit, HistoryDetailsState>(
        builder: (context, state) {
          if (state is HistoryDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HistoryDetailsError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is HistoryDetailsSuccess) {
            final songs = state.songs;
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,

                    expandedHeight: 120,
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        const maxHeight = 120;
                        final t =
                            ((constraints.maxHeight - kToolbarHeight) /
                                    (maxHeight - kToolbarHeight))
                                .clamp(0.0, 1.0);

                        final paddingLeft = lerpDouble(16, 72, 1 - t)!;

                        return FlexibleSpaceBar(
                          titlePadding: EdgeInsets.only(left: paddingLeft, bottom: 6, right: 16),
                          expandedTitleScale: 1.2,
                          title: Row(
                            children: [
                              Text(
                                name,
                                style: Theme.of(context).appBarTheme.titleTextStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              IconButton.filled(
                                padding: EdgeInsets.zero,
                                onPressed: () async {
                                  await sl<MediaPlayer>().playSongs(state.songs);
                                },
                                icon: const Icon(Icons.play_arrow_rounded),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ];
              },
              body: (state.songs.isEmpty)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FluentIcons.heart_broken_24_filled,
                            size: 64,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Items',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            "Swipe left on an item to remove it from the playlist",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: songs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                key: ValueKey('${songs[index].provider.name}_${songs[index].id}'),
                                padding: const EdgeInsets.symmetric(vertical: 1),
                                child: LibrarySongTile(
                                  item: songs[index],
                                  isFirst: index == 0,
                                  isLast: index == songs.length - 1,
                                  trailing: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          await Modals.showItemBottomSheet(context, songs[index]);
                                        },
                                        icon: const Icon(Icons.more_vert_rounded),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
