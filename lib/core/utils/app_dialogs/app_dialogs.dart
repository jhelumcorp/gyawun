import 'package:flutter/material.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_color_selection_dialog.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_dialog_tile_data.dart';
import 'package:gyawun_music/core/utils/app_dialogs/app_promp_dialog.dart';

import 'app_option_selection_dialog.dart';

class AppDialogs {
  static Future<T?> showOptionSelectionDialog<T>(
    BuildContext context, {
    String? title,
    Widget? icon,
    List<AppDialogTileData<T>> children = const [],
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) {
        return optionSelectionDialog<T>(context, title: title, icon: icon, children: children);
      },
    );
  }

  static Future<Color?> showColorSelectionDialog(BuildContext context) {
    return showDialog<Color>(
      context: context,
      builder: (context) {
        return colorSelectionDialog(context);
      },
    );
  }

  static Future<String?> showPromptDialog(BuildContext context, {String? title}) {
    return showDialog(
      context: context,
      builder: (context) {
        return promptDialog(context, title: title);
      },
    );
  }
}
