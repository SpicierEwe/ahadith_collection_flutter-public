import 'dart:convert';

import 'package:ahadith_collection/providers/settings_provider.dart';
import 'package:ahadith_collection/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart' show parse;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../meta_data/collection_names_meta_data.dart';
import '../screens/search_screen/search_screen.dart';

class SearchProvider extends ChangeNotifier {
  List collectionNamesList = [];
  int searchLanguageTabIndex = 0;
  Language? language = Language.english;

  changeTabIndex({required int value}) {
    searchLanguageTabIndex = value;
    notifyListeners();
  }

  fetchCollections(
      {context, required bool fetchInInitState, searchLocalLanguage}) async {
    ///init state fetch (in the init state the language is auto fetched from permanent memory)
    if (fetchInInitState == true) {
      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString('selectedLanguage');
      // print(lang);

      if (lang == 'ur') {
        // print('urdu ===============');
        language = Language.urdu;
        collectionNamesList = await services.rootBundle
            .loadString('jsonfile/urdu/ahadithsUrduCollectionName.json')
            .then((jsonData) => jsonDecode(jsonData).toList());

        notifyListeners();
      }

      if (lang == 'en') {
        language = Language.english;
        // print('lang fectch  $lang');
        collectionNamesList = HadithMetaData().collectionNames;
        notifyListeners();
      }
      if (lang == 'ar') {
        language = Language.arabic;
        // print('lang fectch  $lang');
        collectionNamesList = HadithMetaData().collectionNames;
        notifyListeners();
      }
    }

    ///here is when not fetching in init state then the lang is fetched which is
    ///locally selected by the user from the search screen
    if (fetchInInitState == false && searchLocalLanguage != null) {
      // language = Language.urdu;
      // print('seconfsgsg ');
      switch (searchLocalLanguage) {
        case Language.urdu:
          {
            collectionNamesList = await services.rootBundle
                .loadString('jsonfile/urdu/ahadithsUrduCollectionName.json')
                .then((jsonData) => jsonDecode(jsonData).toList());
            notifyListeners();
          }
          break;
        case Language.english:
          {
            // print('im english fetcher');
            // print('im collection names list  = ' +
            //     collectionNamesList.toString());
            collectionNamesList = HadithMetaData().collectionNames;
            // print('im collection names list  = ' +
            //     collectionNamesList.toString());
            notifyListeners();
          }
          break;
        case Language.arabic:
          {
            collectionNamesList = HadithMetaData().collectionNames;
            notifyListeners();
          }
      }
    }
  }

  defaultSearchSelectedCollectionName({
    required isInitState,
    localSearchLanguage,
  }) async {
    if (isInitState == true) {
      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString('selectedLanguage');

      switch (lang) {
        case 'en':
          {
            searchCollectionShortName = 'bukhari';
            searchCollectionFullName = 'Sahih al-Bukhari';
            searchLanguageTabIndex = 1;
            notifyListeners();
          }
          break;
        case 'ar':
          {
            searchCollectionShortName = 'bukhari';
            searchCollectionFullName = 'صحيح البخاري';
            searchLanguageTabIndex = 2;
            notifyListeners();
          }
          break;
        case 'ur':
          {
            searchCollectionShortName = 'صحیح بخاری';
            searchCollectionFullName = 'صحیح بخاری';
            searchLanguageTabIndex = 0;
            notifyListeners();
          }
      }
    } else {
      switch (localSearchLanguage) {
        case Language.english:
          {
            searchCollectionShortName = 'bukhari';
            searchCollectionFullName = 'Sahih al-Bukhari';
            notifyListeners();
          }
          break;
        case Language.arabic:
          {
            searchCollectionShortName = 'bukhari';
            searchCollectionFullName = 'صحيح البخاري';
            notifyListeners();
          }
          break;
        case Language.urdu:
          {
            searchCollectionShortName = 'صحیح بخاری';
            searchCollectionFullName = 'صحیح بخاری';
            notifyListeners();
          }
      }
    }
  }

  changeStyleAccordingToLanguage() {
    if (language == Language.english) {
      return TextStyle(fontSize: 13.sp, color: Colors.teal);
    }
    if (language == Language.arabic) {
      return TextStyle(fontSize: 15.sp, color: Colors.teal);
    }
    if (language == Language.urdu) {
      return TextStyle(fontFamily: 'Noto', fontSize: 13.sp, color: Colors.teal);
    }
  }

  /// *************************************** SEARCHING IS  HANDLE BY FUNCTIONS BELOW
  ///==============================================
  String searchCollectionShortName = '';
  String searchCollectionFullName = '';

  bool showSearchFilter = true;
  bool showSearchResultBox = false;

  toggleShowSearchFilter({required bool value}) {
    showSearchFilter = value;
    notifyListeners();
  }

  toggleShowSearchResultBox({required bool value}) {
    showSearchResultBox = value;
    notifyListeners();
  }

  var searchedHadithNumber;

  updateSearchedHadithNumber({value}) {
    searchedHadithNumber = value;
    notifyListeners();
  }

  ///these are the lists where search results are stored before displaying
  List a = [];
  List b = [];

  resetHadithData() async {
    a = [];
    b = [];
    notifyListeners();
  }

  searchHadith() async {
    // print(language);
    if (language == Language.urdu) {
      print('i urdu search engine');
      a = await services.rootBundle
          .loadString(
              'jsonfile/urdu/urduSearchable/$searchCollectionShortName.json')
          .then((jsonData) => jsonDecode(jsonData)
              .where((e) =>
                  e['hadith_number'].toString() ==
                  searchedHadithNumber.toString())
              .toList());

      b = await services.rootBundle
          .loadString(
              'jsonfile/urdu/urduSearchable/$searchCollectionShortName.json')
          .then((jsonData) => jsonDecode(jsonData)
              .toList()
              .where((e) =>
                  e['hadith_number']
                      .toString()
                      .contains('$searchedHadithNumber') &&
                  e['hadithNumber'].toString() !=
                      searchedHadithNumber.toString())
              .toList());

      return (a + b);
    }

    a = await services.rootBundle
        .loadString('jsonfile/$searchCollectionShortName.json')
        .then((jsonData) => jsonDecode(jsonData)
            .toList()
            .where((e) =>
                e['hadithNumber'].toString() == searchedHadithNumber.toString())
            .toList());
    b = await services.rootBundle
        .loadString('jsonfile/$searchCollectionShortName.json')
        .then((jsonData) => jsonDecode(jsonData)
            .toList()
            .where((e) =>
                e['hadithNumber']
                    .toString()
                    .contains('$searchedHadithNumber') &&
                e['hadithNumber'].toString() != searchedHadithNumber.toString())
            .toList());

    return (a + b);
  }

  ///selectedSearchResult updates and displays the opened result on the search result screen
  Map selectedSearchResult = {};

  updateSelectedSearchResult({required Map value}) {
    selectedSearchResult = value;

    print(selectedSearchResult);
    notifyListeners();
  }

  /// searchHadith filter removes html & tags
  searchedHadithFilter({text}) {
    if (text.toString().contains(':')) {
      return parse(text)
          .documentElement!
          .text
          .replaceAll('Narrated', '')
          .replaceAll('<p>', '')
          .replaceAll('</p>', '')
          .replaceAll(':', '')
          .replaceAll('\n', '')
          .replaceAll('[prematn]', '')
          .replaceAll('[/prematn]', '')
          .replaceAll('[matn]', '')
          .replaceAll('[/matn]', '')
          .replaceAll('[narrator id=', '')
          .replaceAll('[/narrator]', '')
          .replaceAll('" tooltip="', '')
          .replaceAll('Narrated', '')
          .replaceAll(':', '')
          .replaceAll('[prematn]', '')
          .replaceAll('[/prematn]', '')
          .replaceAll('[matn]', '')
          .replaceAll('[/matn]', '')
          .replaceAll('[narrator id=', '')
          .replaceAll('[/narrator]', '')
          .replaceAll('" tooltip="', '')
          .replaceAll('<br>', '')
          .replaceAll("</br>", '')
          .replaceAll('<b>', '')
          .replaceAll("</b>", '')
          .trim();
    } else {
      return parse(text)
          .documentElement!
          .text
          .toString()
          .replaceAll('\n', '')
          .replaceAll('Narrated', '')
          .replaceAll('<p>', '')
          .replaceAll('</p>', '')
          .replaceAll(':', '')
          .replaceAll('\n', '')
          .replaceAll('[prematn]', '')
          .replaceAll('[/prematn]', '')
          .replaceAll('[matn]', '')
          .replaceAll('[/matn]', '')
          .replaceAll('[narrator id=', '')
          .replaceAll('[/narrator]', '')
          .replaceAll('" tooltip="', '')
          .replaceAll('Narrated', '')
          .replaceAll(':', '')
          .replaceAll('[prematn]', '')
          .replaceAll('[/prematn]', '')
          .replaceAll('[matn]', '')
          .replaceAll('[/matn]', '')
          .replaceAll('[narrator id=', '')
          .replaceAll('[/narrator]', '')
          .replaceAll('" tooltip="', '')
          .replaceAll('<br>', '')
          .replaceAll("</br>", '')
          .replaceAll('<b>', '')
          .replaceAll("</b>", '')
          .trim();
    }
  }

  /// change style according to selected searched language
  changeHadithStyleAccordingToLanguage(
      {required searchLanguage,
      required ThemeProvider themeProvider,
      required SettingsProvider settingsProvider}) {
    if (searchLanguage == Language.urdu) {
      return TextStyle(
          fontFamily: 'Noto',
          fontSize: settingsProvider.fontSize,

          // fontSize: cmh* 0.023,
          color: themeProvider.hadithScreenFontColor);
    }
    if (searchLanguage == Language.arabic) {
      return TextStyle(
        color: themeProvider.hadithScreenFontColor,
        // fontWeight:
        //     FontWeight
        //         .w600,
        fontSize: settingsProvider.fontSize + 6.9,
        fontFamily: 'Uthmani_hafs_official',
      );
    }
    return TextStyle(
        fontFamily: 'AcuminPro',
        color: themeProvider.hadithScreenFontColor,
        fontSize: settingsProvider.fontSize,
        height: 1.5);
  }
}
