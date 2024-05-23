import 'dart:convert';

import 'package:ahadith_collection/providers/settings_provider.dart';
import 'package:ahadith_collection/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' as services;
import 'package:html/parser.dart' show parse;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../meta_data/collection_names_meta_data.dart';

class DataProvider extends ChangeNotifier {
  List collectionNamesList = [];

  fetchCollections({context}) async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('selectedLanguage');
    // print(lang);
    if (lang == 'ur') {
      // print('urdu ===============');
      collectionNamesList = await services.rootBundle
          .loadString('jsonfile/urdu/ahadithsUrduCollectionName.json')
          .then((jsonData) => jsonDecode(jsonData).toList());
      notifyListeners();
    }

    if (lang == 'en' || lang == 'ar') {
      collectionNamesList = HadithMetaData().collectionNames;
      notifyListeners();
    }
  }

  ///***************************************
  ///FETCHING BOOKS HERE
  ///***************************************
  String selectedCollectionShortName = '';
  String selectedCollectionFullName = '';

  // List bookNamesList = [];

  fetchHadithBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('selectedLanguage');
    if (lang == 'ur') {
      // print('book urdu $bookNamesList');
      return await services.rootBundle
          .loadString('jsonfile/urdu/ahadithsBooksUrdu.json')
          .then((jsonData) => jsonDecode(jsonData)
              .toList()
              .where((e) => e['source'] == selectedCollectionShortName)
              .toList());
      notifyListeners();
    }
    // print('book ar en $bookNamesList');
    return await services.rootBundle
        .loadString('jsonfile/books/$selectedCollectionShortName.json')
        .then((jsonData) => jsonDecode(jsonData).toList()[0]['books']['data']);
    notifyListeners();
  }

  ///***************************************
  ///FETCHING HADITH HERE
  ///***************************************
  String selectedBookNumber = '';
  String selectedUrduBookNumber = '';
  String selectedBookName = '';

  // List hadithsList = [];

  fetchHadith() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('selectedLanguage');
    if (lang == 'ur') {
      return await services.rootBundle
          .loadString('jsonfile/urdu/ahadiths.json')
          .then((jsonData) => jsonDecode(jsonData)
              .toList()
              .where((e) => e['book_id'].toString() == selectedBookNumber)
              .toList());
      // notifyListeners();
    }
    return await services.rootBundle
        .loadString('jsonfile/$selectedCollectionShortName.json')
        .then((jsonData) => jsonDecode(jsonData)
            .toList()
            .where((e) => e['bookNumber'] == selectedBookNumber)
            .toList());
    // notifyListeners();
  }

  hadithFilter({text}) {
    if (text.toString().contains(':')) {
      return parse(text
          .toString()
          .substring(text.indexOf(':'))).documentElement!.text
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
          .replaceAll("</b>", '').trim();
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
          .replaceAll("</b>", '').trim();
    }
  }

  extractNarratorName({englishText}) {
    if (englishText.toString().contains(':')) {
      return parse(englishText
          .toString()
          .substring(0, englishText.indexOf(':'))).documentElement!.text
          .replaceAll('Narrated', '')
          .replaceAll('<p>', '')
          .replaceAll('</p>', '')
          // .replaceAll(':', '')
          .replaceAll('\n', '')
          .replaceAll('\r', '')
          .replaceAll('[prematn]', '')
          // .replaceAll('\n', '')
          .replaceAll('[/prematn]', '')
          // .replaceAll('\n', '')
          .replaceAll('[matn]', '')
          // .replaceAll('\n', '')
          .replaceAll('[/matn]', '')
          // .replaceAll('\n', '')
          .replaceAll('[narrator id=', '')
          // .replaceAll('\n', '')
          .replaceAll('[/narrator]', '')
          // .replaceAll('\n', '')
          .replaceAll('" tooltip="', '').trim();
    } else {
      return "";
    }
  }
}
