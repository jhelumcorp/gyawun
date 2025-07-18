import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyawun_music/router.dart';
import 'package:yaru/yaru.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gyawun_music/l10n/app_localizations.dart';

bool get isDesktop =>
    Platform.isLinux || Platform.isMacOS || Platform.isWindows;

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return isDesktop
        ? YaruTheme(
            builder: (context, yaru, child) {
              return MaterialApp.router(
                title: 'Gyawun Music',
                routerConfig: router,
                theme: yaru.theme,
                darkTheme: yaru.darkTheme,
                themeMode: ThemeMode.system,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
              );
            },
          )
        : MaterialApp.router(
            title: 'Gyawun Music',
            routerConfig: router,
            theme: ThemeData.light(
              useMaterial3: true,
            ).copyWith(textTheme: GoogleFonts.poppinsTextTheme()),
            darkTheme: ThemeData.dark(
              useMaterial3: true,
            ).copyWith(textTheme: GoogleFonts.poppinsTextTheme()),
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          );
  }
}
