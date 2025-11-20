import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('ur'),
  ];

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {appName}'**
  String onboardingWelcome(Object appName);

  /// No description provided for @gyawunMusic.
  ///
  /// In en, this message translates to:
  /// **'Gyawun Music'**
  String get gyawunMusic;

  /// No description provided for @onboardingDescription.
  ///
  /// In en, this message translates to:
  /// **'Stream your favorite music, podcasts, and more.'**
  String get onboardingDescription;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @player.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get player;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @youtubeMusic.
  ///
  /// In en, this message translates to:
  /// **'Youtube Music'**
  String get youtubeMusic;

  /// No description provided for @jioSaavn.
  ///
  /// In en, this message translates to:
  /// **'Jio Saavn'**
  String get jioSaavn;

  /// No description provided for @storageAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Storage & Privacy'**
  String get storageAndPrivacy;

  /// No description provided for @storageAndBackups.
  ///
  /// In en, this message translates to:
  /// **'Storage and backups'**
  String get storageAndBackups;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @updatesAndAbout.
  ///
  /// In en, this message translates to:
  /// **'Updates & About'**
  String get updatesAndAbout;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @checkForUpdate.
  ///
  /// In en, this message translates to:
  /// **'Check for update'**
  String get checkForUpdate;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @defaultCollection.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultCollection;

  /// No description provided for @favourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favourites;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @downloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloads;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @remote.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get remote;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(Object message);

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String minutes(Object minutes);

  /// No description provided for @customEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Custom…'**
  String get customEllipsis;

  /// No description provided for @setSleepTimer.
  ///
  /// In en, this message translates to:
  /// **'Set Sleep Timer'**
  String get setSleepTimer;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @minutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutesLabel;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @settingUp.
  ///
  /// In en, this message translates to:
  /// **'Setting up...'**
  String get settingUp;

  /// No description provided for @queueIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Queue is empty'**
  String get queueIsEmpty;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkTheme;

  /// No description provided for @accentColor.
  ///
  /// In en, this message translates to:
  /// **'Accent Color'**
  String get accentColor;

  /// No description provided for @enableDynamicTheme.
  ///
  /// In en, this message translates to:
  /// **'Enable dynamic theme'**
  String get enableDynamicTheme;

  /// No description provided for @pureBlack.
  ///
  /// In en, this message translates to:
  /// **'Pure black'**
  String get pureBlack;

  /// No description provided for @enableSystemColors.
  ///
  /// In en, this message translates to:
  /// **'Enable system colors'**
  String get enableSystemColors;

  /// No description provided for @layout.
  ///
  /// In en, this message translates to:
  /// **'Layout'**
  String get layout;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @predictiveBack.
  ///
  /// In en, this message translates to:
  /// **'Predictive Back'**
  String get predictiveBack;

  /// No description provided for @android14Plus.
  ///
  /// In en, this message translates to:
  /// **'Android 14+'**
  String get android14Plus;

  /// No description provided for @enableNewPlayer.
  ///
  /// In en, this message translates to:
  /// **'Enable new player'**
  String get enableNewPlayer;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @followSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get followSystem;

  /// No description provided for @appFolder.
  ///
  /// In en, this message translates to:
  /// **'App Folder'**
  String get appFolder;

  /// No description provided for @imageCache.
  ///
  /// In en, this message translates to:
  /// **'Image Cache'**
  String get imageCache;

  /// No description provided for @songCache.
  ///
  /// In en, this message translates to:
  /// **'Song Cache'**
  String get songCache;

  /// No description provided for @backupAndRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup and restore'**
  String get backupAndRestore;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @skipSilence.
  ///
  /// In en, this message translates to:
  /// **'Skip silence'**
  String get skipSilence;

  /// No description provided for @miniPlayer.
  ///
  /// In en, this message translates to:
  /// **'Mini Player'**
  String get miniPlayer;

  /// No description provided for @enableNextButton.
  ///
  /// In en, this message translates to:
  /// **'Enable next button'**
  String get enableNextButton;

  /// No description provided for @enablePreviousButton.
  ///
  /// In en, this message translates to:
  /// **'Enable previous button'**
  String get enablePreviousButton;

  /// No description provided for @audioQuality.
  ///
  /// In en, this message translates to:
  /// **'Audio quality'**
  String get audioQuality;

  /// No description provided for @streamingQuality.
  ///
  /// In en, this message translates to:
  /// **'Streaming quality'**
  String get streamingQuality;

  /// No description provided for @downloadingQuality.
  ///
  /// In en, this message translates to:
  /// **'Downloading quality'**
  String get downloadingQuality;

  /// No description provided for @sponsorBlock.
  ///
  /// In en, this message translates to:
  /// **'Sponsor Block'**
  String get sponsorBlock;

  /// No description provided for @enableSponsorBlock.
  ///
  /// In en, this message translates to:
  /// **'Enable Sponsor Block'**
  String get enableSponsorBlock;

  /// No description provided for @blockSponsors.
  ///
  /// In en, this message translates to:
  /// **'Block Sponsors'**
  String get blockSponsors;

  /// No description provided for @blockSelfPromo.
  ///
  /// In en, this message translates to:
  /// **'Block Self Promo'**
  String get blockSelfPromo;

  /// No description provided for @blockInteraction.
  ///
  /// In en, this message translates to:
  /// **'Block Interaction'**
  String get blockInteraction;

  /// No description provided for @blockIntro.
  ///
  /// In en, this message translates to:
  /// **'Block Intro'**
  String get blockIntro;

  /// No description provided for @blockOutro.
  ///
  /// In en, this message translates to:
  /// **'Block Outro'**
  String get blockOutro;

  /// No description provided for @blockPreview.
  ///
  /// In en, this message translates to:
  /// **'Block Preview'**
  String get blockPreview;

  /// No description provided for @blockMusicOffTopic.
  ///
  /// In en, this message translates to:
  /// **'Block Music Offtopic'**
  String get blockMusicOffTopic;

  /// No description provided for @personalisedContent.
  ///
  /// In en, this message translates to:
  /// **'Personalised Content'**
  String get personalisedContent;

  /// No description provided for @enterVisitorId.
  ///
  /// In en, this message translates to:
  /// **'Enter visitor ID'**
  String get enterVisitorId;

  /// No description provided for @resetVisitorId.
  ///
  /// In en, this message translates to:
  /// **'Reset Visitor ID'**
  String get resetVisitorId;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get copied;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
