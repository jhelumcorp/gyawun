import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ytmusic/models/yt_item.dart';


void onYTSectionItemTap(BuildContext context, YTItem item) {
  final page=item is YTPlaylist ? 'playlist':item is YTAlbum ? 'album':item is YTArtist ?'artist':item is YTPodcast?'podcast':null;
  if(page==null)return;
  context.push('/home/$page/${jsonEncode(item.endpoint)}');

}
