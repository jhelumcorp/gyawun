import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gyavun/api/image_resolution_modifier.dart';
import 'package:gyavun/providers/media_manager.dart';
import 'package:gyavun/ui/colors.dart';
import 'package:gyavun/ui/text_styles.dart';
import 'package:gyavun/utils/downlod.dart';
import 'package:gyavun/utils/option_menu.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class RecentlyPlayed extends StatelessWidget {
  const RecentlyPlayed({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('songHistory').listenable(),
      builder: (context, value, child) {
        List songsItems = value.values.toList();
        songsItems.sort((a, b) => b['time_added'].compareTo(a['time_added']));

        return songsItems.isEmpty
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text("Recently Played",
                        style: textStyle(context, bold: true).copyWith(
                            color: Theme.of(context).colorScheme.primary)),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 193,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: songsItems.length,
                      itemBuilder: (context, index) {
                        Map mapSong = songsItems[index];
                        return FutureBuilder(
                            future: processSong(songsItems[index]),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                MediaItem song = snapshot.data!;
                                return GestureDetector(
                                  onTap: () {
                                    context.read<MediaManager>().addAndPlay(
                                        songsItems,
                                        initialIndex: index);
                                  },
                                  onLongPress: () {
                                    showSongOptions(context, Map.from(mapSong));
                                  },
                                  child: SizedBox(
                                    width: 150,
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: song.extras!['offline'] == true
                                              ? Image.file(
                                                  File.fromUri(song.artUri!),
                                                  height: 150,
                                                  width: 150,
                                                  fit: BoxFit.fill,
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: getImageUrl(
                                                      song.artUri.toString()),
                                                  height: 150,
                                                  width: 150,
                                                  fit: BoxFit.fill,
                                                  errorWidget:
                                                      (context, url, error) {
                                                    return Container(
                                                      height: 150,
                                                      width: 150,
                                                      decoration: BoxDecoration(
                                                        color: darkGreyColor
                                                            .withAlpha(50),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: const Icon(
                                                          Iconsax.music,
                                                          size: 70),
                                                    );
                                                  },
                                                ),
                                        ),
                                        const SizedBox(height: 5),
                                        SizedBox(
                                          width: 150,
                                          child: Center(
                                            child: Text(
                                              song.title,
                                              style: smallTextStyle(context,
                                                  bold: true),
                                              overflow: TextOverflow.clip,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            });
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              );
      },
    );
  }
}
