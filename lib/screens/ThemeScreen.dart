import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../generated/l10n.dart';
import '../providers/ThemeProvider.dart';

class ThemeScreen extends StatelessWidget {
  ThemeScreen({super.key});
  final List<PrimaryColor> colorPallete = [
    ...Colors.primaries
        .map((e) => PrimaryColor(light: e.shade900, dark: e.shade100)),
    PrimaryColor(light: Colors.black, dark: Colors.white)
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> themeModes = [
      {"name": S.of(context).System, "value": "system"},
      {"name": S.of(context).Light, "value": "light"},
      {"name": S.of(context).Dark, "value": "dark"},
    ];
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (context, Box box, child) {
        bool darkTheme = Theme.of(context).brightness == Brightness.dark;
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
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: AlertDialog(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 20),
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  content: Wrap(
                                    spacing: 4,
                                    runSpacing: 4,
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children:
                                        colorPallete.map((PrimaryColor color) {
                                      return Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: InkWell(
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
                                                          const BorderRadius
                                                                  .only(
                                                              topLeft: Radius
                                                                  .circular(25),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      25))),
                                                ),
                                                Container(
                                                  height: 50,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                      color: color.dark,
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .only(
                                                              topRight: Radius
                                                                  .circular(25),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          25))),
                                                ),
                                              ],
                                            ),
                                          ),
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
                      leading: const Icon(Icons.color_lens_rounded),
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
                              color: darkTheme ? Colors.black : Colors.white,
                            ),
                      ),
                      trailing: CircleAvatar(
                        backgroundColor:
                            darkTheme ? Colors.black : Colors.white,
                        child: Container(
                            margin: const EdgeInsets.all(8),
                            child: CircleAvatar(
                              backgroundColor: darkTheme
                                  ? Color(box.get('primaryColorDark',
                                      defaultValue:
                                          defaultPrimaryColor.dark.value))
                                  : Color(box.get('primaryColorLight',
                                      defaultValue:
                                          defaultPrimaryColor.light.value)),
                            )),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ExpansionTile(
                      leading: const Icon(
                        Icons.dark_mode,
                      ),
                      collapsedBackgroundColor:
                          Theme.of(context).colorScheme.primary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      textColor: darkTheme ? Colors.black : Colors.white,
                      iconColor: darkTheme ? Colors.black : Colors.white,
                      collapsedIconColor:
                          darkTheme ? Colors.black : Colors.white,
                      collapsedTextColor:
                          darkTheme ? Colors.black : Colors.white,
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              S.of(context).Theme_Mode,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium
                                  ?.copyWith(
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        darkTheme ? Colors.black : Colors.white,
                                  ),
                            ),
                          ),
                          Text(
                            themeModes
                                    .where((element) =>
                                        element['value'] ==
                                        box.get('theme',
                                            defaultValue: 'system'))
                                    .toList()[0]['name'] ??
                                "",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .titleMedium
                                ?.copyWith(
                                  color:
                                      darkTheme ? Colors.black : Colors.white,
                                ),
                          ),
                        ],
                      ),
                      children: [
                        ListTile(
                          hoverColor: Colors.black,
                          focusColor: Colors.black,
                          title: Text(
                            S.of(context).System,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .titleMedium
                                ?.copyWith(
                                    color:
                                        darkTheme ? Colors.black : Colors.white,
                                    fontWeight: box.get('theme',
                                                defaultValue: 'system') ==
                                            "system"
                                        ? FontWeight.bold
                                        : null),
                          ),
                          trailing: box.get('theme', defaultValue: 'system') ==
                                  "system"
                              ? Icon(
                                  Icons.check_circle_rounded,
                                  color:
                                      darkTheme ? Colors.black : Colors.white,
                                )
                              : null,
                          onTap: () {
                            box.put('theme', "system");
                          },
                        ),
                        ListTile(
                          hoverColor: Colors.black,
                          focusColor: Colors.black,
                          title: Text(
                            S.of(context).Light,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .titleMedium
                                ?.copyWith(
                                    color:
                                        darkTheme ? Colors.black : Colors.white,
                                    fontWeight: box.get('theme',
                                                defaultValue: 'system') ==
                                            "light"
                                        ? FontWeight.bold
                                        : null),
                          ),
                          trailing: box.get('theme', defaultValue: 'system') ==
                                  "light"
                              ? Icon(
                                  Icons.check_circle_rounded,
                                  color:
                                      darkTheme ? Colors.black : Colors.white,
                                )
                              : null,
                          onTap: () {
                            box.put('theme', "light");
                          },
                        ),
                        ListTile(
                          hoverColor: Colors.black,
                          focusColor: Colors.black,
                          title: Text(
                            S.of(context).Dark,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .titleMedium
                                ?.copyWith(
                                    color:
                                        darkTheme ? Colors.black : Colors.white,
                                    fontWeight: box.get('theme',
                                                defaultValue: 'system') ==
                                            "dark"
                                        ? FontWeight.bold
                                        : null),
                          ),
                          trailing: box.get('theme', defaultValue: 'system') ==
                                  "dark"
                              ? Icon(
                                  Icons.check_circle_rounded,
                                  color:
                                      darkTheme ? Colors.black : Colors.white,
                                )
                              : null,
                          onTap: () {
                            box.put('theme', "dark");
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    onTap: () {
                      bool value = box.get('pitchBlack', defaultValue: false);
                      box.put('pitchBlack', !value);
                    },
                    leading: const Icon(
                      Icons.colorize,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    tileColor: Theme.of(context).colorScheme.primary,
                    title: Text(
                      S.of(context).Pitch_black,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleMedium
                          ?.copyWith(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: darkTheme ? Colors.black : Colors.white,
                          ),
                    ),
                    trailing: CupertinoSwitch(
                        value: box.get('pitchBlack', defaultValue: false),
                        onChanged: (value) {
                          box.put('pitchBlack', value);
                        }),
                  ),
                ),
                // Dynamic theme
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    onTap: () {
                      bool value =
                          !box.get('dynamicTheme', defaultValue: false);
                      if (value) {
                        box.put('materialYouTheme', false);
                      }
                      box.put('dynamicTheme', value);
                    },
                    leading: const Icon(Icons.style_rounded),
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
                            color: darkTheme ? Colors.black : Colors.white,
                          ),
                    ),
                    trailing: CupertinoSwitch(
                        value: box.get('dynamicTheme', defaultValue: false),
                        onChanged: (value) {
                          if (value) {
                            box.put('materialYouTheme', false);
                          }
                          box.put('dynamicTheme', value);
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    onTap: () {
                      bool value =
                          !box.get('materialYouTheme', defaultValue: false);
                      if (value) {
                        box.put('dynamicTheme', false);
                      }
                      box.put('materialYouTheme', value);
                    },
                    leading: const Icon(Icons.new_label),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    tileColor: Theme.of(context).colorScheme.primary,
                    title: Text(
                      S.of(context).Material_You_colors,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleMedium
                          ?.copyWith(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: darkTheme ? Colors.black : Colors.white,
                          ),
                    ),
                    trailing: CupertinoSwitch(
                        value: box.get('materialYouTheme', defaultValue: false),
                        onChanged: (value) {
                          if (value) {
                            box.put('dynamicTheme', false);
                          }
                          box.put('materialYouTheme', value);
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
