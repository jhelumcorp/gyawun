import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibe_music/utils/constants.dart';

import '../generated/l10n.dart';

Future<bool> checkUpdate() async {
  Response res = await get(Uri.parse(
      "https://raw.githubusercontent.com/sheikhhaziq/vibemusic/main/lib/utils/app.json"));
  Map data = jsonDecode(res.body);
  return int.parse(data['stable']['code']) > versionCode;
}

showUpdate(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Vibe Music",
            style: Theme.of(context).primaryTextTheme.titleLarge),
        content: Text(S.of(context).New_Update_Available,
            style: Theme.of(context).primaryTextTheme.bodyMedium),
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              S.of(context).CANCEL,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          MaterialButton(
            onPressed: () {
              launchUrl(
                Uri.parse(
                    "https://github.com/sheikhhaziq/vibemusic/releases/latest"),
                mode: LaunchMode.externalApplication,
              );
            },
            child: Text(
              S.of(context).DOWNLOAD,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}

showAlert(context, Widget content, {bool cancellable = true}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Vibe Music",
            style: Theme.of(context).primaryTextTheme.titleLarge),
        content: content,
        actions: !cancellable
            ? <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    S.of(context).OKAY,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ]
            : null,
      );
    },
  );
}
