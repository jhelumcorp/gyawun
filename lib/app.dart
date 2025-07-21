import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gyawun_music/core/extensions/context_extensions.dart';
import 'package:gyawun_music/core/theme/theme.dart';
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
                theme: AppTheme.light(colorScheme: lightDynamic),
                darkTheme: AppTheme.dark(colorScheme: darkDynamic),
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
