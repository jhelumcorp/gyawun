import 'package:flutter/material.dart';
import 'package:ytmusic/ytmusic.dart';

import 'modal_layouts.dart';

class Modals {
  static void showItemBottomSheet(BuildContext context,YTItem item) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) => ModalLayouts.itemBottomLayout(context, item),
    );
  }
  static void showArtistsBottomSheet(BuildContext context,List<YTArtistBasic> item) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) => ModalLayouts.artistsBottomLayout(context, item),
    );
  }
}