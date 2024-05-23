import 'package:ahadith_collection/components/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import '../../screens/legal/credits.dart';
import '../../screens/legal/privacy_policy.dart';
import '../../screens/legal/terms_of_use.dart';

class AboutUS extends StatefulWidget {
  final cmh;
  final cmw;

  const AboutUS({Key? key, required this.cmw, required this.cmh})
      : super(key: key);

  @override
  State<AboutUS> createState() => _AboutUSState();
}

class _AboutUSState extends State<AboutUS> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var settingsProvider = Provider.of<SettingsProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          child: Text(
            'About US',
            style: GoogleFonts.roboto(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
                fontSize: 11.90.sp),
            // textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: widget.cmh * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            legalItems(
              themeProvider,
              context,
              itemTitle: 'Privacy Policy',
              // onPressedFunction: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const PrivacyPolicyScreen(),
              //     ),
              //   );
              // },

              onPressedFunction: () async {
                const url =
                    "https://spicierewe.vercel.app/ahadith-Collection/privacy-policy";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  // can't launch url, there is some error
                  throw "Could not launch $url";
                }
              },
            ),
            legalItems(
              themeProvider,
              context,
              itemTitle: 'CREDITS',
              onPressedFunction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreditsScreen(),
                  ),
                );
              },
            ),
            legalItems(
              themeProvider,
              context,
              itemTitle: 'TERMS OF USE',
              onPressedFunction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsOfUseScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        legalItems(themeProvider, context,
            itemTitle: 'App Version  ${settingsProvider.appVersion}',
            onPressedFunction: null),

        ///**********************************
        /// here is the other apps button
        ///*******************************************
        FlatButton(
          color: themeProvider.scaffoldBackgroundColor,
          // color: Colors.teal.withOpacity(.55),

          shape: RoundedRectangleBorder(
              // borderRadius: BorderRadius.circular(widget.cmh * 0.019),
              borderRadius: BorderRadius.circular(widget.cmh * 0.01),
              side: const BorderSide(color: Colors.blueGrey, width: 1)),
          onPressed: () async {
            const url =
                "https://play.google.com/store/apps/developer?id=SpicierEwe";
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              // can't launch url, there is some error
              throw "Could not launch $url";
            }
          },
          // decoration: BoxDecoration(color: Colors.teal.withOpacity(.5)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: widget.cmh * 0.025,
                  child: Image.asset(
                    settingsProvider.darkTheme
                        ? 'images/google-play_colored.png'
                        : 'images/google_play.png',
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  width: widget.cmh * 0.023,
                ),
                Text(
                  'OTHER APPS',
                  style: TextStyle(
                      color: Colors.blueGrey,
                      // color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.5.sp),
                )
              ],
            ),
          ),
        ),
        /// link to developers website
        FlatButton(
            shape: RoundedRectangleBorder(
              // borderRadius: BorderRadius.circular(widget.cmh * 0.019),
                borderRadius: BorderRadius.circular(widget.cmh * 0.01),
                side: const BorderSide(color: Colors.blueGrey, width: 1)),
            color: themeProvider.scaffoldBackgroundColor,
            onPressed: () async {
              const url =
                  "https://spicierewe.vercel.app/";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                // can't launch url, there is some error
                throw "Could not launch $url";
              }
            },

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.link,
                  color: themeProvider.settingsFontColor,
                ),
                SizedBox(
                  width: widget.cmw * 0.03,
                ),
                Text(
                  'Developer\'s Website',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 10.1.sp),
                )
              ],
            )),
        ///
        ///check for updates button
        FlatButton(
            onPressed: () {
              settingsProvider.checkForUpdate(context: context);
            },
            child: Row(
              children: [
                Icon(
                  Icons.update,
                  color: themeProvider.settingsFontColor,
                ),
                SizedBox(
                  width: widget.cmw * 0.03,
                ),
                Text(
                  'Check for updates',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 10.1.sp),
                )
              ],
            )),
        CustomWidgets()
            .customDivider(themeProvider: themeProvider, cmh: widget.cmh),

        


      ],
    );
  }

  FlatButton legalItems(ThemeProvider themeProvider, BuildContext context,
      {required itemTitle, required onPressedFunction}) {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.cmh * 0.019),
          side: const BorderSide(color: Colors.blueGrey, width: 1)),
      color: themeProvider.settingsBoxColor,
      onPressed: onPressedFunction,
      child: Text(
        '$itemTitle',
        style: TextStyle(color: Colors.blueGrey, fontSize: 10.1.sp),
      ),
    );
  }
}
