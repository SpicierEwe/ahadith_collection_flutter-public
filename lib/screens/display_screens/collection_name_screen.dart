import 'package:ahadith_collection/components/custom_widgets.dart';
import 'package:ahadith_collection/components/remove_listview_glow.dart';
import 'package:ahadith_collection/meta_data/collection_names_meta_data.dart';
import 'package:ahadith_collection/providers/data_provider.dart';
import 'package:ahadith_collection/providers/settings_provider.dart';
import 'package:ahadith_collection/screens/display_screens/book_names_screen.dart';
import 'package:ahadith_collection/screens/display_screens/settings_screen/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';

import '../../providers/bookmark_provider.dart';
import '../../providers/data_provider.dart';
import '../../providers/theme_provider.dart';
import 'menu_screen/menu_display_screen.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  // final bool switchValue;

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  final drawerController = ZoomDrawerController();

  @override
  void initState() {
    Provider.of<SettingsProvider>(context, listen: false).fetchValues();
    // Provider.of<ThemeProvider>(context, listen: false).fetchThemeOnRestarting();
    Provider.of<DataProvider>(context, listen: false).fetchCollections();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final cmh = constraints.maxHeight;
        final cmw = constraints.maxWidth;
        return ZoomDrawer(
          controller: drawerController,
          menuScreen: const MenuDisplayScreen(
              // storage: CounterStorage(),
              // switchValue: widget.switchValue,
              ),
          mainScreen: CollectionNameScreen(
            zoomDrawerController: drawerController,
          ),

          borderRadius: cmh * 0.027,
          showShadow: true,
          mainScreenTapClose: true,
          // duration:  const Duration(milliseconds: 500),
          shadowLayer1Color: Colors.teal.withOpacity(.15),
          style: DrawerStyle.defaultStyle,
          // isRtl: false,
          angle: 0.0,
          menuBackgroundColor: themeProvider.languageScreenScaffoldColor,
          slideWidth: cmw * 0.7,
          openCurve: Curves.easeOut,

          closeCurve: Curves.easeIn,
        );
      },
    );
  }
}
////////////////////////////////

class CollectionNameScreen extends StatefulWidget {
  final ZoomDrawerController zoomDrawerController;

  const CollectionNameScreen({Key? key, required this.zoomDrawerController})
      : super(key: key);

  @override
  State<CollectionNameScreen> createState() => _CollectionNameScreenState();
}

class _CollectionNameScreenState extends State<CollectionNameScreen> {
  @override
  void initState() {
    Provider.of<SettingsProvider>(context, listen: false).zoomDrawerController =
        widget.zoomDrawerController;

    Provider.of<DataProvider>(context, listen: false)
        .fetchCollections(context: context);

    Provider.of<BookMarkProvider>(context, listen: false)
        .fetchBookmarkedOnRestart();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BookMarkProvider bookMarkProvider = Provider.of<BookMarkProvider>(context);
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    // print(settingsProvider.selectedLanguage);

    return LayoutBuilder(builder: (context, constraints) {
      final cmh = constraints.maxHeight;
      final cmw = constraints.maxWidth;

      return Scaffold(
        backgroundColor: themeProvider.primaryColorTeal,
        appBar: CustomWidgets().customAppBar(
          appbarColor: themeProvider.primaryColorTeal,
          themeProvider: themeProvider,
            searchIcon: false,
            bookMarkProvider: bookMarkProvider,
            dataProvider: dataProvider,
            showBookmarkIcon: true,
            context: context,
            showMenu: true,
            cmw: cmw,
            cmh: cmh,
            simpleStringTitle: "COLLECTIONS",
            settingsProvider: settingsProvider),
        body: Column(
          children: [
            Container(
              height: cmh * 0.021,
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    color: themeProvider.scaffoldBackgroundColor,

                    // color: Color(0xff4d3c71),
                    // color:  const Color(0xffFAF1E6) ,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(cmh * 0.07),
                      topRight: Radius.circular(cmh * 0.05),
                    ),
                  ),

                  ///THIS FUTURE BUILDER DYNAMICALLY FETCHES THE data of urdu & and english ,arabic
                  child: hadithCollectionDisplayWidget(
                      cmh, cmw, themeProvider, settingsProvider, dataProvider)),
            ),
          ],
        ),
      );
    });
  }

  Directionality hadithCollectionDisplayWidget(
      double cmh,
      double cmw,
      ThemeProvider themeProvider,
      SettingsProvider settingsProvider,
      DataProvider dataProvider) {
    return Directionality(
      textDirection: settingsProvider.selectedLanguage == 'ar' ||
              settingsProvider.selectedLanguage == 'ur'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: ScrollConfiguration(
        behavior: RemoveListViewGlow(),
        child: ListView.builder(
          itemCount: dataProvider.collectionNamesList.length,
          itemBuilder: (context, index) => Column(
            children: [
              TextButton(
                style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.grey.withOpacity(.15)),
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),

                ///********************************
                ///onPressed IS HERE
                ///********************************

                onPressed: () {
                  if (settingsProvider.selectedLanguage == 'ur') {
                    dataProvider.selectedCollectionShortName =
                        dataProvider.collectionNamesList[index]['source'];
                    dataProvider.selectedCollectionFullName =
                        dataProvider.collectionNamesList[index]['source'];
                  } else {
                    dataProvider.selectedCollectionShortName =
                        dataProvider.collectionNamesList[index]['name'];
                    dataProvider.selectedCollectionFullName = dataProvider
                                .collectionNamesList[index]['collection']
                            [settingsProvider.selectedLanguage == 'en' ? 0 : 1]
                        ['title'];
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookNamesScreen(),
                      ));
                },

                child: Padding(
                  padding: EdgeInsets.only(
                      top: cmh * 0.025,
                      left: cmw * 0.05,
                      right: cmw * 0.05,
                      bottom: cmh * 0.025),
                  child: Column(
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ///collection number in show here
                          SizedBox(
                            width: cmw * 0.15,
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: cmw * 0.07,
                                left: cmw * 0.03,
                              ),
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width: cmw*0.0,
                          // ),
                          Container(
                            color: Colors.teal.withOpacity(.15),
                            width: cmw * 0.005,
                            height: cmh * 0.025,
                          ),
                          SizedBox(
                            width: cmh * 0.035,
                          ),

                          ///***************************************************
                          ///***************************************************
                          ///display this Widget for English & Arabic  Hadith
                          ///***************************************************
                          ///***************************************************
                          if (settingsProvider.selectedLanguage != 'ur')
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///hadith collection name is here
                                  Text(
                                    dataProvider.collectionNamesList[index]
                                            ['collection'][
                                        settingsProvider.selectedLanguage ==
                                                'en'
                                            ? 0
                                            : 1]['title'],
                                    style: settingsProvider.selectedLanguage !=
                                            'ar'
                                        ? TextStyle(
                                            // fontWeight: settingsProvider.darkTheme?null:FontWeight.w600,
                                            // letterSpacing: 1,
                                            fontFamily: "AcuminPro",
                                            fontSize: 14.1.sp,
                                            // fontSize: cmh* 0.023,
                                            color: themeProvider.fontColor)
                                        : TextStyle(
                                            color: themeProvider.fontColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.5.sp,
                                            fontFamily:
                                                'Uthmani_hafs_official'),
                                  ),
                                ],
                              ),
                            ),

                          ///***************************************************
                          ///***************************************************
                          ///display this Widget for urdu Hadith
                          ///***************************************************
                          ///***************************************************

                          if (settingsProvider.selectedLanguage == 'ur')
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///hadith collection name is here
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: cmh * 0.01, bottom: cmh * 0.01),
                                    child: Text(
                                      dataProvider.collectionNamesList[index]
                                              ['source']
                                          .toString(),
                                      style: TextStyle(
                                        fontFamily: 'Noto',
                                        fontSize: 14.5.sp,
                                        color: themeProvider.fontColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (index != dataProvider.collectionNamesList.length - 1)
                CustomWidgets().customDivider(
                  themeProvider: themeProvider,
                  cmh: cmh,
                ),
              if (index == dataProvider.collectionNamesList.length - 1)
                SizedBox(
                  height: cmh * 0.005,
                )
            ],
          ),
        ),
      ),
    );
  }

// Text hadithCount({required DataProvider dataProvider,
//   required title,
//   required int index,
//   required String hadithCountType}) {
//   return Text(
//     '$title :  ${ dataProvider.collectionNamesList[index][hadithCountType]}',
//     style: GoogleFonts.openSans(
//       fontSize: 9.3.sp,
//       // fontSize: widget.cmh * 0.0173,
//       fontWeight: FontWeight.bold,
//       // color: const Color(0xff71727e).withOpacity(.59),
//       color: Colors.teal.withOpacity(.65),
//       // color: Colors.black.withOpacity(.35)
//     ),
//   );
// }
}
