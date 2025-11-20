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
  String get gyawunMusic => 'ग्यावुन म्यूजिक';

  @override
  String get onboardingDescription =>
      'अपना पसंदीदा संगीत, पॉडकास्ट और बहुत कुछ स्ट्रीम करें।';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get general => 'सामान्य';

  @override
  String get appearance => 'दिखावट';

  @override
  String get player => 'प्लेयर';

  @override
  String get services => 'सेवाएं';

  @override
  String get youtubeMusic => 'YouTube Music';

  @override
  String get jioSaavn => 'JioSaavn';

  @override
  String get storageAndPrivacy => 'स्टोरेज और गोपनीयता';

  @override
  String get storageAndBackups => 'स्टोरेज और बैकअप';

  @override
  String get privacy => 'गोपनीयता';

  @override
  String get updatesAndAbout => 'अपडेट और परिचय';

  @override
  String get about => 'बारे में';

  @override
  String get checkForUpdate => 'अपडेट की जांच करें';

  @override
  String get library => 'लाइब्रेरी';

  @override
  String get defaultCollection => 'डिफ़ॉल्ट';

  @override
  String get favourites => 'पसंदीदा';

  @override
  String get history => 'इतिहास';

  @override
  String get downloads => 'डाउनलोड';

  @override
  String get custom => 'कस्टम';

  @override
  String get remote => 'रिमोट';

  @override
  String error(Object message) {
    return 'त्रुटि: $message';
  }

  @override
  String minutes(Object minutes) {
    return '$minutes मिनट';
  }

  @override
  String get customEllipsis => 'कस्टम…';

  @override
  String get setSleepTimer => 'स्लीप टाइमर सेट करें';

  @override
  String get hours => 'घंटे';

  @override
  String get minutesLabel => 'मिनट';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get set => 'सेट करें';

  @override
  String get settingUp => 'सेट अप हो रहा है...';

  @override
  String get queueIsEmpty => 'कतार (Queue) खाली है';

  @override
  String get home => 'होम';

  @override
  String get search => 'खोजें';

  @override
  String get theme => 'थीम';

  @override
  String get darkTheme => 'डार्क थीम';

  @override
  String get accentColor => 'एक्सेंट रंग';

  @override
  String get enableDynamicTheme => 'डायनामिक थीम सक्षम करें';

  @override
  String get pureBlack => 'प्योर ब्लैक';

  @override
  String get enableSystemColors => 'सिस्टम रंगों को सक्षम करें';

  @override
  String get layout => 'लेआउट';

  @override
  String get language => 'भाषा';

  @override
  String get predictiveBack => 'प्रेडिक्टिव बैक';

  @override
  String get android14Plus => 'Android 14+';

  @override
  String get enableNewPlayer => 'नया प्लेयर सक्षम करें';

  @override
  String get on => 'चालू';

  @override
  String get off => 'बंद';

  @override
  String get followSystem => 'सिस्टम के अनुसार';

  @override
  String get appFolder => 'ऐप फ़ोल्डर';

  @override
  String get imageCache => 'इमेज कैश';

  @override
  String get songCache => 'सॉन्ग कैश';

  @override
  String get backupAndRestore => 'बैकअप और रिस्टोर';

  @override
  String get backup => 'बैकअप';

  @override
  String get restore => 'रिस्टोर';

  @override
  String get skipSilence => 'साइलेंस स्किप करें';

  @override
  String get miniPlayer => 'मिनी प्लेयर';

  @override
  String get enableNextButton => 'अगला बटन सक्षम करें';

  @override
  String get enablePreviousButton => 'पिछला बटन सक्षम करें';

  @override
  String get audioQuality => 'ऑडियो गुणवत्ता';

  @override
  String get streamingQuality => 'स्ट्रीमिंग गुणवत्ता';

  @override
  String get downloadingQuality => 'डाउनलोडिंग गुणवत्ता';

  @override
  String get sponsorBlock => 'स्पॉन्सर ब्लॉक';

  @override
  String get enableSponsorBlock => 'स्पॉन्सर ब्लॉक सक्षम करें';

  @override
  String get blockSponsors => 'स्पॉन्सर ब्लॉक करें';

  @override
  String get blockSelfPromo => 'सेल्फ प्रोमो ब्लॉक करें';

  @override
  String get blockInteraction => 'इंटरैक्शन ब्लॉक करें';

  @override
  String get blockIntro => 'इंट्रो ब्लॉक करें';

  @override
  String get blockOutro => 'आउट्रो ब्लॉक करें';

  @override
  String get blockPreview => 'प्रीव्यू ब्लॉक करें';

  @override
  String get blockMusicOffTopic => 'म्यूजिक ऑफ-टॉपिक ब्लॉक करें';

  @override
  String get personalisedContent => 'व्यक्तिगत सामग्री';

  @override
  String get enterVisitorId => 'विज़िटर ID दर्ज करें';

  @override
  String get resetVisitorId => 'विज़िटर ID रीसेट करें';

  @override
  String get copied => 'कॉपी किया गया!';
}
