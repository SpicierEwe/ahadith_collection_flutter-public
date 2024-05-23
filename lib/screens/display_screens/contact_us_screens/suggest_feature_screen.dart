import 'package:ahadith_collection/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_form.dart';
import '../../../components/remove_listview_glow.dart';
import '../../../providers/theme_provider.dart';

class SuggestAFeatureScreen extends StatefulWidget {
  const SuggestAFeatureScreen({Key? key}) : super(key: key);

  @override
  State<SuggestAFeatureScreen> createState() => _SuggestAFeatureScreenState();
}

class _SuggestAFeatureScreenState extends State<SuggestAFeatureScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Feature Suggestion',
          style: GoogleFonts.josefinSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: mq.height * 0.0275,
          ),
        ),
        backgroundColor: settingsProvider.darkTheme
            ? themeProvider.scaffoldBackgroundColor
            : Colors.pink,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: settingsProvider.darkTheme
          ? themeProvider.scaffoldBackgroundColor
          : Colors.pink,
      body: ScrollConfiguration(
        behavior: RemoveListViewGlow(),
        child: SingleChildScrollView(
          child: SizedBox(
              height: mq.height -
                  (AppBar().preferredSize.height +
                      MediaQuery.of(context).padding.top),
              width: mq.width,
              child: CustomForm(
                specificPortalColor: settingsProvider.darkTheme
                    ? themeProvider.scaffoldBackgroundColor
                    : Colors.pink,
                portalType: 'feature_suggestion',
              )),
        ),
      ),
    );
  }
}
