import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vibe_music/generated/l10n.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  confirm(BuildContext context, text, action) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Confirm",
            style: Theme.of(context).primaryTextTheme.titleLarge,
          ),
          content: Text(
            text,
            style: Theme.of(context).primaryTextTheme.bodyLarge,
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("NO"),
            ),
            MaterialButton(
              onPressed: () {
                action();
                Navigator.pop(context);
              },
              child: const Text("YES"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: darkTheme ? Colors.white : Colors.black,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("History"),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              onTap: () {
                confirm(context, "Are you sure to delete Search History", () {
                  Hive.openBox('search_history').then((box) async {
                    await box.clear();
                  });
                });
              },
              leading: const Icon(
                Icons.search_off_rounded,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              tileColor: Theme.of(context).colorScheme.primary,
              title: Text(
                "Clear Search History",
                style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: darkTheme ? Colors.black : Colors.white,
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              onTap: () {
                confirm(context, "Are you sure to delete Song History", () {
                  Hive.openBox('song_history').then((box) async {
                    await box.clear();
                  });
                });
              },
              leading: const Icon(
                Icons.music_off_rounded,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              tileColor: Theme.of(context).colorScheme.primary,
              title: Text(
                "Clear Song History",
                style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: darkTheme ? Colors.black : Colors.white,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
