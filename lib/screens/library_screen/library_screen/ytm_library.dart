import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gyawun_beta/utils/extensions.dart';

import '../../../generated/l10n.dart';
import '../../../services/yt_account.dart';
import '../../../themes/colors.dart';
import '../../browse_screen/browse_screen.dart';
import '../youtube_history.dart';

class YTMLibraryScreen extends StatelessWidget {
  const YTMLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: GetIt.I<YTAccount>().isLogged,
        builder: (context, value, child) {
          if (value) {
            return FutureBuilder(
              future: GetIt.I<YTAccount>().fetchLibraryPlaylists(),
              builder: (context, data) {
                if (data.hasData && data.data != null) {
                  List playlists = data.data!;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        const YoutubeHistory(),
                                  ));
                            },
                            child: ListTile(
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
                              trailing:
                                  const Icon(CupertinoIcons.chevron_right),
                            ),
                          ),
                        ),
                        ...playlists.map((playlist) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => BrowseScreen(
                                          endpoint: playlist['endpoint']
                                              .cast<String, dynamic>()),
                                    ));
                              },
                              child: ListTile(
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
                                trailing:
                                    const Icon(CupertinoIcons.chevron_right),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
