// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String onboardingWelcome(Object appName) {
    return '$appName में आपका स्वागत है';
  }

  @override
  String get gyawunMusic => 'ग्यावुन म्यूज़िक';

  @override
  String get onboardingDescription =>
      'अपना पसंदीदा संगीत, पॉडकास्ट और बहुत कुछ सुनें।';

  @override
  String get getStarted => 'शुरू करें';
}
