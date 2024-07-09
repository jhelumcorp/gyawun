import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gyawun_beta/utils/extensions.dart';
import 'package:gyawun_beta/utils/adaptive_widgets/adaptive_widgets.dart';

import '../../../../generated/l10n.dart';
import '../../../../services/yt_account.dart';
import '../../../../themes/colors.dart';
import '../browse_screen/browse_screen.dart';
import 'youtube_history.dart';

class YTMScreen extends StatelessWidget {
  const YTMScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(
        title: Text('YTMusic'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ValueListenableBuilder(
        valueListenable: GetIt.I<YTAccount>().isLogged,
        builder: (context, value, child) {
          if (value) {
            return FutureBuilder(
              future: GetIt.I<YTAccount>().fetchLibraryPlaylists(),
              builder: (context, data) {
                if (data.hasData && data.data != null) {
                  List playlists = data.data!;
                  return Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: AdaptiveListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  AdaptivePageRoute.create(
                                      (context) => const YoutubeHistory()),
                                );
                              },
                              title: Text(
                                S.of(context).history,
                                maxLines: 2,
                              ),
                              leading: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: greyColor,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Icon(
                                  Icons.history,
                                  color: context.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              trailing: Icon(AdaptiveIcons.chevron_right),
                            ),
                          ),
                          ...playlists.map((playlist) {
                            return AdaptiveListTile(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  AdaptivePageRoute.create(
                                    (context) => BrowseScreen(
                                        endpoint: playlist['endpoint']
                                            .cast<String, dynamic>()),
                                  ),
                                );
                              },
                              title: Text(
                                playlist['title'],
                                maxLines: 2,
                              ),
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      playlist['type'] == 'ARTIST' ? 50 : 3),
                                  child: CachedNetworkImage(
                                    imageUrl: playlist['thumbnails']
                                        .first['url']
                                        .replaceAll('w540-h225', 'w60-h60'),
                                    height: 50,
                                    width: 50,
                                  )),
                              subtitle: Text(
                                playlist['subtitle'],
                                maxLines: 1,
                              ),
                              trailing: Icon(AdaptiveIcons.chevron_right),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                }
                return const Center(child: AdaptiveProgressRing());
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
