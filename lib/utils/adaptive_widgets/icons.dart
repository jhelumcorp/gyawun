// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';

abstract final class AdaptiveIcons {
  static IconData home = Platform.isWindows ? FluentIcons.home : Icons.home;
  static IconData home_filled =
      Platform.isWindows ? FluentIcons.home : Icons.home_filled;
  static IconData back =
      Platform.isWindows ? FluentIcons.back : Icons.arrow_back;
  static IconData chevron_left =
      Platform.isWindows ? FluentIcons.chevron_left : Icons.chevron_left;
  static IconData chevron_right =
      Platform.isWindows ? FluentIcons.chevron_right : Icons.chevron_right;
  static IconData search =
      Platform.isWindows ? FluentIcons.search : Icons.search;
}
