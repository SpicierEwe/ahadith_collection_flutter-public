import 'package:ahadith_collection/providers/bookmark_provider.dart';
import 'package:ahadith_collection/screens/display_screens/contact_us_screens/hadith_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart' show parse;
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';

import '../../components/custom_widgets.dart';
import '../../providers/data_provider.dart';
import '../../providers/miscellaneous_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';

class HadithDisplayScreen extends StatefulWidget {
  const HadithDisplayScreen({Key? key}) : super(key: key);

  @override
  State<HadithDisplayScreen> createState() => _HadithDisplayScreenState();
}

class _HadithDisplayScreenState extends State<HadithDisplayScreen> {
  ///scroll controller
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    Provider.of<SettingsProvider>(context, listen: false).hadithScreenIsOpen =
        true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    BookMarkProvider bookMarkProvider = Provider.of<BookMarkProvider>(context);
    MiscellaneousProvider miscellaneousProvider =
        Provider.of<MiscellaneousProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        settingsProvider.hadithScreenIsOpen = false;
        Navigator.pop(context, true);
        return true;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cmh = constraints.maxHeight;
          final cmw = constraints.maxWidth;

          return Scaffold(
              backgroundColor: themeProvider.hadithScreenScaffoldColor,

              ///***********************
              ///custom appbar
              ///***********************
              appBar: CustomWidgets().customAppBar(
                themeProvider: themeProvider,
                searchIcon: false,
                appbarColor: themeProvider.settingsAppBarColor,
                context: context,
                cmh: cmh,
                cmw: cmw,
                settingsProvider: settingsProvider,
                dynamicTitleWidget: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: settingsProvider.selectedLanguage == 'ar'
                            ? dataProvider.selectedCollectionFullName
                            : dataProvider.selectedCollectionShortName
                                .toString(),
                        style: GoogleFonts.josefinSans(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const WidgetSpan(
                        child: SizedBox(
                          width: 5,
                        ),
                      ),
                      TextSpan(
                        text: 'BOOK',
                        style: GoogleFonts.josefinSans(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const WidgetSpan(
                        child: SizedBox(
                          width: 5,
                        ),
                      ),
                      TextSpan(
                        text: (settingsProvider.selectedLanguage == 'ur'
                                ? dataProvider.selectedUrduBookNumber.toString()
                                : dataProvider.selectedBookNumber)
                            .toString(),
                        style: GoogleFonts.josefinSans(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  style: GoogleFonts.josefinSans(
                      fontWeight: FontWeight.bold, fontSize: 15.sp),
                ),
              ),
              body: FutureBuilder(
                future: dataProvider.fetchHadith(),
                builder: (context, AsyncSnapshot snapshot) {
                  final snapshotData = snapshot.data;
                  final selectedLanguage = settingsProvider.selectedLanguage;

                  if (!snapshot.hasData) {
                    return CustomWidgets()
                        .customProgressIndicator(themeProvider: themeProvider);
                  }
                  return ScrollablePositionedList.builder(

                      ///todo
                      ///controlling scroll here
                      initialScrollIndex: (settingsProvider.selectedLanguage ==
                                  bookMarkProvider.bookmarkedLanguage &&
                              dataProvider.selectedCollectionShortName ==
                                  bookMarkProvider
                                      .bookmarkedCollectionShortName &&
                              dataProvider.selectedBookNumber ==
                                  bookMarkProvider.bookmarkedBookNumber)
                          ? bookMarkProvider.bookmarkedIndex
                          : 0,
                      itemScrollController: itemScrollController,
                      itemPositionsListener: itemPositionsListener,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Directionality(
                                textDirection:
                                    settingsProvider.selectedLanguage == 'ar' ||
                                            settingsProvider.selectedLanguage ==
                                                'ur'
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ///book number & name is displayed here if index ==0
                                    if (index == 0)
                                      bookNumberNameDisplay(
                                          cmw,
                                          cmh,
                                          themeProvider,
                                          settingsProvider,
                                          dataProvider,
                                          index),

                                    chapterNumberDisplay(
                                        cmw,
                                        cmh,
                                        themeProvider,
                                        settingsProvider,
                                        snapshot,
                                        index),

                                    ///***************************
                                    ///Chapter name is here
                                    ///***************************
                                    if (snapshot.data[index][settingsProvider
                                                            .selectedLanguage ==
                                                        'ur'
                                                    ? 'title'
                                                    : settingsProvider
                                                                .selectedLanguage ==
                                                            'ar'
                                                        ? 'arabicBabName'
                                                        : 'englishBabName']
                                                .toString() !=
                                            'null' ||
                                        snapshot.data[index][settingsProvider
                                                            .selectedLanguage ==
                                                        'ur'
                                                    ? 'title'
                                                    : settingsProvider
                                                                .selectedLanguage ==
                                                            'ar'
                                                        ? 'arabicBabName'
                                                        : 'englishBabName']
                                                .toString() ==
                                            '')
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: cmw * 0.05,
                                          right: cmw * 0.05,
                                          bottom: cmh * 0.01,
                                        ),
                                        child: Text(
                                          snapshot.data[index][settingsProvider
                                                          .selectedLanguage ==
                                                      'ur'
                                                  ? 'title'
                                                  : settingsProvider
                                                              .selectedLanguage ==
                                                          'ar'
                                                      ? 'arabicBabName'
                                                      : 'englishBabName']
                                              .toString(),
                                          style: selectedLanguage == 'ur'
                                              ? TextStyle(
                                                  color: Colors.teal,
                                                  // fontWeight: FontWeight.w600,
                                                  fontSize: 12.1.sp,
                                                  fontFamily: 'Noto')
                                              : selectedLanguage == 'ar'
                                                  ? TextStyle(
                                                      color: Colors.teal,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16.1.sp,
                                                      fontFamily:
                                                          'Uthmani_hafs_official')
                                                  : TextStyle(
                                                      fontSize: settingsProvider
                                                              .fontSize -
                                                          2.3,
                                                      color: Colors.teal),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              hadithCard(
                                  cmh,
                                  cmw,
                                  themeProvider,
                                  bookMarkProvider,
                                  dataProvider,
                                  snapshot,
                                  index,
                                  settingsProvider,
                                  selectedLanguage,
                                  snapshotData),

                              ///Hadith bottom options
                              Container(
                                padding: EdgeInsets.only(
                                  left: cmw * 0.05,
                                  right: cmw * 0.05,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ///****************************
                                    ///copy to clipboard icon
                                    ///****************************
                                    HadithCardIcons(
                                        cmh: cmh,
                                        cmw: cmw,
                                        child: Icons.copy,
                                        onPressedFunction: () =>
                                            miscellaneousProvider.copyHadith(
                                                snapshotData: snapshotData,
                                                dataProvider: dataProvider,
                                                context: context,
                                                snapshot: snapshot,
                                                settingsProvider:
                                                    settingsProvider,
                                                themeProvider: themeProvider,
                                                index: index)),

                                    ///****************************
                                    ///share icon
                                    ///****************************
                                    HadithCardIcons(
                                      onPressedFunction: () =>
                                          miscellaneousProvider.shareHadith(
                                              snapshotData: snapshotData,
                                              dataProvider: dataProvider,
                                              context: context,
                                              snapshot: snapshot,
                                              settingsProvider:
                                                  settingsProvider,
                                              themeProvider: themeProvider,
                                              index: index),
                                      cmh: cmh,
                                      cmw: cmw,
                                      child: Icons.share,
                                    ),

                                    ///*********************************
                                    ///report hadith button
                                    ///***********************************
                                    GestureDetector(
                                      onTap: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HadithReport(
                                                      hadithData: snapshotData),
                                            ));
                                      },
                                      child: Container(
                                        // margin: EdgeInsets.only(
                                        //   right: cmw * 0.15,
                                        // ),
                                        padding: EdgeInsets.only(
                                          top: cmh * 0.005,
                                          bottom: cmh * 0.007,
                                          left: cmw * 0.02,
                                          right: cmw * 0.02,
                                        ),
                                        decoration: BoxDecoration(
                                          color: settingsProvider.darkTheme
                                              ? Colors.teal.withOpacity(.75)
                                              : Colors.teal.withOpacity(.49),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft:
                                                Radius.circular(cmh * 0.005),
                                            bottomRight:
                                                Radius.circular(cmh * 0.005),
                                          ),
                                        ),
                                        // width: cmw * 0.05,

                                        child: Text('Report',
                                            style: TextStyle(
                                              fontSize: 10.5.sp,
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      width: cmw * 0.1,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: cmh * 0.015,
                              ),
                            ],
                          ));
                },
              ));
        },
      ),
    );
  }

  Widget hadithCard(
      double cmh,
      double cmw,
      ThemeProvider themeProvider,
      BookMarkProvider bookmarkProvider,
      DataProvider dataProvider,
      AsyncSnapshot<dynamic> snapshot,
      int index,
      SettingsProvider settingsProvider,
      String selectedLanguage,
      snapshotData) {
    return Stack(
      children: [
        Directionality(
          textDirection: settingsProvider.selectedLanguage == 'ar' ||
                  settingsProvider.selectedLanguage == 'ur'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: settingsProvider.darkTheme
                  ? null
                  : [
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
                          // color: Color(0xff212121),
                          color: themeProvider.hadithScreenCardColor,
                        ),
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
                                            fontSize: 11.sp,
                                            color: Colors.teal),
                                      ),
                                    ),

                                    if (dataProvider.extractNarratorName(
                                              englishText: snapshot.data[index]
                                                      ['englishText']
                                                  .toString(),
                                            ) !=
                                            '' &&
                                        (settingsProvider.selectedLanguage ==
                                                'ur' ||
                                            settingsProvider.selectedLanguage !=
                                                'ar'))
                                      Container(
                                        padding:
                                            EdgeInsets.only(bottom: cmh * 0.01),
                                        child: Text(
                                          dataProvider.extractNarratorName(
                                            englishText: snapshot.data[index]
                                                    ['englishText']
                                                .toString(),
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
                                      height: cmh * 0.0075,
                                    ),

                                    ///***************************
                                    ///Hadith displayed is here
                                    ///***************************

                                    Text(
                                      dataProvider.hadithFilter(
                                          text: snapshot
                                              .data[index][settingsProvider
                                                      .selectedLanguage ==
                                                  'ur'
                                              ? 'hadith_text'
                                              : settingsProvider
                                                          .selectedLanguage ==
                                                      'ar'
                                                  ? "arabicText"
                                                  : "englishText"]),
                                      style: settingsProvider
                                          .changeStyleAccordingToLanguage(
                                              settingsProvider:
                                                  settingsProvider,
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Text(
                                        parse(snapshotData[index]['arabicText'])
                                            .documentElement!
                                            .text
                                            .toString()
                                            .replaceAll('\n', ''),
                                        style: TextStyle(
                                          color: Colors.teal,

                                          // fontWeight:
                                          //     FontWeight
                                          //         .w600,
                                          fontSize:
                                              settingsProvider.fontSize + 11,
                                          fontFamily: 'Uthmani_hafs_official',
                                        ),
                                        // textAlign: TextAlign.right,
                                      ),
                                    ),
                                    Text(
                                      parse(snapshotData[index]['englishText'])
                                          .documentElement!
                                          .text
                                          .toString(),
                                      style: settingsProvider
                                          .changeStyleAccordingToLanguage(
                                              settingsProvider:
                                                  settingsProvider,
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

                ///reference box is here
                Padding(
                  padding: EdgeInsets.only(
                    // bottom: cmh * 0.015,
                    left: cmw * 0.05,
                    right: cmw * 0.05,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(cmh * 0.025),
                      bottomLeft: Radius.circular(cmh * 0.025),
                    ),
                    child: Container(
                      color: themeProvider.hadithInfoBoxColor,
                      padding: EdgeInsets.only(
                        top: cmh * 0.015,
                        bottom: cmh * 0.015,
                        left: cmw * 0.03,
                        right: cmw * 0.03,
                      ),
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
                                        reference: dataProvider
                                            .selectedCollectionFullName
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
                              if (selectedLanguage == 'ur')
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: referencesDynamic(
                                            reference: snapshotData[index]
                                                        ['hadith_text']
                                                    .contains(': حديث نمبر')
                                                ? snapshotData[index]
                                                        ['hadith_text']
                                                    .toString()
                                                    .substring(
                                                        snapshotData[index]
                                                                ['hadith_text']
                                                            .toString()
                                                            .indexOf(
                                                                'حديث نمبر'))
                                                : snapshotData[index]
                                                    ['hadith_number'],
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
                              if (selectedLanguage != 'ur')
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: referencesDynamic(
                                            reference: snapshot.data[index]
                                                ['hadithNumber'],
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
                                              (settingsProvider
                                                          .selectedLanguage ==
                                                      'ur'
                                                  ? dataProvider
                                                      .selectedUrduBookNumber
                                                  : dataProvider
                                                      .selectedBookNumber) +
                                              ' , ' +
                                              'Hadith ' +
                                              snapshot.data[index][
                                                      selectedLanguage == 'ur'
                                                          ? "hadith_number"
                                                          : 'hadithNumber']
                                                  .toString(),
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
                          if (selectedLanguage != 'ur')
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      references(
                                          title: 'Urn', cmh: cmh, cmw: cmw),
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
                                          reference: snapshot.data[index][
                                                  selectedLanguage == 'ar'
                                                      ? "arabicURN"
                                                      : "englishURN"]
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
                          if (selectedLanguage != 'ur')
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
                                        reference: snapshot.data[index]
                                                ['last_updated']
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
                          if (selectedLanguage != 'ur' &&
                              snapshot.data[index][selectedLanguage == 'ar'
                                      ? "arabicgrade1"
                                      : 'englishgrade1']
                                  .toString()
                                  .isNotEmpty)
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
                                        ":  " +
                                            snapshot.data[index][
                                                    selectedLanguage == 'ar'
                                                        ? "arabicgrade1"
                                                        : 'englishgrade1']
                                                .toString(),
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
        ),

        ///
        /// bookmark icon is here
        ///
        GestureDetector(
          onTap: () async {
            ///deleting the bookmark here  if the bookmark button is pressed on a hadith already bookmarked
            if (settingsProvider.selectedLanguage ==
                    bookmarkProvider.bookmarkedLanguage &&
                dataProvider.selectedCollectionShortName ==
                    bookmarkProvider.bookmarkedCollectionShortName &&
                dataProvider.selectedBookNumber ==
                    bookmarkProvider.bookmarkedBookNumber &&
                index == bookmarkProvider.bookmarkedIndex) {
              bookmarkProvider.deleteBookmark();
            } else {
              ///applying  bookmark here  if the bookmark button is pressed on a hadith which is not bookmarked
              bookmarkProvider.collectingBookmarkInfo(
                selectedLanguage: settingsProvider.selectedLanguage,
                collectionFullName: dataProvider.selectedCollectionFullName,
                collectionShortName: dataProvider.selectedCollectionShortName,
                bookName: dataProvider.selectedBookName,
                selectedBookNumber: dataProvider.selectedBookNumber,
                selectedUrduBookNumber: dataProvider.selectedUrduBookNumber,
                hadithIndex: index,
              );
            }
            // print('bookmarked');
          },
          child: Padding(
            padding: EdgeInsets.only(
              left: cmw * 0.113,
              top: cmh * 0.008,
            ),

            ///changing the bookmarked icons on condition
            child: Image.asset(
              (settingsProvider.selectedLanguage ==
                          bookmarkProvider.bookmarkedLanguage &&
                      dataProvider.selectedCollectionShortName ==
                          bookmarkProvider.bookmarkedCollectionShortName &&
                      dataProvider.selectedBookNumber ==
                          bookmarkProvider.bookmarkedBookNumber &&
                      index == bookmarkProvider.bookmarkedIndex)
                  ? 'images/bookmark.png'
                  : 'images/bookmark_outlined.png',
              // : 'images/bookmark_outlined.png',
              width: cmw * 0.085,
              // color: Colors.teal,
            ),
          ),
        )
      ],
    );
  }

  Padding chapterNumberDisplay(
      double cmw,
      double cmh,
      ThemeProvider themeProvider,
      SettingsProvider settingsProvider,
      AsyncSnapshot<dynamic> snapshot,
      int index) {
    return Padding(
      padding: EdgeInsets.only(
          left: cmw * 0.05,
          right: cmw * 0.05,
          top: cmh * 0.035,
          bottom: cmh * 0.009),
      child: Text.rich(
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

            /// displaying ChapterID here
            if (settingsProvider.selectedLanguage != 'ur')
              TextSpan(
                  text: snapshot.data[index]['babID'].truncate().toString(),
                  style: TextStyle(
                      color: themeProvider.hadithScreenFontColor,
                      fontWeight: FontWeight.bold)),
          ],
        ),
        // textAlign: TextAlign.left,
      ),
    );
  }

  Padding bookNumberNameDisplay(
      double cmw,
      double cmh,
      ThemeProvider themeProvider,
      SettingsProvider settingsProvider,
      DataProvider dataProvider,
      int index) {
    return Padding(
      padding: EdgeInsets.only(
        left: cmw * 0.05,
        right: cmw * 0.05,
        top: cmh * 0.03,
      ),
      child: Column(
        children: [
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

                /// displaying BOOK NUMBER here
                if (settingsProvider.selectedLanguage != 'ur')
                  TextSpan(
                      text: dataProvider.selectedBookNumber,
                      style: TextStyle(
                          color: themeProvider.hadithScreenFontColor,
                          fontWeight: FontWeight.bold)),

                /// displaying ChapterID(urdu book number) here (for urdu)
                if (settingsProvider.selectedLanguage == 'ur')
                  TextSpan(
                      text: dataProvider.selectedUrduBookNumber,
                      style: TextStyle(
                          color: themeProvider.hadithScreenFontColor,
                          fontWeight: FontWeight.bold)),
              ],
            ),
            textAlign: TextAlign.center,
          ),

          ///BOOK NAME IS HERE
          Padding(
            padding: EdgeInsets.only(top: cmh * 0.007),
            child: Text(
              dataProvider.selectedBookName,
              style: TextStyle(
                fontSize: settingsProvider.selectedLanguage == 'ar'
                    ? 15.sp
                    : settingsProvider.selectedLanguage == 'ur'
                        ? 11.sp
                        : 12.1.sp,
                fontFamily:
                    settingsProvider.selectedLanguage == 'ur' ? 'Noto' : null,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
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
}

/// hadith card bottom icons display widget
class HadithCardIcons extends StatelessWidget {
  const HadithCardIcons({
    Key? key,
    required this.cmh,
    required this.cmw,
    required this.child,
    required this.onPressedFunction,
  }) : super(key: key);
  final onPressedFunction;
  final double cmh;
  final double cmw;

  final IconData child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressedFunction,
      child: Container(
          padding: EdgeInsets.only(
            top: cmh * 0.001525,
            bottom: cmh * 0.001525,
            // left: cmw * 0.02,
            right: cmw * 0.03,
          ),
          // margin: EdgeInsets.only(right: cmw * 0.031),
          // color: Colors.teal.withOpacity(.75),

          child: Icon(
            child,
            size: cmh * 0.023,
            color: Colors.teal,
          )),
    );
  }
}
