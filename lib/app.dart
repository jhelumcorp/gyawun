import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gyawun_music/core/di.dart';
import 'package:gyawun_music/core/theme/theme.dart';
import 'package:gyawun_music/l10n/generated/app_localizations.dart';
import 'package:gyawun_music/router.dart';
import 'package:gyawun_music/services/audio_service/media_player.dart';
import 'package:gyawun_music/services/settings/settings_service.dart';
import 'package:gyawun_music/services/settings/states/app_appearance_state.dart';
import 'package:m3e_design/m3e_design.dart';
import 'package:rxdart/rxdart.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppThemeDataBundle>(
      stream: appThemeStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final data = snapshot.data!;
        final appearance = data.appearance;
        final dominatedColor = data.dominantColor;
        final lightDynamic = data.lightDynamic;
        final darkDynamic = data.darkDynamic;

        final primaryLight = appearance.enableDynamicTheme && dominatedColor != null
            ? dominatedColor
            : appearance.enableSystemColors && lightDynamic != null
            ? lightDynamic.primary
            : Color(appearance.accentColor);

        final primaryDark = appearance.enableDynamicTheme && dominatedColor != null
            ? dominatedColor
            : appearance.enableSystemColors && darkDynamic != null
            ? darkDynamic.primary
            : Color(appearance.accentColor);

        return MaterialApp.router(
          title: 'Gyawun Music',
          routerConfig: router,
          theme: withM3ETheme(
            AppTheme.light(
              primary: primaryLight,
              androidPredictiveBack: appearance.enableAndroidPredictiveBack,
            ),
          ),
          darkTheme: withM3ETheme(
            AppTheme.dark(
              primary: primaryDark,
              isPureBlack: appearance.isPureBlack,
              androidPredictiveBack: appearance.enableAndroidPredictiveBack,
            ),
          ),
          themeMode: appearance.themeMode,
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
}

class AppThemeDataBundle {
  AppThemeDataBundle({
    required this.appearance,
    required this.dominantColor,
    required this.lightDynamic,
    required this.darkDynamic,
  });
  final AppAppearanceState appearance;
  final Color? dominantColor;
  final ColorScheme? lightDynamic;
  final ColorScheme? darkDynamic;
}

Stream<AppThemeDataBundle> appThemeStream() async* {
  // Fetch dynamic colors ONCE
  final corePalette = await DynamicColorPlugin.getCorePalette();

  final lightDynamic = corePalette?.toColorScheme(brightness: Brightness.light);
  final darkDynamic = corePalette?.toColorScheme(brightness: Brightness.dark);

  final appearance$ = sl<SettingsService>().appearance.stream.startWith(
    sl<SettingsService>().appearance.state,
  ); // <--- FIX

  final dominant$ = sl<MediaPlayer>().dominantSeedColorStream.startWith(null); // <--- FIX

  yield* Rx.combineLatest2(
    appearance$,
    dominant$,
    (appearance, dominant) => AppThemeDataBundle(
      appearance: appearance,
      dominantColor: dominant,
      lightDynamic: lightDynamic,
      darkDynamic: darkDynamic,
    ),
  );
}
