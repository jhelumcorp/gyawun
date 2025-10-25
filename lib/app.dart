import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/settings/app_settings.dart';
import 'package:gyawun_music/core/theme/theme.dart';
import 'package:gyawun_music/l10n/generated/app_localizations.dart';
import 'package:gyawun_music/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appSettings = sl<AppSettings>();
    return StreamBuilder(
      stream: appSettings.appearance(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!=null) {
          final appearance = snapshot.data!;
          return DynamicColorBuilder(
            builder: (lightDynamic, darkDynamic) {
              return MaterialApp.router(
                title: 'Gyawun Music',
                routerConfig: router,
                theme: AppTheme.light(
                  primary: appearance.enableSystemColors && lightDynamic != null
                      ? lightDynamic.primary
                      : appearance.accentColor,
                ),
                darkTheme: AppTheme.dark(
                  primary: appearance.enableSystemColors && darkDynamic != null
                      ? darkDynamic.primary
                      : appearance.accentColor,
                  isPureBlack: appearance.isPureBlack,
                ),
                themeMode: appearance.themeMode.mode,
                debugShowCheckedModeBanner: false,
                locale: Locale(appearance.language.value),
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
        return SizedBox();
      },
    );
  }
}
