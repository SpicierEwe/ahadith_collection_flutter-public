import 'dart:convert';

import 'package:ahadith_collection/providers/bookmark_provider.dart';
import 'package:ahadith_collection/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart' as services;

class SettingsProvider extends ChangeNotifier {
  String selectedLanguage = '';

  updateSelectedLanguage(
      {required String lang, required BookMarkProvider bookMarkProvider}) {
    // bookMarkProvider.bookmarkedLanguage = lang;
    // print(
    //     'im from language switcher and the bookmarked index is = ${bookMarkProvider.bookmarkedLanguage}');
    selectedLanguage = lang;

    notifyListeners();
  }

  changeStyleAccordingToLanguage(
      {required ThemeProvider themeProvider,
      required SettingsProvider settingsProvider}) {
    if (selectedLanguage == 'ur') {
      return TextStyle(
          fontFamily: 'Noto',
          fontSize: fontSize + 1.1,
          // fontSize: cmh* 0.023,
          color: themeProvider.hadithScreenFontColor);
    }
    if (selectedLanguage == 'ar') {
      return TextStyle(
        color: themeProvider.hadithScreenFontColor,
        // fontWeight:
        //     FontWeight
        //         .w600,
        fontSize: fontSize + 6.9,
        fontFamily: 'Uthmani_hafs_official',
      );
    }
    return
        //   GoogleFonts.poppins(
        //   color: themeProvider.hadithScreenFontColor,
        //   // fontSize: fontSize,
        //   // height: 1.65,
        //     fontSize:13.sp
        // );
        TextStyle(
      // fontWeight: FontWeight.bold,
      fontFamily: 'AcuminPro',
      color: themeProvider.hadithScreenFontColor,
      fontSize: fontSize,
      height: 1.5,
    );
  }

  late ZoomDrawerController zoomDrawerController;

  toggleMenu() {
    zoomDrawerController.toggle?.call();
    notifyListeners();
  }

  ///
  ///
  ///
  ///
  int settingsLanguageTabIndex = 0;

  ///
  ///
  ///
  ///

  ///theme value save
  bool darkTheme = false;

  ///saving theme value here
  saveThemeValue({required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('themeValue', value);
    // notifyListeners();
  }

  ///saving the language here
  saveSelectedLanguage(
      {required String value, languageSettingsTabIndex}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', value);
    notifyListeners();

    ///

    notifyListeners();
  }

  fetchValues() async {
    final prefs = await SharedPreferences.getInstance();

    ///fetching the value here
    darkTheme = prefs.getBool('themeValue')!;

    ///fetching selected language
    selectedLanguage = prefs.getString('selectedLanguage')!;
    switch (selectedLanguage) {
      case 'ur':
        {
          settingsLanguageTabIndex = 0;
        }
        break;
      case 'en':
        {
          settingsLanguageTabIndex = 1;
        }
        break;
      case 'ar':
        {
          settingsLanguageTabIndex = 2;
        }
        break;
    }

    ///fetching font size here
    fontSize = prefs.getDouble('fontSize')!.sp;
    notifyListeners();
  }

  defaultValues() async {
    final prefs = await SharedPreferences.getInstance();

    ///theme default value = false
    if (prefs.getBool('themeValue') == null) {
      await prefs.setBool('themeValue', false);

      darkTheme = prefs.getBool('themeValue')!;
    }

    ///if font size == null fall set to default
    if (prefs.getDouble('fontSize') == null) {
      await prefs.setDouble('fontSize', 13.5);

      fontSize = prefs.getDouble('fontSize')!.sp;
    }

    print('DEFAULT SETTINGS APPLIED');
  }

  ///*********************************
  ///FONT SIZE CHANGER
  ///**************************************
  double fontSize = 13.5.sp;

  ///[changeFontSize]= changes font size to user choose font size
  changeFontSize({required double value}) async {
    fontSize = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', value);
  }

  ///[resetFontSize]= resets font to default value
  resetFontSize() async {
    fontSize = 13.5.sp;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', 13.5);
    notifyListeners();
  }

  ///[fontSizeTextSampleSettings] fetches sample data to display in the font size settings
  List fontSizeSample = [];

  fontSizeTextSampleSettings() async {
    fontSizeSample = [];
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('selectedLanguage');
    // print(lang);
    if (lang == 'ur') {
      fontSizeSample = await services.rootBundle
          .loadString('jsonfile/urdu/ahadiths.json')
          .then((jsonData) => jsonDecode(jsonData)
              .toList()
              .where((e) => e['book_id'] == 87 && e['hadith_number'] == '1')
              .toList());
      notifyListeners();
    } else {
      fontSizeSample = await services.rootBundle
          .loadString('jsonfile/bukhari.json')
          .then((jsonData) => jsonDecode(jsonData)
              .toList()
              .where((e) => e['bookNumber'] == '1' && e['hadithNumber'] == '1')
              .toList());
      notifyListeners();
    }
  }

  bool hadithScreenIsOpen = false;

  ///******************************************** *****************************************************
  ///******************************************** *****************************************************
  ///===================================== APP VERSION ===============================================
  ///******************************************** *****************************************************
  ///******************************************** *****************************************************

  ///check update
  checkForUpdate({required context}) async {
    print('checking for updates');
    final newVersion = NewVersion();

    newVersion.showAlertIfNecessary(context: context);

    final status = await newVersion.getVersionStatus();
    print(status);
    // status.canUpdate // (true)
    // status.localVersion // (1.2.1)
    // status.storeVersion // (1.2.3)
    // status
    //     .appStoreLink // (https://itunes.apple.com/us/app/google/id284815942?mt=8)
  }

  String appVersion = '1.0.1';
}
