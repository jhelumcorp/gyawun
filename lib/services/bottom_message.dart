import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/material.dart';

import '../themes/text_styles.dart';
import '../utils/adaptive_widgets/theme.dart';

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
