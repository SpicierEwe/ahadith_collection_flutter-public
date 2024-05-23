import 'package:ahadith_collection/providers/settings_provider.dart';
import 'package:ahadith_collection/screens/display_screens/settings_screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../providers/theme_provider.dart';
import '../screens/search_screen/search_screen.dart';

class CustomWidgets {
  /// custom circular progress indicator
  Widget customProgressIndicator({required ThemeProvider themeProvider}) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.teal,
      ),
    );
  }

  AppBar customAppBar(
      {required context,
      required ThemeProvider themeProvider,
      bookMarkProvider,
      dataProvider,
      showBookmarkIcon,
      dynamicTitleWidget,
      simpleStringTitle,
      required cmh,
      required cmw,
      required SettingsProvider settingsProvider,
      appbarColor,
      showMenu,
      showSettings,
      showFontResetIcon,
      searchIcon}) {
    if (dynamicTitleWidget != null) {
      return AppBar(
        backgroundColor: appbarColor ?? themeProvider.primaryColorTeal,
        title: dynamicTitleWidget,
        actions: [
          ///search Icon for appbar dynamic title widget
          if (searchIcon != false)
            IconButton(
                splashRadius: cmh * 0.025,
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ));
                }),

          ///settings icon for appbar dynamic title widget
          if (showSettings != false)
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ));
              },
              child: const Icon(Icons.settings, color: Colors.white),
            )
        ],
      );
    }

    ///SIMPLE TEXT APPBAR
    return AppBar(
      backgroundColor: appbarColor ?? appbarColor,
      leading: showMenu == true
          ? GestureDetector(
              child: Icon(
                Icons.menu_open,
                size: cmh * 0.035,
              ),
              onTap: () {
                // print('im pressed');
                settingsProvider.toggleMenu();
              },
            )
          : null,
      // backgroundColor: Colors.red,
      title: Padding(
        padding: EdgeInsets.only(top: cmh * 0.01),
        child: Text(
          simpleStringTitle,
          style: GoogleFonts.josefinSans(
              fontWeight: FontWeight.bold, fontSize: 15.sp),
        ),
      ),
      actions: [
        ///search Icon
        if (searchIcon != false)
          IconButton(
              tooltip: 'Search',
              splashRadius: cmh * 0.025,
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ));
              }),

        ///bookmark icon
        if (showBookmarkIcon == true)
          IconButton(
            tooltip: 'Last Read',
            onPressed: () async {
              print('hello bookmark button was pressed hammad');
              bookMarkProvider.navigateToBookmark(
                  bookMarkProvider: bookMarkProvider,
                  context: context,
                  settingsProvider: settingsProvider,
                  dataProvider: dataProvider);
            },
            icon: const Icon(Icons.bookmark),
            splashRadius: cmh * 0.025,
          ),

        ///settings icon
        if (showSettings != false)
          IconButton(
              tooltip: 'Settings',
              splashRadius: cmh * 0.025,
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ));
              }),

        ///font size reset icon
        if (showFontResetIcon == true)
          IconButton(
            splashRadius: cmh * 0.025,
            icon: const Icon(
              Icons.refresh,
              semanticLabel: 'Reset',
            ),
            onPressed: () {
              settingsProvider.resetFontSize();
            },
          ),
      ],
      elevation: 0,
    );
  }

  Widget customDivider(
      {required ThemeProvider themeProvider, required cmh, dividerColor}) {
    return Container(
      height: cmh * 0.0005,
      color: dividerColor ?? themeProvider.customDividerColor,
    );
  }

  /// custom input field
  SizedBox customInputField(
      {required double cmw,
      required BuildContext context,
      required double cmh,
      labelName,
      hintString,
      required Function validatorFunction,
      optionalMaxLines,
      optionalMaxLength,
      optionalTextInputType,
      required ThemeProvider themeProvider,
      showLabel}) {
    return SizedBox(
      width: cmw * 0.85,
      child: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.transparent),
        child: TextFormField(
          keyboardType: optionalTextInputType,
          maxLines: optionalMaxLines,
          maxLength: optionalMaxLength,
          autofocus: false,
          style: TextStyle(fontSize: cmh * 0.021, color: Colors.black),
          decoration: InputDecoration(
            labelText: showLabel == true ? labelName.toString() : null,
            filled: true,
            fillColor: Colors.white,
            hintText: hintString.toString(),
            hintStyle: TextStyle(fontSize: 11.sp),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            alignLabelWithHint: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(cmh * 0.015),
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: Colors.blueGrey.withOpacity(.55),
              ),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(cmh * 0.015)),
          ),
          validator: (value) {
            return validatorFunction(value);
          },
        ),
      ),
    );
  }
}
