import 'package:ahadith_collection/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  Color languageScreenScaffoldColor = const Color(0xffFAF1E6);
  Color languageScreenWhiteColor = Colors.white.withOpacity(.6);
  Color languageScreenFontColor = const Color(0xffFAF1E6);

  ///
  // Color primaryColorTeal = const Color(0xffFAF1E6);
  // Color scaffoldBackgroundColor = const Color(0xffFAF1E6);
  ///
  Color primaryColorTeal = Colors.teal; //off
  Color scaffoldBackgroundColor = Colors.white; //off

  Color fontColor = Colors.teal;

  ///
  Color hadithScreenScaffoldColor = const Color(0xffF5F5F5);
  Color hadithScreenCardColor = Colors.white;
  Color hadithScreenFontColor = Colors.black.withOpacity(.75);
  Color customDividerColor = Colors.grey.withOpacity(.3);
  Color hadithInfoBoxColor = Colors.teal.shade300;

  ///
  Color settingsScaffoldColor = const Color(0xffF5F5F5);
  Color settingsAppBarColor = Colors.teal;
  Color settingsBoxColor = Colors.white;
  Color settingsFontColor = Colors.black.withOpacity(.75);

  ///theme switcher

  fetchThemeOnRestarting() async {
    final prefs = await SharedPreferences.getInstance();
    bool darkThemeValue = prefs.getBool('themeValue')!;
    if (darkThemeValue) {
      darkTheme();
      notifyListeners();
    } else {
      lightTheme();
      notifyListeners();
    }
  }

  switchTheme({required SettingsProvider settingsProvider}) {
    if (settingsProvider.darkTheme == true) {
      darkTheme();
      notifyListeners();
    } else {
      lightTheme();
      notifyListeners();
    }
  }

  ///
  lightTheme() {
    languageScreenScaffoldColor = const Color(0xffFAF1E6);
    languageScreenWhiteColor = Colors.white.withOpacity(.6);
    languageScreenFontColor = const Color(0xffFAF1E6);

    ///
    // Color primaryColorTeal = const Color(0xffFAF1E6);
    // Color scaffoldBackgroundColor = const Color(0xffFAF1E6);
    ///
    primaryColorTeal = Colors.teal; //off
    scaffoldBackgroundColor = Colors.white; //off

    fontColor = Colors.teal;

    ///
    hadithScreenScaffoldColor = const Color(0xffF5F5F5);
    hadithScreenCardColor = Colors.white;
    hadithScreenFontColor = Colors.black.withOpacity(.75);
    hadithInfoBoxColor = Colors.teal.shade300;

    ///
    customDividerColor = Colors.grey.withOpacity(.3);

    ///
    settingsScaffoldColor = Colors.white;
    settingsAppBarColor = Colors.teal;
    settingsBoxColor = Colors.white;
    settingsFontColor = Colors.black.withOpacity(.75);
  }

  darkTheme() {
    languageScreenScaffoldColor = const Color(0xffFAF1E6);
    languageScreenWhiteColor = Colors.white.withOpacity(.6);
    languageScreenFontColor = const Color(0xffFAF1E6);

    ///

    ///
    primaryColorTeal = const Color(0xff000000); //off
    // scaffoldBackgroundColor = Colors.black; //off
    // primaryColorTeal = Colors.black;

    scaffoldBackgroundColor = const Color(0xff121212);

    // fontColor = Colors.teal;
    // fontColor = const Color(0xffb0abab);
    fontColor = const Color(0xfff2f3f4).withOpacity(.75);

    // fontColor = Color(0xffe7e9ea);

    ///
    // hadithScreenScaffoldColor = const Color(0xff262626);
    // hadithScreenBoxColor = Colors.black;

    /// /////
    // hadithScreenCardColor = Colors.black;
    // hadithScreenScaffoldColor = const Color(0xff262626);
    // hadithScreenFontColor =Colors.white.withOpacity(.65);

    hadithScreenCardColor = const Color(0xff222222);
    // hadithScreenCardColor = const Color(0xff121212);
    hadithScreenScaffoldColor = const Color(0xff121212);
    // hadithScreenScaffoldColor = const Color(0xff070707);

    hadithScreenFontColor = const Color(0xfff2f3f4).withOpacity(.75);
    hadithScreenFontColor = const Color(0xffbababa);

    hadithInfoBoxColor = Colors.teal.withOpacity(.7);

    ///
    customDividerColor = Colors.grey.withOpacity(.05);

    settingsScaffoldColor = const Color(0xff262626);
    settingsAppBarColor = Colors.black;
    settingsBoxColor = Colors.black;
    settingsFontColor = Colors.white60.withOpacity(.79);
  }
}
