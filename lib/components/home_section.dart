import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyavun/api/image_resolution_modifier.dart';
import 'package:gyavun/providers/media_manager.dart';
import 'package:gyavun/ui/colors.dart';
import 'package:gyavun/ui/text_styles.dart';
import 'package:gyavun/utils/option_menu.dart';
import 'package:gyavun/utils/snackbar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class HomeSection extends StatefulWidget {
  const HomeSection({
    super.key,
    required this.item,
  });
  final Map item;

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  List sectionSongs = [];
  late List songs;

  @override
  void initState() {
    super.initState();
    songs = widget.item['songs'];
    sectionSongs = songs.where((element) => element['type'] == 'song').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(widget.item['title'],
              style: textStyle(context, bold: true)
                  .copyWith(color: Theme.of(context).colorScheme.primary)),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 191,
          child: ListView.separated(
            shrinkWrap: true,
            cacheExtent: null,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: songs.length,
            itemBuilder: (context, index) {
              Map song = songs[index];

              return GestureDetector(
                onTap: () {
                  if (song['type'] == 'song') {
                    context.read<MediaManager>().addAndPlay(sectionSongs,
                        initialIndex: sectionSongs.indexOf(song));
                  } else if (song['type'] == 'radio_station') {
                    ShowSnackBar().showSnackBar(
                      context,
                      'Connecting Radio...',
                      duration: const Duration(seconds: 3),
                    );
                    context.read<MediaManager>().playRadio(song);
                  } else {
                    context.go('/list', extra: song);
                  }
                },
                onLongPress: () {
                  if (song['type'] == 'song') {
                    showSongOptions(context, Map.from(song));
                  }
                },
                child: SizedBox(
                  width: 150,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            song['type'] == 'radio_station' ? 75 : 10),
                        child: CachedNetworkImage(
                          imageUrl: getImageUrl(song['image']),
                          height: 150,
                          width: 150,
                          fit: BoxFit.fill,
                          errorWidget: (context, url, error) {
                            return Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: darkGreyColor.withAlpha(50),
                                borderRadius: BorderRadius.circular(
                                    song['type'] == 'radio_station' ? 75 : 10),
                              ),
                              child: Icon(
                                song['type'] == 'song'
                                    ? Iconsax.music
                                    : song['type'] == 'radio_station'
                                        ? Iconsax.radio
                                        : Iconsax.music_playlist,
                                size: 70,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 150,
                        child: Center(
                          child: Text(
                            song['title'],
                            style: customTextStyle(context,
                                    bold: false, fontSize: 14)
                                .copyWith(height: 1.3),
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 8),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
