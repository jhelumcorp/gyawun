import 'package:flutter/material.dart';
import 'package:gyawun_music/router.dart';
import 'package:gyawun_shared/gyawun_shared.dart';

import 'modal_layouts.dart';

class Modals {
  static Future<dynamic> showItemBottomSheet(BuildContext context, SectionItem item) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => ItemBottomLayout(item: item),
    );
  }

  static void showArtistsBottomSheet(BuildContext context, List<Artist> item) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => ModalLayouts.artistsBottomLayout(context, item),
    );
  }

  static Future<String?> showCreatePlaylistModal(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => const CreatePlaylistLayout(),
    );
  }

  static Future<void> showAddToPlaylist(BuildContext context, PlayableItem item) {
    return showModalBottomSheet(
      context: rootNavigatorKey.currentContext!,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => AddToPlaylistLayout(item: item),
    );
  }
}
