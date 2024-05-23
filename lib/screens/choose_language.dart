import 'package:ahadith_collection/providers/bookmark_provider.dart';
import 'package:ahadith_collection/providers/settings_provider.dart';
import 'package:ahadith_collection/providers/theme_provider.dart';
import 'package:ahadith_collection/screens/display_screens/collection_name_screen.dart';
import 'package:ahadith_collection/screens/display_screens/menu_screen/menu_display_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_color/rainbow_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'package:auto_size_text/auto_size_text.dart';

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ChooseLanguageScreenState createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen>
    with SingleTickerProviderStateMixin {
  bool hideDisclaimer = false;
  bool isTablet = true;

  late AnimationController controller;
  late Animation<Color> _colorChange;

  ///

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    super.initState();
    Provider.of<SettingsProvider>(context, listen: false).defaultValues();
    controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );
    _colorChange = RainbowColorTween([
      const Color(0xffFAF1E6),

      Colors.green,
      Colors.pink,
      Colors.red,
      Colors.orange,
      Colors.black,
      Colors.purple,
      Colors.blueGrey,
      Colors.blueAccent,
      Colors.cyan,
      Colors.teal,
      const Color(0xffFAF1E6),
      // Colors.black
    ]).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
          controller.forward();
        } else if (status == AnimationStatus.dismissed) {
          // controller.forward();
        }
      });
    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    BookMarkProvider bookMarkProvider = Provider.of<BookMarkProvider>(context);
    var mq = MediaQuery.of(context).size;
    // print('${mq.width} x ${mq.height}');

    return LayoutBuilder(builder: (context, constraints) {
      final cmh = constraints.maxHeight;
      final cmw = constraints.maxWidth;

      ///this is Displayed as warning for the Tablet users
      ///by default the isTablet bool is true but if the code detects that the screen size is tablet it show the warning then when the user clicks on i agree the flag isTablet goes false and the tablet user can proceed alhdulillah
      if (mq.width >= 800 && isTablet) {
        return tabletWarning(cmw, cmh, themeProvider, bookMarkProvider,
            constraints, settingsProvider);
      }
      return mainContent(themeProvider, cmh, bookMarkProvider, constraints,
          settingsProvider, cmw);
    });
  }

  Scaffold tabletWarning(
      double cmw,
      double cmh,
      ThemeProvider themeProvider,
      BookMarkProvider bookMarkProvider,
      BoxConstraints constraints,
      SettingsProvider settingsProvider) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            cmw * .05,
            cmh * .05,
            cmw * .05,
            cmh * .05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: 'Not Optimized \n\n',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13.sp)),
                    const TextSpan(
                        text: 'We have detected that you\'re using a \n'),
                    const TextSpan(
                        text: 'TABLET SCREEN \n',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(text: 'size device. \n\n'),
                    const TextSpan(
                        text:
                            'The app was mainly focused for mobile phone devices. So we want to warn you that you might see some unpleasant UI. May be in near future inshallah we\'ll optimize it for larger Screens so, \n\n USE ON YOUR OWN COMFORT')
                  ],
                ),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10.5.sp),
              ),
              SizedBox(
                height: cmh * 0.05,
              ),

              ///flat (i agree ) button is here
              FlatButton(
                  color: Colors.teal,
                  onPressed: () async {
                    setState(() {
                      isTablet = false;
                    });
                  },
                  child: Text(
                    'i agree ->',
                    style:
                        TextStyle(fontSize: cmh * 0.021, color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Scaffold mainContent(
      ThemeProvider themeProvider,
      double cmh,
      BookMarkProvider bookMarkProvider,
      BoxConstraints constraints,
      SettingsProvider settingsProvider,
      double cmw) {
    return Scaffold(
      backgroundColor: themeProvider.languageScreenScaffoldColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ///**********************************
          ///prophet name image is here
          ///**********************************
          SizedBox(
            height: cmh * 0.3,
            child: Center(
              child: CircleAvatar(
                backgroundImage: const AssetImage('images/prophetName.png'),
                backgroundColor: _colorChange.value,
                radius: cmh * 0.09,
              ),
            ),
          ),
          if (hideDisclaimer == true)
            chooseLanguage(themeProvider, bookMarkProvider, constraints, cmh,
                settingsProvider, cmw),
          if (hideDisclaimer == false)
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: cmh * 0.015),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Welcome to',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.sp,
                          ),
                        ),
                        SizedBox(
                          height: cmh * 0.007,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: cmh * 0.015),
                          child: Text(
                            'ahadith Collection',
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold, fontSize: 21.sp),
                          ),
                        ),
                        SizedBox(
                          height: cmh * 0.05,
                        ),
                        Padding(
                          padding: EdgeInsets.all(cmh * 0.011),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        'Assalamualaikum \nwarahmatullahi wabarakatuh,\n',
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.bold)),
                                const TextSpan(text: 'This App  contains '),
                                highLightWord(
                                    word: 'majority', cmw: cmw, cmh: cmh),
                                const TextSpan(text: ' of the available '),
                                highLightWord(
                                    word: 'SAHIH HADITHS', cmw: cmw, cmh: cmh),
                                const TextSpan(text: ' but it  '),
                                highLightWord(
                                    word: 'also contains some',
                                    cmw: cmw,
                                    cmh: cmh),
                                const TextSpan(text: ' of the '),
                                highLightWord(
                                    word: 'daif hadiths .', cmw: cmw, cmh: cmh),
                                const TextSpan(text: ' \nSo we have provided '),
                                highLightWord(
                                    word: 'GRADE', cmw: cmw, cmh: cmh),
                                const TextSpan(
                                    text:
                                        ' if available for a particular hadith. '),
                                const TextSpan(
                                    text:
                                        ' \nSo please its a humble request just  '),
                                highLightWord(
                                    word: 'don\'t read blindly .',
                                    cmw: cmw,
                                    cmh: cmh),
                              ],
                              style: GoogleFonts.lato(
                                  fontSize: 13.sp, height: 1.5),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: cmh * 0.1,
                        ),
                      ],
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          // side: BorderSide(
                          //   color: Colors.black.withOpacity(.1)
                          // ),
                          borderRadius: BorderRadius.circular(25)),
                      // color: Colors.red,
                      // style: ButtonStyle(),
                      child: SizedBox(
                        width: cmw * 0.27,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'NEXT',
                              style: GoogleFonts.josefinSans(fontSize: 13.sp),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: cmh * 0.007),
                              child: Icon(Icons.navigate_next_sharp,
                                  size: cmh * 0.043, color: Colors.teal),
                            )
                          ],
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          hideDisclaimer = true;
                        });
                      },
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  WidgetSpan highLightWord({required word, required cmh, required cmw}) {
    return WidgetSpan(
        child: Text(' $word ',
            style: GoogleFonts.lato(
              backgroundColor: Colors.teal,
              fontSize: 13.sp,
            )));
  }

  ///CUSTOM WIDGETS STARTS HERE

  Expanded chooseLanguage(
      ThemeProvider themeProvider,
      BookMarkProvider bookMarkProvider,
      BoxConstraints constraints,
      double cmh,
      SettingsProvider settingsProvider,
      double cmw) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.red,
          border: Border.all(color: themeProvider.languageScreenWhiteColor),
          color: Colors.white.withOpacity(.6),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(constraints.maxHeight * .11),
          ),
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: cmh * 0.025, bottom: cmh * 0.05),
              child: Text(
                'The Hadith of the Prophet\n Muhammad (صلى الله عليه و سلم) \n at your fingertips.',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  // color: Color(0xff000000),
                  color: themeProvider.primaryColorTeal,

                  fontSize: 14.1.sp,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            languageButton(
                bookMarkProvider: bookMarkProvider,
                selectedLanguage: 'en',
                settingsProvider: settingsProvider,
                themeProvider: themeProvider,
                cmw: cmw,
                cmh: cmh,
                title: 'READ ENGLISH'),
            languageButton(
                bookMarkProvider: bookMarkProvider,
                selectedLanguage: 'ur',
                settingsProvider: settingsProvider,
                themeProvider: themeProvider,
                cmw: cmw,
                cmh: cmh,
                title: ' READ URDU'),
            languageButton(
                bookMarkProvider: bookMarkProvider,
                selectedLanguage: 'ar',
                settingsProvider: settingsProvider,
                themeProvider: themeProvider,
                cmw: cmw,
                cmh: cmh,
                title: 'READ ARABIC'),
          ],
        ),
      ),
    );
  }

  Column languageButton(
      {required ThemeProvider themeProvider,
      required BookMarkProvider bookMarkProvider,
      required cmw,
      required cmh,
      required title,
      required SettingsProvider settingsProvider,
      required String selectedLanguage}) {
    return Column(
      children: [
        SizedBox(
          height: cmh * 0.05,
          width: cmw * 0.43,
          child: FlatButton(
            color: themeProvider.primaryColorTeal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(cmh * .035),
                bottomRight: Radius.circular(cmh * .035),
                bottomLeft: Radius.circular(cmh * .005),
                topRight: Radius.circular(cmh * .005),
              ),
            ),
            onPressed: () async {
              settingsProvider.updateSelectedLanguage(
                  lang: selectedLanguage, bookMarkProvider: bookMarkProvider);
              settingsProvider.saveSelectedLanguage(value: selectedLanguage);

              ///***************************************************************
              ///disabling screen after user has selected for the 1st time
              ///*************************************************************
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('initialLanguageScreen', false);

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MenuDrawer(),
                  ));
            },
            child: Text(
              title,
              style: GoogleFonts.roboto(
                  letterSpacing: 1.3,
                  fontSize: 11.sp,
                  color: themeProvider.languageScreenFontColor),
            ),
          ),
        ),
        SizedBox(
          height: cmh * 0.05,
        )
      ],
    );
  }
}
