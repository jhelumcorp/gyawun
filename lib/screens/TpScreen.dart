import 'dart:developer';
import 'dart:ui';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class TpSrceen extends StatefulWidget {
  const TpSrceen({required this.playListId, super.key});
  final Map playListId;
  @override
  State<TpSrceen> createState() => _TpSrceenState();
}

class _TpSrceenState extends State<TpSrceen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log(widget.playListId.toString());
    // YoutubeExplode youtubeExplode = YoutubeExplode();
    // youtubeExplode.playlists
    //     .get(widget.playListId)
    //     .then((value) => log(value.toString()))
    //     .catchError((err) => log(err.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
