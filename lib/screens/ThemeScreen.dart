import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../generated/l10n.dart';
import '../providers/ThemeProvider.dart';

class ThemeScreen extends StatelessWidget {
  ThemeScreen({super.key});
  final List<PrimaryColor> colorPallete = [
    ...Colors.primaries
        .map((e) => PrimaryColor(light: e.shade100, dark: e.shade900)),
    PrimaryColor(light: Colors.white, dark: Colors.black)
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (context, Box box, child) {
        bool darkTheme = box.get('theme', defaultValue: 'light') == 'dark';
        return Directionality(
          textDirection: box.get('textDirection', defaultValue: 'ltr') == 'rtl'
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
              title: Text(S.of(context).Theme),
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
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Directionality(
                              textDirection: TextDirection.ltr,
                              child: AlertDialog(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                content: SizedBox(
                                  height: 340,
                                  child: GridView(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 0),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 4,
                                    ),
                                    children:
                                        colorPallete.map((PrimaryColor color) {
                                      return InkWell(
                                        onTap: () {
                                          box.put('primaryColorDark',
                                              color.dark.value);
                                          box.put('primaryColorLight',
                                              color.light.value);

                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 50,
                                              width: 25,
                                              decoration: BoxDecoration(
                                                  color: color.light,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  25),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  25))),
                                            ),
                                            Container(
                                              height: 50,
                                              width: 25,
                                              decoration: BoxDecoration(
                                                  color: color.dark,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  25),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  25))),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      leading: Icon(
                        Icons.color_lens_rounded,
                        color: darkTheme ? Colors.white : Colors.black,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      tileColor: Theme.of(context).colorScheme.primary,
                      title: Text(
                        S.of(context).Theme,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium
                            ?.copyWith(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      trailing: CircleAvatar(
                        backgroundColor:
                            darkTheme ? Colors.white : Colors.black,
                        child: Container(
                            margin: const EdgeInsets.all(8),
                            child: CircleAvatar(
                              backgroundColor: darkTheme
                                  ? Color(box.get('primaryColorDark',
                                      defaultValue:
                                          defaultPrimaryColor.dark.value))
                                  //  context
                                  //     .watch<ThemeProvider>()
                                  //     .primaryColor
                                  //     .dark
                                  : Color(box.get('primaryColorLight',
                                      defaultValue:
                                          defaultPrimaryColor.light.value)),
                            )),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    onTap: () {
                      String value =
                          box.get('theme', defaultValue: 'light') == 'dark'
                              ? 'light'
                              : 'dark';
                      box.put('theme', value);
                    },
                    leading: Icon(
                      Icons.dark_mode,
                      color: darkTheme ? Colors.white : Colors.black,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    tileColor: Theme.of(context).colorScheme.primary,
                    title: Text(
                      S.of(context).Dark_Theme,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleMedium
                          ?.copyWith(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    trailing: CupertinoSwitch(
                        value:
                            box.get('theme', defaultValue: 'light') == 'dark',
                        onChanged: (value) {
                          box.put('theme', value == true ? 'dark' : 'light');
                        }),
                  ),
                ),
                // Dynamic theme
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    onTap: () {
                      bool value = box.get('dynamicTheme', defaultValue: false);
                      box.put('dynamicTheme', !value);
                    },
                    leading: Icon(
                      Icons.style_rounded,
                      color: darkTheme ? Colors.white : Colors.black,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    tileColor: Theme.of(context).colorScheme.primary,
                    title: Text(
                      S.of(context).Dynamic_Theme,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleMedium
                          ?.copyWith(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    trailing: CupertinoSwitch(
                        value: box.get('dynamicTheme', defaultValue: false),
                        onChanged: (value) {
                          box.put('dynamicTheme', value);
                        }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
