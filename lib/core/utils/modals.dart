import 'package:flutter/material.dart';
import 'package:ytmusic/ytmusic.dart';

import 'modal_layouts.dart';

class Modals {
  static void showItemBottomSheet(BuildContext context,YTSectionItem item) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (context) => ModalLayouts.itemBottomLayout(context, item),
    );
  }
  static void showArtistsBottomSheet(BuildContext context,List<YTArtist> item) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (context) => ModalLayouts.artistsBottomLayout(context, item),
    );
  }
}