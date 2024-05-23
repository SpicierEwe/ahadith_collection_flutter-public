import 'package:ahadith_collection/components/custom_widgets.dart';
import 'package:ahadith_collection/components/settings_components/about_us.dart';
import 'package:ahadith_collection/components/settings_components/font_change_screen.dart';
import 'package:ahadith_collection/providers/bookmark_provider.dart';
import 'package:ahadith_collection/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import '../../../providers/data_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    SearchProvider searchProvider = Provider.of<SearchProvider>(context);
    BookMarkProvider bookmarkProvider = Provider.of<BookMarkProvider>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final cmh = constraints.maxHeight;
        final cmw = constraints.maxWidth;
        return Scaffold(
          backgroundColor: themeProvider.settingsScaffoldColor,
          appBar: CustomWidgets().customAppBar(
              themeProvider: themeProvider,
              appbarColor: themeProvider.settingsAppBarColor,
              showSettings: false,
              context: context,
              cmh: cmh,
              cmw: cmw,
              settingsProvider: settingsProvider,
              simpleStringTitle: 'SETTINGS',
              searchIcon: false),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: cmw * 0.05, right: cmw * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ///themeSwitch

                  themeChangeSwitch(cmh, cmw, settingsProvider, themeProvider),

                  ///settingsSwitch

                  settingTitle(cmh: cmh, title: 'Language'),

                  ///this show in place of change language in hadith screen because of
                  ///different database we can only switch hadith from the collections screen
                  if (settingsProvider.hadithScreenIsOpen == true)
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(text: 'You can '),
                        highLightWord(word: 'only change', cmh: cmh, cmw: cmw),
                        TextSpan(text: ' Language from '),
                        WidgetSpan(
                            child: Container(
                          height: cmh * 0.01,
                        )),
                        highLightWord(
                            word: 'Collections Screen', cmh: cmh, cmw: cmw),
                        const TextSpan(text: ' due to Database Structure. '),
                      ]),
                      style: GoogleFonts.lato(
                          fontSize: 12.1.sp,
                          color: themeProvider.settingsFontColor),
                    ),

                  ///these change language settings are hidden for hadith screen
                  if (settingsProvider.hadithScreenIsOpen != true)
                    settingsLanguageSwitcher(
                        bookmarkProvider,
                        searchProvider,
                        settingsProvider,
                        cmh,
                        cmw,
                        themeProvider,
                        dataProvider),

                  ///font size
                  settingTitle(cmh: cmh, title: 'Font Size'),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: !settingsProvider.darkTheme
                          ? [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: cmh * 0.025,
                                  spreadRadius: -11),
                            ]
                          : null,
                    ),
                    child: FlatButton(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Colors.black, width: .005),
                          borderRadius: BorderRadius.circular(cmh * 0.01),
                        ),
                        padding: EdgeInsets.only(
                          // top: cmh * 0.025,
                          // bottom: cmh * 0.025,
                          left: cmw * 0.05,
                          right: cmw * 0.05,
                        ),
                        color: themeProvider.scaffoldBackgroundColor,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FontChangeScreen(),
                              ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Hadith Font Size',
                              style: GoogleFonts.roboto(
                                color: themeProvider.settingsFontColor,
                                fontSize: 13.sp,
                                // fontWeight: FontWeight.bold
                              ),
                            ),
                            Container(
                              color: Colors.teal,
                              padding: EdgeInsets.only(
                                top: cmh * 0.025,
                                bottom: cmh * 0.025,
                                left: cmh * 0.015,
                                right: cmh * 0.015,
                              ),
                              child: Center(
                                child: Text(
                                  settingsProvider.fontSize
                                      .truncate()
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 11.sp, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),

                  ///More apps
                  // SizedBox(
                  //   height: cmh * 0.1,
                  // ),
                  // OtherAppsWidget(cmw: cmw, cmh: cmh),

                  ///About us
                  SizedBox(
                    height: cmh * 0.1,
                  ),
                  AboutUS(cmw: cmw, cmh: cmh),
                  // OtherAppsWidget(cmw: cmw, cmh: cmh),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ///***********************************
  ///EXTRACTED WIDGETS START FROM
  ///************************************
  WidgetSpan highLightWord({required word, required cmh, required cmw}) {
    return WidgetSpan(
        child: Text(' $word ',
            style: GoogleFonts.lato(
              backgroundColor: Colors.teal.shade300,
              fontSize: 12.1.sp,
            )));
  }

  Padding settingTitle({cmh, required String title}) {
    return Padding(
      padding: EdgeInsets.only(
        top: cmh * 0.045,
        bottom: cmh * 0.021,
      ),
      child: Text(
        title,
        style: GoogleFonts.roboto(
            color: Colors.teal, fontSize: 11.9.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Padding themeChangeSwitch(double cmh, double cmw,
      SettingsProvider settingsProvider, ThemeProvider themeProvider) {
    return Padding(
      padding: EdgeInsets.only(
        top: cmh * 0.017,
        // left: cmw * 0.05,
        // right: cmw * 0.05,
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(settingsProvider.darkTheme
                  ? 'images/stars.jpg'
                  : 'images/sun_sky.jpg')),
          borderRadius: BorderRadius.circular(cmh * 0.025),
          boxShadow: !settingsProvider.darkTheme
              ? [
                  const BoxShadow(
                      color: Colors.grey, blurRadius: 10, spreadRadius: -3),
                ]
              : null,
          color: themeProvider.settingsBoxColor,
        ),
        padding: EdgeInsets.only(top: cmh * 0.017),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: 81,
                  child: Icon(
                    Icons.nightlight_round,
                    color: settingsProvider.darkTheme
                        ? const Color(0xfff4f4f4)
                        : Colors.orange.withOpacity(.2),
                    size: settingsProvider.darkTheme ? cmh * 0.1 : cmh * 0.05,
                  ),
                ),
                ShaderMask(
                  shaderCallback: (bounds) => const RadialGradient(
                    center: Alignment.center,
                    radius: 0.3,
                    colors: [
                      Colors.orange,
                      Colors.deepOrange,
                      Color(0xffFF5349)
                    ],
                    tileMode: TileMode.mirror,
                  ).createShader(bounds),
                  child: Icon(
                    Icons.wb_sunny_sharp,
                    color: settingsProvider.darkTheme
                        ? Colors.white.withOpacity(.25)
                        : Colors.white,
                    size: !settingsProvider.darkTheme ? cmh * 0.1 : cmh * 0.05,
                  ),
                ),
              ],
            ),
            Switch(
                value: settingsProvider.darkTheme,
                thumbColor: settingsProvider.darkTheme
                    ? MaterialStateProperty.all(Colors.teal)
                    : null,
                trackColor: settingsProvider.darkTheme
                    ? MaterialStateProperty.all(Colors.teal)
                    : null,
                onChanged: (value) async {
                  setState(() {
                    settingsProvider.darkTheme = value;
                    themeProvider.switchTheme(
                        settingsProvider: settingsProvider);
                    settingsProvider.saveThemeValue(value: value);
                  });
                }),
          ],
        ),
      ),
    );
  }

  ///here is the language switcher widget function
  Widget settingsLanguageSwitcher(
      BookMarkProvider bookmarkProvider,
      SearchProvider searchProvider,
      SettingsProvider settingsProvider,
      double cmh,
      double cmw,
      ThemeProvider themeProvider,
      DataProvider dataProvider) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: !settingsProvider.darkTheme
              ? [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: cmh * 0.025,
                      spreadRadius: -13),
                ]
              : null,
        ),
        child: FlutterToggleTab(
          // width in percent, to set full width just set to 100
          width: cmw * 0.217,
          borderRadius: cmh * 0.035,
          height: cmh * 0.06,
          marginSelected: EdgeInsets.only(
            top: cmh * 0.005,
            bottom: cmh * 0.005,
            left: cmh * 0.005,
            right: cmh * 0.005,
          ),
          // unSelectedBackgroundColors: [themeProvider.settingsScaffoldColor],
          isShadowEnable: true,
          // selectedBackgroundColors: [themeProvider.settingsAppBarColor],
          selectedBackgroundColors: const [Colors.teal],
          selectedTextStyle: GoogleFonts.josefinSans(
              // color: Colors.white,
              color: Colors.white,
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w700),
          unSelectedTextStyle: TextStyle(
            color: themeProvider.hadithScreenFontColor,
            fontSize: 12.5.sp,
          ),
          unSelectedBackgroundColors: [themeProvider.scaffoldBackgroundColor],
          labels: const ["اردو", "English", "اَلْعَرَبِيَّةُ"],
          selectedLabelIndex: (index) {
            // print("Selected Index $index");
            setState(() {
              ///
              settingsProvider.settingsLanguageTabIndex = index;
              switch (index) {
                case 0:
                  {
                    settingsProvider.saveSelectedLanguage(value: 'ur');
                    settingsProvider.updateSelectedLanguage(
                        lang: 'ur', bookMarkProvider: bookmarkProvider);
                    dataProvider.fetchCollections();
                  }
                  break;
                case 1:
                  {
                    settingsProvider.saveSelectedLanguage(value: 'en');
                    settingsProvider.updateSelectedLanguage(
                        lang: 'en', bookMarkProvider: bookmarkProvider);
                    dataProvider.fetchCollections();
                  }
                  break;
                case 2:
                  {
                    settingsProvider.saveSelectedLanguage(value: 'ar');
                    settingsProvider.updateSelectedLanguage(
                        lang: 'ar', bookMarkProvider: bookmarkProvider);
                    dataProvider.fetchCollections();
                  }
                  break;
              }
            });
          },
          selectedIndex: settingsProvider.settingsLanguageTabIndex,
        ),
      ),
    );
  }
}
