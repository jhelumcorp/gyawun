import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gyawun_music/core/extensions/context_extensions.dart';
import 'package:gyawun_music/router.dart';
import 'package:yaru/yaru.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gyawun_music/l10n/app_localizations.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return context.isDesktop
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
        : DynamicColorBuilder(
            builder: (lightDynamic, darkDynamic) {
              return MaterialApp.router(
                title: 'Gyawun Music',
                routerConfig: router,
                theme: ThemeData.light(useMaterial3: true).copyWith(
                  colorScheme: lightDynamic,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  appBarTheme: AppBarTheme(
                    centerTitle: true,
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarBrightness: Brightness.light,
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.dark,
                      systemNavigationBarColor: Colors.transparent,
                    ),
                  ),
                ),
                darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
                  colorScheme: darkDynamic,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  appBarTheme: AppBarTheme(
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarBrightness: Brightness.dark,
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.light,
                      systemNavigationBarColor: Colors.transparent,
                    ),
                  ),
                ),
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
          );
  }
}
