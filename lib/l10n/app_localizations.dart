import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Provides all user-visible strings in English and Bengali.
///
/// Access via [AppLocalizations.of(context)] or the shorter [BuildContext.l10n]
/// extension defined at the bottom of this file.
class AppLocalizations {
  final Locale locale;
  const AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static const delegate = _AppLocalizationsDelegate();

  String get _lang => locale.languageCode;

  String _t(String key) =>
      (_strings[_lang] ?? _strings['en']!)[key] ??
      _strings['en']![key] ??
      key;

  // ── Localized direction word ───────────────────────────────────────────────

  String localizedSide(String side) {
    switch (side.toLowerCase()) {
      case 'left':
        return _t('sideLeft');
      case 'right':
        return _t('sideRight');
      default:
        return side;
    }
  }

  // ── App ───────────────────────────────────────────────────────────────────

  String get appName => _t('appName');

  // ── Navigation ────────────────────────────────────────────────────────────

  String get navHome => _t('navHome');
  String get navPlan => _t('navPlan');
  String get navSettings => _t('navSettings');
  String get navTracker => _t('navTracker');
  String get navHistory => _t('navHistory');

  // ── Common ────────────────────────────────────────────────────────────────

  String get sunny => _t('sunny');
  String get nighttime => _t('nighttime');
  String get live => _t('live');

  // ── Home screen ───────────────────────────────────────────────────────────

  String get noSunlightNighttime => _t('noSunlightNighttime');
  String get liveSuggestion => _t('liveSuggestion');
  String get allSeatsAreFine => _t('allSeatsAreFine');
  String get travellingAtNight => _t('travellingAtNight');
  String get findBestSeat => _t('findBestSeat');
  String get planAnotherTrip => _t('planAnotherTrip');

  String basedOnRoute(String heading, String time, String side) =>
      _t('basedOnRoute')
          .replaceAll('{heading}', heading)
          .replaceAll('{time}', time)
          .replaceAll('{side}', localizedSide(side));

  /// Returns [prefix, coloredSide, suffix] for "Sunlight on LEFT side".
  List<String> sunlightOnSideRich(String side) {
    final s = localizedSide(side);
    if (_lang == 'bn') return ['', s, ' পাশে রোদ'];
    return ['Sunlight on ', side.toUpperCase(), ' side'];
  }

  /// Returns [prefix, coloredSide, suffix] for "Sit on RIGHT side".
  List<String> sitOnSideRich(String side) {
    final s = localizedSide(side);
    if (_lang == 'bn') return ['', s, ' পাশে বসুন'];
    return ['Sit on ', side.toUpperCase(), ' side'];
  }

  // ── Plan trip screen ──────────────────────────────────────────────────────

  String get planYourTrip => _t('planYourTrip');
  String get whereAreYouHeading => _t('whereAreYouHeading');
  String get findCoolestSeat => _t('findCoolestSeat');
  String get originHint => _t('originHint');
  String get destinationHint => _t('destinationHint');
  String get departureTimeLabel => _t('departureTimeLabel');
  String nowLabel(String time) =>
      _t('nowLabel').replaceAll('{time}', time);
  String get later => _t('later');
  String get sunnyForecast => _t('sunnyForecast');
  String get directExposure => _t('directExposure');
  String get findShadySide => _t('findShadySide');
  String get pleaseEnterOrigin => _t('pleaseEnterOrigin');
  String get pleaseEnterDestination => _t('pleaseEnterDestination');
  String get sameCityError => _t('sameCityError');

  // ── Plan trip: help sheet ─────────────────────────────────────────────────

  String get howItWorks => _t('howItWorks');
  String get helpStep1Title => _t('helpStep1Title');
  String get helpStep1Detail => _t('helpStep1Detail');
  String get helpStep2Title => _t('helpStep2Title');
  String get helpStep2Detail => _t('helpStep2Detail');
  String get helpStep3Title => _t('helpStep3Title');
  String get helpStep3Detail => _t('helpStep3Detail');
  String get gotIt => _t('gotIt');

  // ── Best seat screen ──────────────────────────────────────────────────────

  String get bestSeatFound => _t('bestSeatFound');
  String get noDirectSunlightNight => _t('noDirectSunlightNight');
  String intenseSunlightOn(String side) =>
      _t('intenseSunlightOn').replaceAll('{side}', localizedSide(side));
  String get allSeatsComfortable => _t('allSeatsComfortable');
  String get trackSunLive => _t('trackSunLive');

  // ── Sun tracker screen ────────────────────────────────────────────────────

  String get liveTrackerLabel => _t('liveTrackerLabel');
  String get sunPosition => _t('sunPosition');
  String headingChip(String heading) =>
      _t('headingChip').replaceAll('{heading}', heading);
  String get timeProjection => _t('timeProjection');
  String get notifyOnShadeChange => _t('notifyOnShadeChange');
  String get timeLabelNoon => _t('timeLabelNoon');
  String get timeLabelAfternoon => _t('timeLabelAfternoon');
  String get timeLabelEvening => _t('timeLabelEvening');
  String intenseSunlightOnSide(String side) =>
      _t('intenseSunlightOnSide').replaceAll('{side}', localizedSide(side));

  /// Returns [prefix, coloredSide, suffix] for "Shade is moving Right".
  List<String> shadeIsMovingRich(String side) {
    final s = localizedSide(side);
    if (_lang == 'bn') return ['ছায়া ', s, ' দিকে যাচ্ছে'];
    final cap = side.isEmpty ? side : side[0].toUpperCase() + side.substring(1);
    return ['Shade is moving ', cap, ''];
  }

  // ── Settings screen ───────────────────────────────────────────────────────

  String get settingsTitle => _t('settingsTitle');
  String get settingsLanguage => _t('settingsLanguage');
  String get settingsEnglish => _t('settingsEnglish');
  String get settingsBengali => _t('settingsBengali');

  // ── Strings map ───────────────────────────────────────────────────────────

  static const Map<String, Map<String, String>> _strings = {
    'en': {
      'appName': 'Smart Seating',
      'navHome': 'Home',
      'navPlan': 'Plan',
      'navSettings': 'Settings',
      'navTracker': 'Tracker',
      'navHistory': 'History',
      'sunny': 'Sunny',
      'nighttime': 'Nighttime',
      'sideLeft': 'Left',
      'sideRight': 'Right',
      'live': 'Live',
      // Home
      'noSunlightNighttime': 'No sunlight — nighttime travel',
      'liveSuggestion': 'LIVE SUGGESTION',
      'allSeatsAreFine': 'All seats are fine!',
      'travellingAtNight': 'Travelling at night — no sun glare to worry about.',
      'basedOnRoute':
          'Based on your route heading {heading} at {time}, the {side} side will be in full shade.',
      'findBestSeat': 'Find Best Seat',
      'planAnotherTrip': 'Plan Another Trip',
      // Plan trip
      'planYourTrip': 'Plan Your Trip',
      'whereAreYouHeading': 'Where are you heading?',
      'findCoolestSeat': "We'll find the coolest seat for your journey.",
      'originHint': 'Origin',
      'destinationHint': 'Destination',
      'departureTimeLabel': 'DEPARTURE TIME',
      'nowLabel': 'Now ({time})',
      'later': 'Later',
      'sunnyForecast': 'Sunny Forecast',
      'directExposure': 'Direct exposure expected on this route.',
      'findShadySide': 'Find Shady Side',
      'pleaseEnterOrigin': 'Please enter your starting location.',
      'pleaseEnterDestination': 'Please enter your destination.',
      'sameCityError': 'Origin and destination cannot be the same.',
      // Help sheet
      'howItWorks': 'How it works',
      'helpStep1Title': 'Enter your route',
      'helpStep1Detail':
          'Type your origin and destination, or tap the location icon to use your current position.',
      'helpStep2Title': 'Choose departure time',
      'helpStep2Detail':
          'Pick "Now" for live conditions or "Later" to select a custom departure time.',
      'helpStep3Title': 'Get your shady seat',
      'helpStep3Detail':
          'We calculate the exact sun angle for your route and time to find which side of the bus stays in full shade.',
      'gotIt': 'Got it',
      // Best seat
      'bestSeatFound': 'Best Seat Found',
      'noDirectSunlightNight': 'No direct sunlight — nighttime travel',
      'intenseSunlightOn': 'Intense heat on {side}',
      'allSeatsComfortable': 'All seats are comfortable!',
      'trackSunLive': 'Track Sun Live',
      // Sun tracker
      'liveTrackerLabel': 'LIVE TRACKER',
      'sunPosition': 'Sun Position',
      'headingChip': 'Heading {heading}',
      'timeProjection': 'TIME PROJECTION',
      'notifyOnShadeChange': 'Notify on Shade Change',
      'timeLabelNoon': '12:00 PM',
      'timeLabelAfternoon': '4:00 PM',
      'timeLabelEvening': '8:00 PM',
      'intenseSunlightOnSide': 'Intense Sunlight on {side}',
      // Settings
      'settingsTitle': 'Settings',
      'settingsLanguage': 'Language',
      'settingsEnglish': 'English',
      'settingsBengali': 'বাংলা',
    },
    'bn': {
      'appName': 'স্মার্ট সিটিং',
      'navHome': 'হোম',
      'navPlan': 'পরিকল্পনা',
      'navSettings': 'সেটিংস',
      'navTracker': 'ট্র্যাকার',
      'navHistory': 'ইতিহাস',
      'sunny': 'রোদেলা',
      'nighttime': 'রাত্রিকাল',
      'sideLeft': 'বাম',
      'sideRight': 'ডান',
      'live': 'লাইভ',
      // Home
      'noSunlightNighttime': 'কোনো রোদ নেই — রাতের ভ্রমণ',
      'liveSuggestion': 'লাইভ পরামর্শ',
      'allSeatsAreFine': 'সব আসন ঠিক আছে!',
      'travellingAtNight': 'রাতের ভ্রমণ — রোদের চিন্তা নেই।',
      'basedOnRoute':
          '{time}-এ {heading} দিকে আপনার পথে, {side} পাশ সম্পূর্ণ ছায়ায় থাকবে।',
      'findBestSeat': 'সেরা আসন খুঁজুন',
      'planAnotherTrip': 'আরেকটি যাত্রা পরিকল্পনা করুন',
      // Plan trip
      'planYourTrip': 'আপনার যাত্রা পরিকল্পনা করুন',
      'whereAreYouHeading': 'আপনি কোথায় যাচ্ছেন?',
      'findCoolestSeat': 'আমরা আপনার যাত্রার জন্য সবচেয়ে শীতল আসন খুঁজে দেব।',
      'originHint': 'উৎস স্থান',
      'destinationHint': 'গন্তব্য',
      'departureTimeLabel': 'প্রস্থানের সময়',
      'nowLabel': 'এখন ({time})',
      'later': 'পরে',
      'sunnyForecast': 'রোদেলা পূর্বাভাস',
      'directExposure': 'এই পথে সরাসরি রোদের সম্ভাবনা।',
      'findShadySide': 'ছায়াময় পাশ খুঁজুন',
      'pleaseEnterOrigin': 'অনুগ্রহ করে শুরুর স্থান দিন।',
      'pleaseEnterDestination': 'অনুগ্রহ করে গন্তব্য দিন।',
      'sameCityError': 'উৎস ও গন্তব্য একই হতে পারে না।',
      // Help sheet
      'howItWorks': 'এটি কীভাবে কাজ করে',
      'helpStep1Title': 'আপনার পথ লিখুন',
      'helpStep1Detail':
          'আপনার উৎস ও গন্তব্য টাইপ করুন, অথবা বর্তমান অবস্থান ব্যবহার করতে লোকেশন আইকনে ট্যাপ করুন।',
      'helpStep2Title': 'প্রস্থানের সময় বেছে নিন',
      'helpStep2Detail':
          '"এখন" লাইভ অবস্থার জন্য বা "পরে" কাস্টম সময়ের জন্য বেছে নিন।',
      'helpStep3Title': 'ছায়াময় আসন পান',
      'helpStep3Detail':
          'আমরা আপনার পথ ও সময়ের জন্য সঠিক সূর্যের কোণ হিসাব করে বাসের কোন পাশ সম্পূর্ণ ছায়ায় থাকবে তা বের করি।',
      'gotIt': 'বুঝেছি',
      // Best seat
      'bestSeatFound': 'সেরা আসন পাওয়া গেছে',
      'noDirectSunlightNight': 'সরাসরি রোদ নেই — রাতের ভ্রমণ',
      'intenseSunlightOn': '{side} পাশে তীব্র গরম',
      'allSeatsComfortable': 'সব আসন আরামদায়ক!',
      'trackSunLive': 'সূর্য লাইভ ট্র্যাক করুন',
      // Sun tracker
      'liveTrackerLabel': 'লাইভ ট্র্যাকার',
      'sunPosition': 'সূর্যের অবস্থান',
      'headingChip': 'দিক: {heading}',
      'timeProjection': 'সময় প্রক্ষেপণ',
      'notifyOnShadeChange': 'ছায়া পরিবর্তনে জানান',
      'timeLabelNoon': 'দুপুর ১২টা',
      'timeLabelAfternoon': 'বিকাল ৪টা',
      'timeLabelEvening': 'রাত ৮টা',
      'intenseSunlightOnSide': '{side} পাশে তীব্র রোদ',
      // Settings
      'settingsTitle': 'সেটিংস',
      'settingsLanguage': 'ভাষা',
      'settingsEnglish': 'English',
      'settingsBengali': 'বাংলা',
    },
  };
}

// ── BuildContext extension ────────────────────────────────────────────────────

extension AppLocalizationsExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

// ── Delegate ──────────────────────────────────────────────────────────────────

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'bn'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture(AppLocalizations(locale));

  @override
  bool shouldReload(
          covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
