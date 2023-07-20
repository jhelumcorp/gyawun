import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';

showCreatePlaylist(BuildContext context, {List<Map>? songs}) {
  TextEditingController controller = TextEditingController();
  showCupertinoDialog(
    barrierDismissible: true,
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: const Text("Create Playlist"),
      content: CupertinoTextField(
        controller: controller,
        prefix: const Padding(
          padding: EdgeInsets.all(4.0),
          child: Icon(Iconsax.text),
        ),
        placeholder: "Playlist Name",
      ),
      actions: [
        CupertinoButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context)),
      ],
    ),
  );
}
