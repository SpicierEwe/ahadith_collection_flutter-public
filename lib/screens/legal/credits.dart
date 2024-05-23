import 'package:ahadith_collection/components/custom_widgets.dart';
import 'package:ahadith_collection/providers/settings_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../components/remove_listview_glow.dart';
import '../../providers/theme_provider.dart';

class CreditsScreen extends StatefulWidget {
  const CreditsScreen({Key? key}) : super(key: key);

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  List appDataInfoList = [
    {
      'title': 'HADITH DATA FROM',
      'subtitle': 'https://sunnah.com/',
      'url':
          'images/colored_books.jpg'
    },
    {
      'title': 'URDU HADITH FROM',
      'subtitle': 'https://github.com/pakjiddat',
      'url':
         'images/bg12.jpg'
    },
    {
      'title': 'IMAGES FROM',
      'subtitle': 'https://unsplash.com/',
      'url':
          'images/pink_leaf.jpg'
    },
  ];
  List contributorsList = [
    'CURRENTLY STAND ALONE \n THE DEV IS HIMSELF THE CONTRIBUTOR'
  ];

  @override
  Widget build(BuildContext context) {
    ////////////////////////////
    var themeProvider = Provider.of<ThemeProvider>(context);
    var settingsProvider = Provider.of<SettingsProvider>(context);
    return LayoutBuilder(builder: (context, constraints) {
      final cmh = constraints.maxHeight;
      final cmw = constraints.maxWidth;
      return Scaffold(
        appBar: CustomWidgets().customAppBar(
            searchIcon: false,
            themeProvider: themeProvider,
            appbarColor: themeProvider.settingsAppBarColor,
            showSettings: false,
            context: context,
            cmh: cmh,
            cmw: cmw,
            settingsProvider: settingsProvider,
            simpleStringTitle: 'CREDITS'),
        body: Container(
          color: Colors.white,
          child: ScrollConfiguration(
            behavior: RemoveListViewGlow(),
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) => Column(
                children: [
                  SizedBox(height: cmh * 0.03),
                  Text(
                    'ALHAMDULILLAH',
                    style: GoogleFonts.josefinSans(
                        fontSize: 12.sp, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: cmh * 0.03),
                  Padding(
                    padding: EdgeInsets.only(left: cmh * 0.013),
                    child: Text(
                      'Secondly We Thank the following organizations below - ',
                      style: GoogleFonts.roboto(
                          fontSize: 13.sp, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: cmh * 0.025),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: cmh * 0.23,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: index == 0
                                    ? EdgeInsets.only(left: cmh * 0.013)
                                    : EdgeInsets.zero,
                                child: appDataInfo(
                                  themeProvider: themeProvider,
                                  cmh: cmh,
                                  cmw: cmw,
                                  title: appDataInfoList[index]['title'],
                                  subtitle: appDataInfoList[index]['subtitle'],
                                  url: appDataInfoList[index]['url'],
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: cmh * 0.025),

                  ///DEVELOPER CREDITS
                  Column(
                    children: [
                      Text(
                        'DEVELOPER',
                        style: GoogleFonts.josefinSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(height: cmh * 0.017),
                      Text(
                        'aBeliever | SpicierEwe',
                        style: GoogleFonts.josefinSans(
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),

                  ///Contributor CREDITS
                  contributionCredits(cmh),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Column contributionCredits(double cmh) {
    return Column(
      children: [
        SizedBox(height: cmh * 0.035),
        Text(
          'CONTRIBUTORS',
          style: GoogleFonts.josefinSans(
            fontWeight: FontWeight.bold,
            fontSize: 13.5.sp,
          ),
          maxLines: 1,
        ),
        SizedBox(height: cmh * 0.017),
        Container(
          height: cmh * 0.35,
          child: ListView.builder(
            itemCount: contributorsList.length,
            itemBuilder: (context, index) => Text(
              contributorsList[index].toString(),
              style: GoogleFonts.josefinSans(
                fontSize: 12.5.sp,
              ),
              textAlign: TextAlign.center,
              // maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }

  Card appDataInfo(
      {required double cmh,
      required themeProvider,
      required title,
      required subtitle,
      required double cmw,
      url}) {
    return Card(
      color: Colors.white,
      child: Container(
        width: cmw * .7,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.amber.shade800.withOpacity(.3)),
          borderRadius: BorderRadius.circular(cmh * 0.01),
          // image: DecorationImage(image: AssetImage('$url'), fit: BoxFit.cover),
          image:
              DecorationImage(image: AssetImage('$url'), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: EdgeInsets.all(cmh * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title.toString(),
                style: GoogleFonts.josefinSans(
                    fontSize: cmh * 0.02, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: cmh * 0.01,
              ),
              Text(
                subtitle.toString(),
                style: GoogleFonts.lato(fontSize: cmh * 0.02),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
