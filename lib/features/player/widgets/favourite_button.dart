import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:library_manager/library_manager.dart';

class FavouriteButton extends StatefulWidget {
  const FavouriteButton({super.key, this.iconSize = 24, this.padding = const EdgeInsets.all(10)});

  final double iconSize;
  final EdgeInsetsGeometry? padding;

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  bool? isFavorite;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: StreamBuilder<PlayableItem?>(
        stream: sl<MediaPlayer>().currentItemStream,
        builder: (context, asyncSnapshot) {
          if (!asyncSnapshot.hasData || asyncSnapshot.data == null) {
            return const SizedBox.shrink();
          }
          final item = asyncSnapshot.data!;
          isFavorite ??= sl<LibraryManager>().isSongInPlaylist(
            playlistId: "favorites",
            itemId: item.id,
            provider: item.provider,
          );
          return IconButton.filled(
            onPressed: () async {
              if (isFavorite == null) return;
              if (isFavorite!) {
                await sl<LibraryManager>().removeSongFromPlaylist(
                  playlistId: "favorites",
                  itemId: item.id,
                  provider: item.provider,
                );
                isFavorite = false;
              } else {
                await sl<LibraryManager>().addSongToPlaylist(playlistId: "favorites", item: item);
                isFavorite = true;
              }
              setState(() {});
            },
            padding: widget.padding,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(cs.secondaryContainer),
              foregroundColor: WidgetStatePropertyAll(cs.onSecondaryContainer),
            ),
            isSelected: isFavorite ?? false,
            icon: Icon(
              FluentIcons.heart_24_regular,
              size: widget.iconSize,
              color: cs.onSecondaryContainer,
            ),
            selectedIcon: Icon(
              FluentIcons.heart_24_filled,
              size: widget.iconSize,
              color: cs.onSecondaryContainer,
            ),
          );
        },
      ),
    );
  }
}
