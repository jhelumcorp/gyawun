import 'package:flutter/material.dart';

class AppDialogTileData<T> {
  AppDialogTileData({required this.title, required this.value, this.icon});
  final String title;
  final Widget? icon;
  final T value;
}
