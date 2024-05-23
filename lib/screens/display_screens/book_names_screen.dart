import 'package:ahadith_collection/components/custom_widgets.dart';
import 'package:ahadith_collection/meta_data/collection_names_meta_data.dart';
import 'package:ahadith_collection/screens/display_screens/hadith_display_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../components/remove_listview_glow.dart';
import '../../providers/bookmark_provider.dart';
import '../../providers/data_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';

class BookNamesScreen extends StatefulWidget {
  const BookNamesScreen({Key? key}) : super(key: key);

  @override
  State<BookNamesScreen> createState() => _BookNamesScreenState();
}

class _BookNamesScreenState extends State<BookNamesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BookMarkProvider bookMarkProvider = Provider.of<BookMarkProvider>(context);
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final cmh = constraints.maxHeight;
        final cmw = constraints.maxWidth;

        return Scaffold(
          backgroundColor: themeProvider.primaryColorTeal,
          appBar: CustomWidgets().customAppBar(
              themeProvider: themeProvider,
              searchIcon: false,
              dataProvider: dataProvider,
              bookMarkProvider: bookMarkProvider,
              // showBookmarkIcon: true,
              context: context,
              settingsProvider: settingsProvider,
              cmw: cmw,
              cmh: cmh,
              showSettings: false,
              simpleStringTitle:
                  "${settingsProvider.selectedLanguage == 'ar' ? dataProvider.selectedCollectionFullName : dataProvider.selectedCollectionShortName} BOOKS"),
          body: Column(
            children: [
              Container(
                height: cmh * 0.021,
              ),
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      color: themeProvider.scaffoldBackgroundColor,
                      // color: const Color(0xffF5F5F5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(cmh * 0.07),
                        topRight: Radius.circular(cmh * 0.05),
                      ),
                    ),

                    ///THIS FUTURE BUILDER DYNAMICALLY FETCHES THE data of urdu & and english ,arabic
                    child: FutureBuilder(
                        future: dataProvider.fetchHadithBooks(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (dataProvider.selectedCollectionShortName ==
                                  'nawawi40' ||
                              dataProvider.selectedCollectionShortName ==
                                  'malik') {
                            return Center(
                              child: Text(
                                'Sorry But Its currently unavailable.',
                                style: GoogleFonts.josefinSans(
                                    color: settingsProvider.darkTheme
                                        ? Colors.white
                                        : null,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }
                          if (!snapshot.hasData) {
                            return CustomWidgets().customProgressIndicator(
                                themeProvider: themeProvider);
                          }

                          return Directionality(
                            textDirection: settingsProvider.selectedLanguage ==
                                        'ar' ||
                                    settingsProvider.selectedLanguage == 'ur'
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: ScrollConfiguration(
                              behavior: RemoveListViewGlow(),
                              child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    TextButton(
                                      style: ButtonStyle(
                                          overlayColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) => Colors.grey
                                                      .withOpacity(.15)),
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.zero)),

                                      ///********************************
                                      ///onPressed IS HERE
                                      ///********************************

                                      onPressed: () async {
                                        if (settingsProvider.selectedLanguage ==
                                            'ur') {
                                          dataProvider.selectedBookName =
                                              snapshot.data[index]['book'];
                                          dataProvider.selectedBookNumber =
                                              snapshot.data[index]['id']
                                                  .toString();
                                          dataProvider.selectedUrduBookNumber =
                                              snapshot.data[index]
                                                      ['book_number']
                                                  .toString();
                                        } else {
                                          dataProvider.selectedBookNumber =
                                              snapshot.data[index]
                                                  ['bookNumber'];
                                          dataProvider.selectedBookName =
                                              snapshot.data[index]
                                                  ['book'][settingsProvider
                                                          .selectedLanguage ==
                                                      'en'
                                                  ? 0
                                                  : 1]['name'];
                                        }
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const HadithDisplayScreen(),
                                            ));
                                      },

                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: cmh * 0.01,
                                          left: cmw * 0.03,
                                          right: cmw * 0.05,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ///*************************************
                                                ///collection number in show here
                                                ///***************************************
                                                SizedBox(
                                                  width: cmw * 0.121,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      right: cmw * 0.02,
                                                      left: cmw * 0.01,
                                                    ),
                                                    child: Text(
                                                      snapshot.data[index][
                                                              settingsProvider
                                                                          .selectedLanguage !=
                                                                      'ur'
                                                                  ? 'bookNumber'
                                                                  : 'book_number']
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 10.5.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.teal
                                                            .withOpacity(.85),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),

                                                Container(
                                                  color: Colors.teal
                                                      .withOpacity(.15),
                                                  width: cmw * 0.005,
                                                  height: cmh * 0.025,
                                                ),
                                                SizedBox(
                                                  width: cmh * 0.025,
                                                ),

                                                ///***************************************************
                                                ///***************************************************
                                                ///display this Widget for English & Arabic  Hadith books
                                                ///***************************************************
                                                ///***************************************************
                                                if (settingsProvider
                                                        .selectedLanguage !=
                                                    'ur')
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ///hadith collection name is here
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: cmh *
                                                                      0.016,
                                                                  bottom: cmh *
                                                                      0.016),
                                                          child: Text(
                                                            snapshot.data[index]
                                                                    ['book'][
                                                                    settingsProvider.selectedLanguage ==
                                                                            'en'
                                                                        ? 0
                                                                        : 1]
                                                                    ['name']
                                                                .toString(),
                                                            style: settingsProvider
                                                                        .selectedLanguage !=
                                                                    'ar'
                                                                ? TextStyle(
                                                                    fontFamily:
                                                                        "AcuminPro",
                                                                    // fontWeight:
                                                                    //     FontWeight
                                                                    //         .bold,
                                                                    // fontWeight:
                                                                    //     FontWeight.w600,
                                                                    fontSize:
                                                                        13.65
                                                                            .sp,
                                                                    // fontSize: cmh* 0.023,

                                                                    color: themeProvider
                                                                        .fontColor)
                                                                : TextStyle(
                                                                    color: themeProvider
                                                                        .fontColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        17.5.sp,
                                                                    fontFamily:
                                                                        'Uthmani_hafs_official'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ///***************************************************
                                                ///***************************************************
                                                ///display this Widget for urdu Hadith
                                                ///***************************************************
                                                ///***************************************************
                                                if (settingsProvider
                                                        .selectedLanguage ==
                                                    'ur')
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ///hadith collection name is here
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: cmh *
                                                                      0.01,
                                                                  bottom: cmh *
                                                                      0.01),
                                                          child: Text(
                                                            snapshot.data[index]
                                                                ['book'],
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Noto',
                                                              fontSize: 13.9.sp,
                                                              // fontSize: cmh* 0.023,
                                                              color:
                                                                  themeProvider
                                                                      .fontColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),

                                            ///total available number of hadith is shown here
                                            if (settingsProvider
                                                    .selectedLanguage !=
                                                'ur')
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  bookHadithCount(
                                                      snapshot: snapshot,
                                                      index: index,
                                                      hadithCountType:
                                                          'hadithStartNumber'),
                                                  Text(
                                                    ' - ',
                                                    style: TextStyle(
                                                        color: Colors.teal
                                                            .withOpacity(.65)),
                                                  ),
                                                  bookHadithCount(
                                                      snapshot: snapshot,
                                                      index: index,
                                                      hadithCountType:
                                                          'hadithEndNumber'),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (index != snapshot.data.length - 1)
                                      CustomWidgets().customDivider(
                                          themeProvider: themeProvider,
                                          cmh: cmh),
                                    if (index == snapshot.data.length - 1)
                                      SizedBox(
                                        height: cmh * 0.015,
                                      )
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
              ),
            ],
          ),
        );
      },
    );
  }

  Text bookHadithCount(
      {required AsyncSnapshot<dynamic> snapshot,
      required int index,
      required String hadithCountType}) {
    return Text(
      '${snapshot.data[index][hadithCountType]}',
      style: GoogleFonts.openSans(
          fontSize: 9.3.sp,
          // fontSize: widget.cmh * 0.0173,
          fontWeight: FontWeight.bold,
          // color: const Color(0xff71727e).withOpacity(.59),

          color: Colors.teal.withOpacity(.65)),
    );
  }
}
