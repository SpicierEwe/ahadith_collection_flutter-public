import 'dart:async';

import 'package:ahadith_collection/Navigators/main_screen_navigator.dart';
import 'package:ahadith_collection/providers/bookmark_provider.dart';
import 'package:ahadith_collection/providers/contact_portal_provider.dart';
import 'package:ahadith_collection/providers/data_provider.dart';
import 'package:ahadith_collection/providers/miscellaneous_provider.dart';
import 'package:ahadith_collection/providers/search_provider.dart';
import 'package:ahadith_collection/providers/settings_provider.dart';
import 'package:ahadith_collection/providers/theme_provider.dart';
import 'package:ahadith_collection/screens/choose_language.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(DevicePreview(
    // enabled: true,
    enabled: !kReleaseMode,
    builder: (context) => MultiProvider(providers: [
      ChangeNotifierProvider<DataProvider>(
        create: (context) => DataProvider(),
      ),
      ChangeNotifierProvider<ThemeProvider>(
        create: (context) => ThemeProvider(),
      ),
      ChangeNotifierProvider<SettingsProvider>(
        create: (context) => SettingsProvider(),
      ),
      ChangeNotifierProvider<SearchProvider>(
        create: (context) => SearchProvider(),
      ),
      ChangeNotifierProvider<BookMarkProvider>(
        create: (context) => BookMarkProvider(),
      ),
      ChangeNotifierProvider<MiscellaneousProvider>(
        create: (context) => MiscellaneousProvider(),
      ),
      ChangeNotifierProvider<ContactPortalProvider>(
        create: (context) => ContactPortalProvider(),
      ),
    ], child: const MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Sizer(
      builder: (context, orientation, deviceType) => MaterialApp(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        title: 'ahadith Collection',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            elevation: 0,

            backgroundColor: themeProvider.primaryColorTeal,
            centerTitle: true,

            ///status bar color
          ),
          primarySwatch: Colors.blue,
        ),
        home: const MainScreenNavigator(),
      ),
    );
  }
}
