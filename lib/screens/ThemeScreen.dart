import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import '../providers/LanguageProvider.dart';
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
    bool darkTheme = context.watch<ThemeProvider>().themeMode == ThemeMode.dark;
    return Directionality(
      textDirection: context.watch<LanguageProvider>().textDirection,
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
                                      context
                                          .read<ThemeProvider>()
                                          .setPrimaryColor(color);
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
                                                          Radius.circular(25),
                                                      bottomLeft:
                                                          Radius.circular(25))),
                                        ),
                                        Container(
                                          height: 50,
                                          width: 25,
                                          decoration: BoxDecoration(
                                              color: color.dark,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(25),
                                                      bottomRight:
                                                          Radius.circular(25))),
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
                    backgroundColor: darkTheme ? Colors.white : Colors.black,
                    child: Container(
                        margin: const EdgeInsets.all(8),
                        child: CircleAvatar(
                          backgroundColor: darkTheme
                              ? context.watch<ThemeProvider>().primaryColor.dark
                              : context
                                  .watch<ThemeProvider>()
                                  .primaryColor
                                  .light,
                        )),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                onTap: () {
                  String value =
                      context.read<ThemeProvider>().themeMode == ThemeMode.dark
                          ? 'light'
                          : 'dark';
                  context.read<ThemeProvider>().setTheme(value);
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
                  style:
                      Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                ),
                trailing: CupertinoSwitch(
                    value: context.watch<ThemeProvider>().themeMode ==
                        ThemeMode.dark,
                    onChanged: (value) {
                      context
                          .read<ThemeProvider>()
                          .setTheme(value == true ? 'dark' : 'light');
                    }),
              ),
            ),
            // Dynamic theme
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                onTap: () {
                  bool value = context.read<ThemeProvider>().dynamicThemeMode;
                  context.read<ThemeProvider>().setDynamicThemeMode(!value);
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
                  style:
                      Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                ),
                trailing: CupertinoSwitch(
                    value: context.watch<ThemeProvider>().dynamicThemeMode,
                    onChanged: (value) {
                      context.read<ThemeProvider>().setDynamicThemeMode(value);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
