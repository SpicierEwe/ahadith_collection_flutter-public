import 'package:ahadith_collection/components/custom_widgets.dart';
import 'package:ahadith_collection/screens/choose_language.dart';
import 'package:ahadith_collection/screens/display_screens/collection_name_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/data_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';

class MainScreenNavigator extends StatefulWidget {
  const MainScreenNavigator({Key? key}) : super(key: key);

  @override
  State<MainScreenNavigator> createState() => _MainScreenNavigatorState();
}

class _MainScreenNavigatorState extends State<MainScreenNavigator> {
  checkIfSeenInitialLanguageScreen() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('initialLanguageScreen') == false) {
      ///this is executed when the user has already seen the intro screens
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const MenuDrawer(),
          transitionDuration: Duration.zero,
        ),
        // MaterialPageRoute(
        //   builder: (context) => const MenuDrawer(),
        // ),
      );
    } else {
      print('seen status ${prefs.getBool('initialLanguageScreen')}');

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ChooseLanguageScreen(),
          ));
    }
  }

  @override
  void initState() {
    checkIfSeenInitialLanguageScreen();

    Provider.of<ThemeProvider>(context, listen: false).fetchThemeOnRestarting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.scaffoldBackgroundColor,
      body:
          CustomWidgets().customProgressIndicator(themeProvider: themeProvider),
    );
  }
}
