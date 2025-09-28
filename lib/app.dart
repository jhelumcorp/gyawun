import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gyawun_music/core/theme/theme.dart';
import 'package:gyawun_music/l10n/generated/app_localizations.dart';
import 'package:gyawun_music/providers/database_provider.dart';
import 'package:gyawun_music/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final appearanceSettings = ref.watch(appearanceSettingsProvider);
    return appearanceSettings.when(
      data: (appearance) {
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
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => MaterialApp(
        home: Scaffold(body: Center(child: Text("Error: $err"))),
      ),
    );
  }
}
