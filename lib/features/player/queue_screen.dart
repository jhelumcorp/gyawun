import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/widgets/custom_tile.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:just_audio/just_audio.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _didInitialScroll = false;

  void _scrollToCurrent(int index) {
    if (!_didInitialScroll && index >= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scrollController.hasClients) return;

        _scrollController.animateTo(
          index * 76, // fixed height per requirement
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      });
      _didInitialScroll = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: StreamBuilder<SequenceState>(
        stream: sl<MediaPlayer>().queueStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;

          if (state == null || state.sequence.isEmpty) {
            return const Center(child: Text("Queue is empty"));
          }

          final queue = state.sequence;
          final currentIndex = state.currentIndex;

          _scrollToCurrent(currentIndex ?? 0);

          return ReorderableListView.builder(
            buildDefaultDragHandles: false,
            scrollController: _scrollController,
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 24),
            itemCount: queue.length,
            itemBuilder: (context, index) {
              final item = queue[index].tag as MediaItem;
              final isPlaying = index == currentIndex;
              final thumbnails = item.extras?['thumbnails'] as List?;

              return Dismissible(
                key: ValueKey(item.id),
                resizeDuration: const Duration(milliseconds: 200),

                direction: DismissDirection.endToStart, // swipe left to delete
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: theme.colorScheme.errorContainer,
                  child: Icon(
                    Icons.delete_rounded,
                    color: theme.colorScheme.onErrorContainer,
                    size: 24,
                  ),
                ),
                onDismissed: (_) => sl<MediaPlayer>().removeAt(index),

                child: SizedBox(
                  height: 75,
                  child: CustomTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: thumbnails?.firstOrNull?['url'] != null
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(
                                  thumbnails!.first!['url'],
                                  maxHeight: 48,
                                  maxWidth: 48,
                                ),
                                fit: BoxFit.fitWidth,
                              )
                            : null,
                        color: Colors.black.withValues(alpha: isPlaying ? 0.35 : 0.20),
                      ),
                      child: isPlaying
                          ? const Icon(
                              FluentIcons.speaker_2_24_filled,
                              size: 30,
                              color: Colors.white,
                            )
                          : null,
                    ),

                    isFirst: index == 0,
                    isLast: index == queue.length - 1,
                    title: item.title,
                    subtitle: item.artist ?? item.album ?? '',
                    trailing: ReorderableDragStartListener(
                      index: index,
                      child: Icon(
                        FluentIcons.re_order_24_filled,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 30,
                      ),
                    ),
                    onTap: () => sl<MediaPlayer>().skipToIndex(index),
                  ),
                ),
              );
            },
            onReorder: (oldIndex, newIndex) {
              // Fix reordering index shift rule of ReorderableListView
              if (newIndex > oldIndex) newIndex -= 1;

              // Call your queue reorder method
              sl<MediaPlayer>().moveItem(oldIndex, newIndex);
            },
          );
        },
      ),
    );
  }
}
