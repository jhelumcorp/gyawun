import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vibe_music/utils/constants.dart';

showUpdate(BuildContext context) async {
  Response res = await get(Uri.parse(
      "https://raw.githubusercontent.com/sheikhhaziq/vibemusic/main/lib/utils/app.json"));
  Map data = jsonDecode(res.body);
  if (data['stable']['code'] > versionCode) {
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text("New Update available"),
          actions: [
            MaterialButton(
              onPressed: () {},
              child: const Text("CANCEL"),
            ),
            MaterialButton(
              onPressed: () {},
              child: const Text("DOWNLOAD"),
            )
          ],
        );
      },
    );
  }
}
