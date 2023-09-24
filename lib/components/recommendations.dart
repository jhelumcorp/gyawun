import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gyawun/providers/media_manager.dart';
import 'package:gyawun/ui/text_styles.dart';
import 'package:gyawun/utils/option_menu.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';

class Recommendations extends StatelessWidget {
  const Recommendations({
    super.key,
    required this.recommendedSongs,
  });

  final List recommendedSongs;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(S.of(context).recommended,
              style: textStyle(context, bold: true)
                  .copyWith(color: Theme.of(context).colorScheme.primary)),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 60 * 5,
          child: PageView.builder(
            padEnds: false,
            controller: PageController(
                viewportFraction: constraints.maxWidth > 600 ? 0.45 : 0.9),
            itemCount: (recommendedSongs.length / 4).ceil(),
            itemBuilder: (p0, p1) {
              List items = recommendedSongs
                  .getRange(
                      4 * p1,
                      ((4 * p1) + 4) >= recommendedSongs.length
                          ? recommendedSongs.length
                          : (4 * p1) + 4)
                  .toList();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                    children: items
                        .map((item) => ListTile(
                              onTap: () {
                                context.read<MediaManager>().addAndPlay(
                                    recommendedSongs,
                                    initialIndex:
                                        recommendedSongs.indexOf(item));
                              },
                              onLongPress: () =>
                                  showSongOptions(context, Map.from(item)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      item['type'] == 'artist' ? 30 : 8),
                                  child: CachedNetworkImage(
                                    imageUrl: item['image'],
                                    height: 50,
                                    width: item['type'] == 'video' ? 80 : 50,
                                  )),
                              title: Text(
                                item['title'],
                                style: subtitleTextStyle(context, bold: true),
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                item['artist'],
                                style: smallTextStyle(context),
                                maxLines: 1,
                              ),
                            ))
                        .toList()),
              );
            },
          ),
        )
      ]);
    });
  }
}
