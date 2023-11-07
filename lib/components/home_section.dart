import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyawun/api/image_resolution_modifier.dart';
import 'package:gyawun/providers/media_manager.dart';
import 'package:gyawun/ui/colors.dart';
import 'package:gyawun/ui/text_styles.dart';
import 'package:gyawun/utils/option_menu.dart';
import 'package:gyawun/utils/snackbar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class HomeSection extends StatefulWidget {
  const HomeSection({
    super.key,
    required this.sectionIitem,
  });
  final Map sectionIitem;

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  List sectionitems = [];
  late List items;

  @override
  void initState() {
    super.initState();
    items = widget.sectionIitem['items'];
    sectionitems = items
        .where((element) =>
            element['type'] == 'song' || element['type'] == 'video')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(widget.sectionIitem['title'],
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
            itemCount: items.length,
            itemBuilder: (context, index) {
              Map song = items[index];

              return InkWell(
                focusColor: Colors.white,
                onTap: () {
                  if (song['type'] == 'song' || song['type'] == 'video') {
                    context.read<MediaManager>().addAndPlay(sectionitems,
                        initialIndex: sectionitems.indexOf(song));
                  } else if (song['type'] == 'radio_station') {
                    ShowSnackBar.showSnackBar(
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
                onSecondaryTapDown: (details) {
                  if (song['type'] == 'song') {
                    showSongOptions(context, Map.from(song));
                  }
                },
                child: SizedBox(
                  width: song['type'] == 'chart' || song['type'] == 'video'
                      ? 250
                      : 150,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            song['type'] == 'radio_station' ? 75 : 10),
                        child: CachedNetworkImage(
                          imageUrl: getImageUrl(song['image']),
                          height: 150,
                          width:
                              song['type'] == 'chart' || song['type'] == 'video'
                                  ? 250
                                  : 150,
                          fit: BoxFit.fill,
                          errorWidget: (context, url, error) {
                            return Container(
                              height: 150,
                              width: song['type'] == 'chart' ||
                                      song['type'] == 'video'
                                  ? 250
                                  : 150,
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
                        width:
                            song['type'] == 'chart' || song['type'] == 'video'
                                ? 250
                                : 150,
                        child: Center(
                          child: AutoSizeText(
                            song['title'],
                            style: customTextStyle(context,
                                    bold: false, fontSize: 14)
                                .copyWith(height: 1.2),
                            minFontSize: 10,
                            maxFontSize: 16,
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
