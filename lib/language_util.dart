import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LanguageUtil {
  LanguageUtil._();

  static Future<Locale?> getDefaultLocale() async {
    try {
      return Devicelocale.defaultAsLocale;
    } on PlatformException {
      print("Error obtaining default locale");
      return null;
    }
  }

  static Future<Locale?> getCurrentLocale() async {
    try {
      return Devicelocale.currentAsLocale;
    } on PlatformException {
      print("Error obtaining current locale");
      return null;
    }
  }

  static Future<List<Locale>> getPreferredLanguages() async {
    try {
      return Devicelocale.preferredLanguagesAsLocales;
    } on PlatformException {
      print("Error obtaining preferred languages");
      return [];
    }
  }

  static Future<bool> checkForPerAppLanguageSupport() async {
    return Devicelocale.isLanguagePerAppSettingSupported;
  }

  static Future<bool> saveLanguage(Locale locale) async {
    return Devicelocale.setLanguagePerApp(locale);
  }
}