import 'dart:convert';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/utils/snackbar.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/yt_music_base.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.section});
  final Section section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              section.title ?? '',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          if (section.trailing != null)
            TextButton.icon(
              iconAlignment: IconAlignment.end,
              onPressed: () async {
                if (section.trailing!.isPlayable == true) {
                  BottomSnackbar.showMessage(context, "Play starting");
                  final items = await sl<YTMusic>().getNextSongs(
                    body: section.trailing!.endpoint!.cast(),
                  );
                  final songs = items.whereType<PlayableItem>().toList();
                  final first = songs.removeAt(0);
                  await sl<MediaPlayer>().playSong(first);
                  await sl<MediaPlayer>().addSongs(songs);
                  return;
                }
                if (section.provider == DataProvider.ytmusic) {
                  context.push('/ytmusic/browse/${jsonEncode(section.trailing!.endpoint)}');
                }
              },
              icon: Icon(
                section.trailing!.isPlayable
                    ? FluentIcons.play_24_filled
                    : FluentIcons.chevron_right_24_filled,
              ),
              label: Text(section.trailing!.text),
            ),
        ],
      ),
    );
  }
}
