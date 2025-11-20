import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/utils/modals.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:library_manager/library_manager.dart';

class AddToPlaylist extends StatefulWidget {
  const AddToPlaylist({super.key, this.iconSize = 24, this.padding = const EdgeInsets.all(10)});
  final double iconSize;
  final EdgeInsetsGeometry? padding;

  @override
  State<AddToPlaylist> createState() => _AddToPlaylistState();
}

class _AddToPlaylistState extends State<AddToPlaylist> {
  bool? isInAllPlaylists;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return StreamBuilder(
      stream: sl<MediaPlayer>().currentItemStream,
      builder: (context, asyncSnapshot) {
        if (!asyncSnapshot.hasData || asyncSnapshot.data == null) {
          return const SizedBox.shrink();
        }
        final item = asyncSnapshot.data!;
        isInAllPlaylists ??= sl<LibraryManager>()
            .getPlaylistsExcludingSong(
              item.id,
              PlaylistType.custom,
              item.provider,
              origin: PlaylistOrigin.local,
            )
            .isEmpty;
        if (isInAllPlaylists!) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: IconButton.filled(
            onPressed: () async {
              await Modals.showAddToPlaylist(context, item);
              isInAllPlaylists = sl<LibraryManager>()
                  .getPlaylistsExcludingSong(
                    item.id,
                    PlaylistType.custom,
                    item.provider,
                    origin: PlaylistOrigin.local,
                  )
                  .isEmpty;
              setState(() {});
            },
            padding: widget.padding,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(cs.secondaryContainer),
              foregroundColor: WidgetStatePropertyAll(cs.onSecondaryContainer),
            ),
            icon: Icon(
              FluentIcons.add_24_filled,
              size: widget.iconSize,
              color: cs.onSecondaryContainer,
            ),
          ),
        );
      },
    );
  }
}
