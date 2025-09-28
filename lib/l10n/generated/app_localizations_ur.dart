// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String onboardingWelcome(Object appName) {
    return '$appName میں خوش آمدید';
  }

  @override
  String get gyawunMusic => 'گیاؤن میوزک';

  @override
  String get onboardingDescription =>
      'اپنا پسندیدہ موسیقی، پوڈکاسٹ اور مزید سنیں۔';

  @override
  String get getStarted => 'شروع کریں';
}
