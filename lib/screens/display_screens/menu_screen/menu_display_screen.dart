import 'package:ahadith_collection/screens/display_screens/contact_us_screens/report_screen.dart';
import 'package:ahadith_collection/screens/display_screens/settings_screen/settings_screen.dart';
import 'package:ahadith_collection/screens/search_screen/search_screen.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../providers/data_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/theme_provider.dart';
import '../contact_us_screens/contact_us_screen.dart';
import '../contact_us_screens/suggest_feature_screen.dart';

class MenuDisplayScreen extends StatefulWidget {
  const MenuDisplayScreen({Key? key}) : super(key: key);

  @override
  _MenuDisplayScreenState createState() => _MenuDisplayScreenState();
}

bool _switchValue = true;

class _MenuDisplayScreenState extends State<MenuDisplayScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    final mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        // backgroundColor: const Color(0xff14279B),
        backgroundColor: const Color(0xffFAF1E6),
        body: SizedBox(
          height: mq.height - (MediaQuery.of(context).padding.top),
          child: LayoutBuilder(builder: (context, constraints) {
            var cmh = constraints.maxHeight;
            var cmw = constraints.maxWidth;
            return Column(
              children: [
                SizedBox(
                  height: cmh * 0.05,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: cmw * 0.25,
                    ),
                    Center(
                      child: CircleAvatar(
                        backgroundImage:
                            const AssetImage('images/prophetName.png'),
                        backgroundColor: const Color(0xffFAF1E6),
                        radius: cmh * 0.09,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: cmh * 0.05,
                ),
                contactingButtons(
                    cmh: cmh,
                    cmw: cmw,
                    contactingType: 'CONTACT US',
                    contactTypeIcon: Icons.help_outline_sharp,
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ContactUsScreen()))),
                SizedBox(
                  height: cmh * 0.025,
                ),

                ///******************
                ///Suggest a feature
                ///******************
                contactingButtons(
                    cmh: cmh,
                    cmw: cmw,
                    contactingType: 'FEATURE SUGGESTION',
                    contactTypeIcon: Icons.lightbulb,
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SuggestAFeatureScreen()))),

                SizedBox(
                  height: cmh * 0.025,
                ),

                ///******************
                ///report an issue
                ///*********************
                contactingButtons(
                    cmh: cmh,
                    cmw: cmw,
                    contactingType: 'REPORT AN ISSUE',
                    contactTypeIcon: Icons.report,
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReportScreen()))),
                SizedBox(height: cmh * 0.019),

                // ///******************
                // ///Settings Option
                // ///*********************
                // contactingButtons(
                //     cmh: cmh,
                //     cmw: cmw,
                //     contactingType: 'SETTINGS',
                //     contactTypeIcon: Icons.settings,
                //     onPressed: () {
                //       settingsProvider.toggleMenu();
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => const SettingsScreen(),
                //           ));
                //     }),
                // SizedBox(height: cmh * 0.019),

                ///******************
                ///Search Option
                ///*********************
                contactingButtons(
                    cmh: cmh,
                    cmw: cmw,
                    contactingType: 'SEARCH',
                    contactTypeIcon: Icons.search,
                    onPressed: () {
                      settingsProvider.toggleMenu();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchScreen(),
                          ));
                    }),
                SizedBox(height: cmh * 0.019),

                ///
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * .2),
                      child: Text(
                        'APP Theme',
                        style: TextStyle(
                            fontSize: 12.1.sp, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: cmh * 0.015),
                    Container(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * .125),
                      child: Row(
                        children: [
                          Text(
                            'LIGHT ',
                            style: TextStyle(
                              fontSize: 11.5.sp,
                            ),
                          ),

                          /// SWITCH THEME BUTTON
                          CupertinoSwitch(
                              trackColor: Colors.teal,
                              activeColor: Colors.black,
                              value: settingsProvider.darkTheme,
                              onChanged: (value) {
                                settingsProvider.saveThemeValue(value: value);
                                settingsProvider.darkTheme = value;
                                themeProvider.switchTheme(
                                    settingsProvider: settingsProvider);
                              }),
                          Text(
                            ' DARK',
                            style: TextStyle(
                                fontSize: 11.5.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  FlatButton contactingButtons(
      {required cmh,
      required cmw,
      onPressed,
      required String contactingType,
      required IconData contactTypeIcon}) {
    return FlatButton(
      padding: EdgeInsets.only(left: cmw * 0.05),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            contactTypeIcon,
          ),
          SizedBox(
            width: cmh * 0.01,
          ),
          Text(
            contactingType,
            style: TextStyle(fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}
