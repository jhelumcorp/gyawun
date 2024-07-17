import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_beta/themes/text_styles.dart';
import 'package:gyawun_beta/utils/adaptive_widgets/adaptive_widgets.dart';

class BottomMessage {
  static showText(BuildContext context, String text,
      {Duration duration = const Duration(milliseconds: 1500)}) {
    showPlatformToast(
      child: Text(
        text,
        style: smallTextStyle(context, bold: false, opacity: 0.8)
            .copyWith(color: AdaptiveTheme.of(context).inactiveBackgroundColor),
      ),
      context: context,
      duration: duration,
    );
  }
}
