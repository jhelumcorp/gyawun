import 'package:flutter/material.dart';
import 'package:gyawun_music/router.dart';
import 'package:ytmusic/ytmusic.dart';

import 'modal_layouts.dart';

class Modals {
  static void showItemBottomSheet(BuildContext context, YTItem item) {
    bottomSheetCounter.value++;
    showModalBottomSheet(
      context: rootNavigatorKey.currentContext!,
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) => ModalLayouts.itemBottomLayout(context, item),
    );
  }

  static void showArtistsBottomSheet(
    BuildContext context,
    List<YTArtistBasic> item,
  ) {
    bottomSheetCounter.value++;
    showModalBottomSheet(
      context: rootNavigatorKey.currentContext!,
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) => ModalLayouts.artistsBottomLayout(context, item),
    );
  }
}
