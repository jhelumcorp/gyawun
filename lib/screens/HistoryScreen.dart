import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vibe_music/generated/l10n.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  confirm(BuildContext context, text, action, textDirection) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: textDirection,
          child: AlertDialog(
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
                child: Text(S.of(context).NO),
              ),
              MaterialButton(
                onPressed: () {
                  action();
                  Navigator.pop(context);
                },
                child: Text(S.of(context).YES),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = Theme.of(context).brightness == Brightness.dark;
    return ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (context, Box box, chils) {
          return Directionality(
            textDirection:
                box.get('textDirection', defaultValue: 'ltr') == 'rtl'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
            child: Scaffold(
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
                title: Text(S.of(context).History),
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
                        confirm(
                          context,
                          S.of(context).Are_you_sure_to_delete_search_history,
                          () {
                            Hive.openBox('search_history').then(
                              (box) async {
                                await box.clear();
                              },
                            );
                          },
                          box.get('textDirection', defaultValue: 'ltr') == 'rtl'
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                        );
                      },
                      leading: const Icon(
                        Icons.search_off_rounded,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      tileColor: Theme.of(context).colorScheme.primary,
                      title: Text(
                        S.of(context).Clear_search_history,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium
                            ?.copyWith(
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
                        confirm(
                          context,
                          S.of(context).Are_you_sure_to_delete_song_history,
                          () {
                            Hive.openBox('song_history').then((box) async {
                              await box.clear();
                            });
                          },
                          box.get('textDirection', defaultValue: 'ltr') == 'rtl'
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                        );
                      },
                      leading: const Icon(
                        Icons.music_off_rounded,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      tileColor: Theme.of(context).colorScheme.primary,
                      title: Text(
                        S.of(context).Clear_song_history,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium
                            ?.copyWith(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              color: darkTheme ? Colors.black : Colors.white,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
