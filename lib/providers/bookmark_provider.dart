import 'dart:convert';

import 'package:ahadith_collection/providers/settings_provider.dart';
import 'package:ahadith_collection/screens/display_screens/book_names_screen.dart';
import 'package:ahadith_collection/screens/display_screens/collection_name_screen.dart';
import 'package:ahadith_collection/screens/display_screens/hadith_display_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'data_provider.dart';

class BookMarkProvider extends ChangeNotifier {
  var bookmarkedLanguage;
  var bookmarkedIndex;
  var bookmarkedBookNumber;
  var bookmarkedCollectionShortName;
  Map bookmarkedHadithData = {};

  ///this function collects the required information associated with the bookmarked hadith
  collectingBookmarkInfo(
      {selectedLanguage,
      collectionShortName,
      collectionFullName,
      bookName,
      selectedBookNumber,
      selectedUrduBookNumber,
      hadithIndex}) async {
    final prefs = await SharedPreferences.getInstance();

    ///structuring the bookmarked hadith data here
    bookmarkedHadithData = {
      'bookmarked_language': selectedLanguage,
      'collection_short_name': collectionShortName,
      'collection_full_name': collectionFullName,
      'selected_book_name': bookName,
      'selected_book_number': selectedBookNumber,
      'selected_urdu_book_number': selectedUrduBookNumber,
      'hadith_index': hadithIndex,
    };

    ///encoding bookmark data here cause there is no option to save a map into shared preferences
    ///so 1st convert the map into a string by encoding and then decode the data after fetching from shared preference

    bookmarkedLanguage = bookmarkedHadithData['bookmarked_language'];
    bookmarkedIndex = bookmarkedHadithData['hadith_index'];
    bookmarkedBookNumber = bookmarkedHadithData['selected_book_number'];
    bookmarkedCollectionShortName =
        bookmarkedHadithData['collection_short_name'];

    ///
    String encodedBookmarkData = jsonEncode(bookmarkedHadithData);
    await prefs.setString('bookmarkedHadith', encodedBookmarkData);

    notifyListeners();
  }

  ///this function fetches the permanent bookmarked saved data
  fetchBookmarkedHadithData(
      {required SettingsProvider settingsProvider,
      required DataProvider dataProvider,
      required BookMarkProvider bookMarkProvider,
      context}) async {
    final prefs = await SharedPreferences.getInstance();

    ///
    final encodedHadithData = prefs.getString('bookmarkedHadith');
    final data = jsonDecode(encodedHadithData!);

    ///changing language here *******
    settingsProvider.saveSelectedLanguage(value: data['bookmarked_language']);
    settingsProvider.updateSelectedLanguage(
        lang: data['bookmarked_language'], bookMarkProvider: bookMarkProvider);

    ///
    dataProvider.fetchCollections();
    dataProvider.selectedCollectionShortName = data['collection_short_name'];
    dataProvider.selectedBookNumber = data['selected_book_number'];
    // settingsProvider.updateSelectedLanguage(
    //     lang: data['bookmarked_language'], bookMarkProvider: bookMarkProvider);

    dataProvider.fetchHadithBooks();
    dataProvider.fetchHadith();
    notifyListeners();
  }

  ///navigate to last read(bookmarked) hadith
  navigateToBookmark(
      {context,
      required SettingsProvider settingsProvider,
      required BookMarkProvider bookMarkProvider,
      required DataProvider dataProvider}) async {
    ///
    final prefs = await SharedPreferences.getInstance();

    ///
    if (prefs.getString('bookmarkedHadith') == null) {
      ///snack bar to show no hadith marked yet
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'No Last reads marked yet',
          style: TextStyle(
            fontSize: 10.sp,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
    } else {
      fetchBookmarkedHadithData(
          bookMarkProvider: bookMarkProvider,
          settingsProvider: settingsProvider,
          dataProvider: dataProvider,
          context: context);

      ///
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: CollectionNameScreen(zoomDrawerController: null,)));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const BookNamesScreen()));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const HadithDisplayScreen()));
    }
  }

  ///
  /// fetch and assign bookmarked hadith data on restart
  ///
  fetchBookmarkedOnRestart() async {
    final prefs = await SharedPreferences.getInstance();

    ///
    if (prefs.getString('bookmarkedHadith') == null) {
      print('no bookamrks yet');
    } else {
      final encodedData = prefs.getString('bookmarkedHadith');
      final bookmarkedHadithData = jsonDecode(encodedData!);

      bookmarkedLanguage = bookmarkedHadithData['bookmarked_language'];
      bookmarkedIndex = bookmarkedHadithData['hadith_index'];
      bookmarkedBookNumber = bookmarkedHadithData['selected_book_number'];
      bookmarkedCollectionShortName =
          bookmarkedHadithData['collection_short_name'];
    }

    notifyListeners();
  }

  ///delete the bookmark (un=bookmark) if the bookmarked hadith is pressed again
  deleteBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    bookmarkedLanguage = null;
    bookmarkedIndex = null;
    bookmarkedBookNumber = null;
    bookmarkedCollectionShortName = null;
    notifyListeners();
  }
}
