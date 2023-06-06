import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lister_app/util/logging.dart';
import 'package:locale_emoji/locale_emoji.dart';

class LanguageUtil {
  LanguageUtil._();

  static Future<Locale?> getDefaultLocale() async {
    try {
      return Devicelocale.defaultAsLocale;
    } on PlatformException {
      logger.e("Error obtaining default locale");
      return null;
    }
  }

  static Future<Locale?> getCurrentLocale() async {
    try {
      return Devicelocale.currentAsLocale;
    } on PlatformException {
      logger.e("Error obtaining current locale");
      return null;
    }
  }

  static Future<List<Locale>> getPreferredLanguages() async {
    try {
      return Devicelocale.preferredLanguagesAsLocales;
    } on PlatformException {
      logger.e("Error obtaining preferred languages");
      return [];
    }
  }

  static Future<bool> checkForPerAppLanguageSupport() async {
    return Devicelocale.isLanguagePerAppSettingSupported;
  }

  static Future<bool> saveLanguage(Locale locale) async {
    return Devicelocale.setLanguagePerApp(locale);
  }

  static String? getFlagForLocale(Locale locale) {
    return getFlagEmoji(languageCode: locale.languageCode, countryCode: locale.countryCode);
  }
}