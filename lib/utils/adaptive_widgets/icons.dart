// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract final class AdaptiveIcons {
  static IconData home =
      (Platform.isWindows || Platform.isLinux) ? FluentIcons.home : Icons.home;
  static IconData home_filled = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.home
      : Icons.home_filled;
  static IconData back = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.back
      : Icons.arrow_back;
  static IconData chevron_left = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.chevron_left
      : Icons.chevron_left;
  static IconData chevron_right = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.chevron_right
      : Icons.chevron_right;
  static IconData chevron_down = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.chevron_down
      : CupertinoIcons.chevron_down;
  static IconData search = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.search
      : Icons.search;
  static IconData download = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.download
      : Icons.download;
  static IconData create = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.edit_list_pencil
      : Icons.edit;
  static IconData add =
      (Platform.isWindows || Platform.isLinux) ? FluentIcons.add : Icons.add;
  static IconData import = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.download_document
      : Icons.import_export_outlined;
  static IconData heart = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.heart
      : CupertinoIcons.heart;
  static IconData heart_fill = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.heart_fill
      : CupertinoIcons.heart_fill;
  static IconData lyrics = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.text_paragraph_option
      : Icons.lyrics;
  static IconData queue = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.playlist_music
      : Icons.queue_music;
  static IconData play = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.play
      : Icons.play_arrow;

  static IconData pause = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.pause
      : Icons.pause;

  static IconData skip_previous = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.previous
      : Icons.skip_previous;
  static IconData skip_next = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.next
      : Icons.skip_next;
  static IconData repeat = (Platform.isWindows || Platform.isLinux)
      ? CupertinoIcons.repeat
      : Icons.repeat;
  static IconData repeat_one = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.repeat_one
      : Icons.repeat_one;
  static IconData repeat_all = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.repeat_all
      : Icons.repeat;
  static IconData more_vertical = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.more_vertical
      : Icons.more_vert;
  static IconData delete = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.delete
      : Icons.delete;
  static IconData volume(range) {
    if (range == 0) {
      return (Platform.isWindows || Platform.isLinux)
          ? FluentIcons.volume0
          : Icons.volume_off;
    } else if (range < .2) {
      return (Platform.isWindows || Platform.isLinux)
          ? FluentIcons.volume1
          : Icons.volume_down;
    } else if (range < .6) {
      return (Platform.isWindows || Platform.isLinux)
          ? FluentIcons.volume2
          : Icons.volume_down;
    }
    return (Platform.isWindows || Platform.isLinux)
        ? FluentIcons.volume3
        : Icons.volume_up;
  }

  static IconData library_add = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.library_add_to
      : Icons.library_add;
  static IconData library_add_check = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.check_mark
      : Icons.library_add_check;
  static IconData playlist_play = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.playlist_music
      : Icons.playlist_play;
  static IconData queue_add = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.build_queue
      : Icons.queue;
  static IconData radio = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.radio_btn_on
      : Icons.radar;
  static IconData person = Icons.person;
  static IconData people = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.people
      : Icons.people;
  static IconData album = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.album
      : Icons.album;
  static IconData equalizer = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.equalizer
      : Icons.equalizer;
  static IconData timer = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.timer
      : Icons.timer;
  static IconData share = (Platform.isWindows || Platform.isLinux)
      ? FluentIcons.share
      : Icons.share;
}
