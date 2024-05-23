import 'package:ahadith_collection/components/custom_widgets.dart';
import 'package:ahadith_collection/screens/display_screens/hadith_display_screen.dart';
import 'package:ahadith_collection/screens/search_screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:html/parser.dart' show parse;
import '../../providers/data_provider.dart';
import '../../providers/search_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({Key? key}) : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    SearchProvider searchProvider = Provider.of<SearchProvider>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final cmw = constraints.maxWidth;
        final cmh = constraints.maxHeight;

        return Scaffold(
          backgroundColor: themeProvider.settingsScaffoldColor,
          appBar: CustomWidgets().customAppBar(
              themeProvider: themeProvider,
              appbarColor: themeProvider.settingsAppBarColor,
              context: context,
              cmh: cmh,
              cmw: cmw,
              simpleStringTitle: 'Search Result',
              searchIcon: false,
              settingsProvider: settingsProvider),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ///collection full name
                Padding(
                  padding: EdgeInsets.only(top: cmh * 0.015),
                  child: Text(
                    searchProvider.searchCollectionFullName,
                    style: searchProvider.changeStyleAccordingToLanguage(),
                  ),
                ),

                ///***************************
                ///Chapter name and number is here
                ///***************************

                ///chapter number is here
                chapterNumberDisplay(
                    cmw, cmh, themeProvider, settingsProvider, searchProvider),

                ///chapter name is here
                Directionality(
                  textDirection: searchProvider.language == Language.urdu ||
                          searchProvider.language == Language.arabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: cmw * 0.05,
                      right: cmw * 0.05,
                      bottom: cmh * 0.01,
                    ),
                    child: Text(
                      searchProvider.language == Language.urdu
                          ? searchProvider.selectedSearchResult['title']
                          : searchProvider.language == Language.arabic
                              ? searchProvider
                                  .selectedSearchResult['arabicBabName']
                              : searchProvider
                                  .selectedSearchResult['englishBabName']
                                  .toString(),
                      style: searchProvider.language == Language.urdu
                          ? TextStyle(
                              color: Colors.teal,
                              // fontWeight: FontWeight.w600,
                              fontSize: 12.1.sp,
                              fontFamily: 'Noto')
                          : searchProvider.language == Language.arabic
                              ? TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.1.sp,
                                  fontFamily: 'Uthmani_hafs_official')
                              : TextStyle(
                                  fontSize: settingsProvider.fontSize - 2.3,
                                  color: Colors.teal),
                    ),
                  ),
                ),

                ///===============
                /// Hadith Card is here
                ///=====================
                hadithCard(
                  cmh: cmh,
                  cmw: cmw,
                  themeProvider: themeProvider,
                  dataProvider: dataProvider,
                  settingsProvider: settingsProvider,
                  searchProvider: searchProvider,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///****************************************************
  /// =====================
  /// Custom Widgets ===========
  /// ========================
  ///*****************************************************
  Widget hadithCard({
    required SearchProvider searchProvider,
    cmh,
    cmw,
    required ThemeProvider themeProvider,
    required DataProvider dataProvider,
    required SettingsProvider settingsProvider,
  }) {
    return Directionality(
      textDirection: searchProvider.language == Language.urdu ||
              searchProvider.language == Language.arabic
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.teal,
                spreadRadius: -cmh * 0.041,
                blurRadius: cmh * 0.021)
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              width: cmw,
              child: Padding(
                padding: EdgeInsets.only(
                  // bottom: cmh * 0.015,
                  left: cmw * 0.05,
                  top: cmh * 0.015,
                  right: cmw * 0.05,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(cmh * 0.025),
                    topRight: Radius.circular(cmh * 0.025),
                  ),
                  child: Container(
                    ///Hadith Box Color
                    decoration: BoxDecoration(
                        color: themeProvider.hadithScreenCardColor),
                    child: Padding(
                      padding: EdgeInsets.all(cmh * 0.015),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (dataProvider.selectedCollectionShortName !=
                              'hisn')
                            Column(
                              children: [
                                ///***************************
                                ///Narrator displayed is here
                                ///***************************
                                Padding(
                                  padding: EdgeInsets.all(cmh * 0.01),
                                  child: Text(
                                    'Narrated by',
                                    style: TextStyle(
                                        fontSize: 11.sp, color: Colors.teal),
                                  ),
                                ),

                                if (dataProvider.extractNarratorName(
                                          englishText: searchProvider
                                                  .selectedSearchResult[
                                              'englishText'],
                                        ) !=
                                        '' &&
                                    (searchProvider.language == Language.urdu ||
                                        searchProvider.language !=
                                            Language.arabic))
                                  Container(
                                    padding:
                                        EdgeInsets.only(bottom: cmh * 0.01),
                                    child: Text(
                                      dataProvider.extractNarratorName(
                                        englishText:
                                            searchProvider.selectedSearchResult[
                                                'englishText'],
                                      ),
                                      style: GoogleFonts.roboto(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                SizedBox(
                                  height: cmh * 0.01,
                                ),

                                ///***************************
                                ///Hadith displayed is here
                                ///***************************

                                Text(
                                  dataProvider.hadithFilter(
                                      text: searchProvider.language ==
                                              Language.urdu
                                          ? searchProvider.selectedSearchResult[
                                              'hadith_text']
                                          : searchProvider.language ==
                                                  Language.arabic
                                              ? searchProvider
                                                      .selectedSearchResult[
                                                  "arabicText"]
                                              : searchProvider
                                                      .selectedSearchResult[
                                                  "englishText"]),
                                  style: searchProvider
                                      .changeHadithStyleAccordingToLanguage(
                                          searchLanguage:
                                              searchProvider.language,
                                          settingsProvider: settingsProvider,
                                          themeProvider: themeProvider),
                                  textAlign: TextAlign.justify,
                                ),

                                ///
                              ],
                            ),

                          ///for hisn
                          if (dataProvider.selectedCollectionShortName ==
                              'hisn')
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text(
                                    parse(searchProvider
                                            .selectedSearchResult['arabicText'])
                                        .documentElement!
                                        .text
                                        .toString()
                                        .replaceAll('\n', ''),
                                    style: TextStyle(
                                      color: Colors.teal,

                                      // fontWeight:
                                      //     FontWeight
                                      //         .w600,
                                      fontSize: settingsProvider.fontSize + 11,
                                      fontFamily: 'Uthmani_hafs_official',
                                    ),
                                    // textAlign: TextAlign.right,
                                  ),
                                ),
                                Text(
                                  parse(searchProvider
                                          .selectedSearchResult['englishText'])
                                      .documentElement!
                                      .text
                                      .toString(),
                                  style: searchProvider
                                      .changeHadithStyleAccordingToLanguage(
                                          searchLanguage:
                                              searchProvider.language,
                                          settingsProvider: settingsProvider,
                                          themeProvider: themeProvider),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: cmh * 0.015,
                left: cmw * 0.05,
                right: cmw * 0.05,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(cmh * 0.025),
                  bottomLeft: Radius.circular(cmh * 0.025),
                ),
                child: Container(
                  padding: EdgeInsets.only(
                    top: cmh * 0.015,
                    bottom: cmh * 0.015,
                    left: cmw * 0.03,
                    right: cmw * 0.03,
                  ),
                  color: themeProvider.hadithInfoBoxColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                references(
                                    title: 'Reference', cmh: cmh, cmw: cmw)
                              ],
                            ),
                          ),
                          SizedBox(width: cmw * 0.07),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Expanded(
                                  child: referencesDynamic(
                                    reference: searchProvider
                                        .searchCollectionFullName
                                        .toString(),
                                    dataProvider: dataProvider,
                                    cmw: cmw,
                                    cmh: cmh,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: cmh * 0.005,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                references(
                                    title: 'Hadith No', cmh: cmh, cmw: cmw)
                              ],
                            ),
                          ),
                          SizedBox(width: cmw * 0.07),

                          ///if urdu display this widget
                          if (searchProvider.language == Language.urdu)
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: referencesDynamic(
                                        reference: searchProvider
                                                .selectedSearchResult[
                                                    'hadith_text']
                                                .contains(': حديث نمبر')
                                            ? searchProvider
                                                .selectedSearchResult[
                                                    'hadith_text']
                                                .toString()
                                                .substring(searchProvider
                                                    .selectedSearchResult[
                                                        'hadith_text']
                                                    .toString()
                                                    .indexOf('حديث نمبر'))
                                            : searchProvider
                                                    .selectedSearchResult[
                                                'hadith_number'],
                                        dataProvider: dataProvider,
                                        cmh: cmh,
                                        cmw: cmw),
                                  ),
                                ],
                              ),
                            ),

                          ///*******************************************
                          ///if english or arabic display this widget
                          ///*****************************************
                          if (searchProvider.language != Language.urdu)
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: referencesDynamic(
                                        reference:
                                            searchProvider.selectedSearchResult[
                                                'hadithNumber'],
                                        dataProvider: dataProvider,
                                        cmh: cmh,
                                        cmw: cmw),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: cmh * 0.003,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                references(
                                    title: 'In Book Reference',
                                    cmh: cmh,
                                    cmw: cmw),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                SizedBox(width: cmw * .047),
                                Expanded(
                                  child: referencesDynamic(
                                      reference: 'Book ' +
                                          ((searchProvider.language == Language.urdu
                                                  ? searchProvider.selectedSearchResult['book_id']
                                                      .toString()
                                                  : searchProvider.selectedSearchResult[
                                                      'bookNumber']) +
                                              ' , ' +
                                              'Hadith ' +
                                              (searchProvider.language ==
                                                          Language.urdu
                                                      ? searchProvider.selectedSearchResult['hadith_text']
                                                              .contains(
                                                                  ': حديث نمبر')
                                                          ? searchProvider
                                                              .selectedSearchResult[
                                                                  'hadith_text']
                                                              .toString()
                                                              .substring(searchProvider
                                                                  .selectedSearchResult[
                                                                      'hadith_text']
                                                                  .toString()
                                                                  .indexOf(
                                                                      'حديث نمبر'))
                                                          : searchProvider
                                                                  .selectedSearchResult[
                                                              'hadith_number']
                                                      : searchProvider
                                                          .selectedSearchResult['hadithNumber'])
                                                  .toString()),
                                      dataProvider: dataProvider,
                                      cmh: cmh,
                                      cmw: cmw),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: cmh * 0.003,
                      ),
                      if (searchProvider.language != Language.urdu)
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  references(title: 'Urn', cmh: cmh, cmw: cmw),
                                ],
                              ),
                            ),
                            SizedBox(width: cmw * 0.07),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: referencesDynamic(
                                      cmw: cmw,
                                      cmh: cmh,
                                      dataProvider: dataProvider,
                                      reference: searchProvider.language ==
                                              Language.arabic
                                          ? searchProvider
                                              .selectedSearchResult["arabicURN"]
                                          : searchProvider.selectedSearchResult[
                                                  "englishURN"]
                                              .toString(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: cmh * 0.003,
                      ),
                      if (searchProvider.language != Language.urdu)
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  references(
                                      title: 'Last Updated',
                                      cmh: cmh,
                                      cmw: cmw),
                                ],
                              ),
                            ),
                            SizedBox(width: cmw * 0.07),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  referencesDynamic(
                                    reference: searchProvider
                                        .selectedSearchResult['last_updated']
                                        .toString(),
                                    dataProvider: dataProvider,
                                    cmh: cmh,
                                    cmw: cmw,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: cmh * 0.003,
                      ),
                      if (searchProvider.language != Language.urdu &&
                          (searchProvider.selectedSearchResult["arabicgrade1"]
                                  .toString()
                                  .isNotEmpty ||
                              searchProvider
                                  .selectedSearchResult['englishgrade1']
                                  .toString()
                                  .isNotEmpty))
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  references(
                                      title: 'Grade', cmw: cmw, cmh: cmh),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: cmw * 0.07,
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    /// todo***********************
                                    ':  ' +
                                        (searchProvider.language ==
                                                Language.arabic
                                            ? searchProvider
                                                    .selectedSearchResult[
                                                "arabicgrade1"]
                                            : searchProvider
                                                .selectedSearchResult[
                                                    'englishgrade1']
                                                .toString()),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11.sp),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding referencesDynamic(
      {required DataProvider dataProvider,
      required reference,
      required cmh,
      required cmw}) {
    return Padding(
      padding: EdgeInsets.only(bottom: cmh * 0.003),
      child: Text(
        ':  $reference',
        style: TextStyle(fontSize: 10.1.sp),
      ),
    );
  }

  Padding references({required String title, required cmh, required cmw}) =>
      Padding(
        padding: EdgeInsets.only(bottom: cmh * 0.003),
        child: Text(
          title,
          style: TextStyle(fontSize: 10.1.sp),
        ),
      );

  ///*******************************
  ///chapter number / book number / chapter name  display widget
  ///**********************************
  Padding chapterNumberDisplay(
      double cmw,
      double cmh,
      ThemeProvider themeProvider,
      SettingsProvider settingsProvider,
      SearchProvider searchProvider) {
    return Padding(
      padding: EdgeInsets.only(
          left: cmw * 0.05,
          right: cmw * 0.05,
          top: cmh * 0.035,
          bottom: cmh * 0.009),
      child: Column(
        children: [
          ///Book id is here
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'BOOK NO  ',
                  style: TextStyle(
                    color: themeProvider.hadithScreenFontColor,
                    fontSize: 11.sp,
                  ),
                ),
                WidgetSpan(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4.3),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: cmh * .011,
                      color: themeProvider.hadithScreenFontColor,
                    ),
                  ),
                ),
                const TextSpan(
                  text: ' ',
                ),

                /// displaying BOOK NUMBER here if not urdu
                if (searchProvider.language != Language.urdu)
                  TextSpan(
                      text: searchProvider.selectedSearchResult['bookNumber']
                          .toString(),
                      style: TextStyle(
                          color: themeProvider.hadithScreenFontColor,
                          fontWeight: FontWeight.bold)),

                /// displaying ChapterID(urdu book number) here (for urdu)
                if (searchProvider.language == Language.urdu)
                  TextSpan(
                      text: searchProvider.selectedSearchResult['book_id']
                          .toString(),
                      style: TextStyle(
                          color: themeProvider.hadithScreenFontColor,
                          fontWeight: FontWeight.bold)),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: cmh * 0.015,
          ),

          /// Chapter id is here
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Chapter ID ',
                  style: TextStyle(
                    color: themeProvider.hadithScreenFontColor,
                    fontSize: 11.sp,
                  ),
                ),
                WidgetSpan(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4.3),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: cmh * .011,
                      color: themeProvider.hadithScreenFontColor,
                    ),
                  ),
                ),
                const TextSpan(
                  text: ' ',
                ),

                /// displaying ChapterID here (urdu database has no chapter id)
                if (searchProvider.language != Language.urdu)
                  TextSpan(
                      text: searchProvider.selectedSearchResult['babID']
                          .truncate()
                          .toString(),
                      style: TextStyle(
                          color: themeProvider.hadithScreenFontColor,
                          fontWeight: FontWeight.bold)),
              ],
            ),
            // textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
