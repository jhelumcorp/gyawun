import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:gyawun_beta/utils/enhanced_image.dart';
import 'package:gyawun_beta/utils/pprint.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../services/download_manager.dart';
import '../../services/media_player.dart';
import '../../themes/colors.dart';
import '../../themes/dark.dart';
import '../../themes/text_styles.dart';
import '../../utils/bottom_modals.dart';
import 'play_button.dart';
import 'queue_list.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late PanelController panelController;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List? colors = [];
  String? image;
  bool canPop = false;

  @override
  void initState() {
    super.initState();
    panelController = PanelController();
  }

  Future<Color?> getColor(String? image) async {
    if (image == null) return Theme.of(context).scaffoldBackgroundColor;
    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(
        image,
        errorListener: (p0) {
          setState(() {
            image = getEnhancedImage(image!, quality: 'medium');
          });
          pprint(p0);
        },
      ),
    );
    if (mounted) {
      return paletteGenerator.dominantColor?.color ??
          paletteGenerator.lightVibrantColor?.color ??
          paletteGenerator.lightMutedColor?.color;
    } else {
      return Colors.transparent;
    }
  }

  MaterialColor primaryWhite = const MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );

  @override
  Widget build(BuildContext context) {
    MediaPlayer mediaPlayer = context.watch<MediaPlayer>();
    int? currentIndex = mediaPlayer.currentIndex;
    MediaItem? currentSong = currentIndex != null &&
            mediaPlayer.player.sequence != null &&
            mediaPlayer.player.sequence!.isNotEmpty
        ? mediaPlayer.player.sequence![currentIndex].tag
        : null;

    if (currentSong?.extras?['thumbnails'] != null &&
        currentSong?.extras?['thumbnails'].isNotEmpty &&
        image !=
            getEnhancedImage(
                currentSong?.extras?['thumbnails']?.first['url'])) {
      setState(() {
        image =
            getEnhancedImage(currentSong?.extras?['thumbnails']?.first['url']);
      });
    }
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (panelController.isAttached && panelController.isPanelOpen) {
          await panelController.close();
          return false;
        }
        return true;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
        ),
        child: FutureBuilder<Color?>(
            future: getColor(image),
            builder: (context, snapshot) {
              return Theme(
                data: darkTheme(primaryWhite),
                child: Container(
                  color: Colors.black,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          snapshot.hasData && snapshot.data != null
                              ? snapshot.data!.withAlpha(200)
                              : Colors.transparent,
                          snapshot.hasData && snapshot.data != null
                              ? snapshot.data!.withAlpha(80)
                              : Colors.transparent
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Scaffold(
                      // appBar: AppBar(),

                      key: _key,
                      backgroundColor: Colors.transparent,
                      endDrawer: MediaQuery.of(context).size.width >
                              MediaQuery.of(context).size.height
                          ? SizedBox(
                              width:
                                  min(400, MediaQuery.of(context).size.width) -
                                      50,
                              child: const QueueList(),
                            )
                          : null,
                      body: SizedBox(
                        width: double.maxFinite,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            EdgeInsets padding = MediaQuery.of(context).padding;
                            double maxWidth = constraints.maxWidth -
                                padding.left -
                                padding.right;
                            double maxHeight = constraints.maxHeight -
                                padding.top -
                                padding.bottom;
                            if (maxWidth > maxHeight) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Artwork(
                                    width: maxWidth / 2.3,
                                    song: currentSong,
                                  ),
                                  NameAndControls(
                                    song: currentSong,
                                    width: maxWidth - (maxWidth / 2.3),
                                    height: maxHeight,
                                    isRow: true,
                                    currentState: _key.currentState,
                                  )
                                ],
                              );
                            }
                            return Stack(
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Artwork(
                                      width:
                                          min(maxWidth, maxHeight / 2.2) - 24,
                                      song: currentSong,
                                    ),
                                    NameAndControls(
                                      song: currentSong,
                                      width: maxWidth,
                                      height: maxHeight -
                                          min(maxWidth, maxHeight / 2.2) -
                                          24,
                                    )
                                  ],
                                ),
                                SlidingUpPanel(
                                  controller: panelController,
                                  color: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  margin: EdgeInsets.zero,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  boxShadow: const [],
                                  minHeight: 50 +
                                      MediaQuery.of(context).padding.bottom,
                                  panel: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    child: Container(
                                      width: constraints.maxWidth,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20)),
                                      ),
                                      // width: width,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          ClipRRect(
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 3, sigmaY: 3),
                                              child: Container(
                                                height: 50 +
                                                    MediaQuery.of(context)
                                                        .padding
                                                        .bottom,
                                                width: double.maxFinite,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor
                                                      .withAlpha(70),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20)),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: 5,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color: greyColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      "Next Up",
                                                      style: textStyle(context,
                                                          bold: true),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Expanded(child: QueueList())
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class Artwork extends StatelessWidget {
  const Artwork({this.song, required this.width, super.key});
  final double width;
  final MediaItem? song;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: width,
        child: song == null
            ? Icon(
                Icons.music_note,
                size: width * 0.5,
              )
            : SafeArea(
                child: LayoutBuilder(builder: (context, constraints) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(30),
                              spreadRadius: 10,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: song?.extras?['offline'] == true &&
                                  !song!.artUri.toString().startsWith('https')
                              ? Image.file(
                                  File.fromUri(song!.artUri!),
                                )
                              : CachedNetworkImage(
                                  width: min(constraints.maxHeight,
                                      constraints.maxWidth),
                                  filterQuality: FilterQuality.high,
                                  imageUrl: getEnhancedImage(
                                      song!.extras!['thumbnails'].first['url']),
                                  errorWidget: (context, url, error) {
                                    return CachedNetworkImage(
                                      imageUrl: getEnhancedImage(
                                        song!
                                            .extras!['thumbnails'].first['url'],
                                        quality: 'medium',
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
      ),
    );
  }
}

class NameAndControls extends StatelessWidget {
  const NameAndControls(
      {this.song,
      required this.height,
      required this.width,
      this.isRow = false,
      this.currentState,
      super.key});
  final double width;
  final double height;
  final MediaItem? song;
  final bool isRow;
  final currentState;

  @override
  Widget build(BuildContext context) {
    MediaPlayer mediaPlayer = context.watch<MediaPlayer>();
    return SizedBox(
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isRow)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        currentState?.openEndDrawer();
                      },
                      icon: const Icon(
                        Icons.queue_music_outlined,
                      ))
                ],
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextScroll(
                  song?.title ?? 'Title',
                  style: bigTextStyle(context, bold: true),
                  mode: TextScrollMode.endless,
                ),
                TextScroll(
                  song?.artist ??
                      song?.album ??
                      song?.extras?['subtitle'] ??
                      '',
                  style: smallTextStyle(context),
                )
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder(
                  valueListenable: mediaPlayer.progressBarState,
                  builder: (context, ProgressBarState value, child) {
                    return ProgressBar(
                      progress: value.current,
                      total: value.total,
                      buffered: value.buffered,
                      barHeight: 3,
                      thumbRadius: 5,
                      onSeek: (value) => mediaPlayer.player.seek(value),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: Hive.box('FAVOURITES').listenable(),
                      builder: (context, value, child) {
                        Map? item = value.get(song!.extras!['videoId']);
                        return IconButton(
                          icon: Icon(item == null
                              ? CupertinoIcons.heart
                              : CupertinoIcons.heart_fill),
                          onPressed: () async {
                            if (item == null) {
                              await Hive.box('FAVOURITES').put(
                                song!.extras!['videoId'],
                                {
                                  ...song!.extras!,
                                  'createdAt':
                                      DateTime.now().millisecondsSinceEpoch
                                },
                              );
                            } else {
                              await value.delete(song!.extras!['videoId']);
                            }
                          },
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        mediaPlayer.player.seekToPrevious();
                      },
                      icon: const Icon(Icons.skip_previous),
                    ),
                    const PlayButton(size: 40),
                    IconButton(
                        onPressed: () {
                          mediaPlayer.player.seekToNext();
                        },
                        icon: const Icon(Icons.skip_next)),
                    ValueListenableBuilder(
                        valueListenable: mediaPlayer.loopMode,
                        builder: (context, value, child) {
                          return IconButton(
                            onPressed: () {
                              mediaPlayer.changeLoopMode();
                            },
                            isSelected: value != LoopMode.off,
                            color: value == LoopMode.off
                                ? null
                                : Theme.of(context).primaryColor,
                            icon: Icon(
                              value == LoopMode.off
                                  ? Icons.repeat_outlined
                                  : value == LoopMode.all
                                      ? Icons.repeat_on_outlined
                                      : Icons.repeat_one_on_outlined,
                            ),
                          );
                        }),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (song != null)
                  ValueListenableBuilder(
                    valueListenable: GetIt.I<DownloadManager>().downloads,
                    builder: (context, value, child) {
                      List<Map> elements = value
                          .where((item) => item['videoId'] == song!.id)
                          .toList();
                      Map? item = elements.isNotEmpty ? elements.first : null;
                      if (item != null) {
                        if (item['status'] == 'PROCESSING' ||
                            item['status'] == 'DOWNLOADING') {
                          return CircularProgressIndicator(
                            value: item['status'] == 'DOWNLOADING'
                                ? item['progress']
                                : null,
                            color: Colors.white,
                            backgroundColor: Colors.white.withAlpha(50),
                          );
                        } else if (item['status'] == 'DOWNLOADED') {
                          return const Icon(Icons.download_done_outlined);
                        }
                      }
                      return IconButton(
                          onPressed: () {
                            GetIt.I<DownloadManager>()
                                .downloadSong(song!.extras!);
                          },
                          icon: const Icon(Icons.download_outlined));
                    },
                  ),
                IconButton(
                    onPressed: () {
                      Modals.showPlayerOptionsModal(
                        context,
                        mediaPlayer.currentSong!.extras!,
                      );
                    },
                    icon: const Icon(Icons.more_vert_outlined))
              ],
            ),
            if (song != null && !isRow)
              SizedBox(height: 55 + MediaQuery.of(context).padding.bottom)
          ],
        ),
      ),
    );
  }
}
