import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:vibe_music/Models/Track.dart';
import 'package:vibe_music/providers/HomeScreenProvider.dart';
import 'package:vibe_music/providers/MusicPlayer.dart';
import 'package:vibe_music/screens/MainScreen.dart';
import 'package:vibe_music/utils/colors.dart';

void main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => MusicPlayer()),
    ChangeNotifierProvider(create: (_) => HomeScreenProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    Track? song = context.watch<MusicPlayer>().song;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vibe Music',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: lighten(
            song?.colorPalette?.lightVibrantColor?.color ?? tertiaryColor),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        sliderTheme: SliderThemeData(
          trackHeight: 3,
          trackShape: const RoundedRectSliderTrackShape(),
          overlayShape: SliderComponentShape.noOverlay,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
          activeTrackColor: Colors.black,
          thumbColor: Colors.black,
          inactiveTrackColor: primaryColor,
        ),
      ),
      // onGenerateRoute: (settings) {
      //   switch (settings.name) {
      //     case '/':
      //       return MaterialPageRoute(builder: (_) => const MainScreen());
      //     case '/search':
      //       return MaterialPageRoute(builder: (_) => const MainScreen());
      //     default:
      //       return MaterialPageRoute(builder: (_) => const Text("data"));
      //   }
      // },
      // initialRoute: "/",
      home: const MainScreen(),
    );
  }
}
