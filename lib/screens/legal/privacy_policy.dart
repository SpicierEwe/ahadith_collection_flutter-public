import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../components/custom_widgets.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
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
              simpleStringTitle: 'PRIVACY POLICY'),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // permissionsInfo(
              //     cmh: cmh,
              //     cmw: cmw,
              //     title: 'Needed Access Microphone (OPTIONAL)',
              //     description:
              //         'The Microphone is NEEDED while searching for Hadiths. You only need to enable microphone if you want to search the al-quran with your voice , otherwise you can completely neglect the microphone and can TYPE TO SEARCH.'),
              permissionsInfo(
                  cmh: cmh,
                  cmw: cmw,
                  title: 'REQUIRES INTERNET FOR CONTACT PORTALS',
                  description:
                      'The App is Completely OFFLINE but you require internet to contact us through contacting PORTALS.'),
              permissionsInfo(
                  cmh: cmh,
                  cmw: cmw,
                  title: 'Regarding your Private Information',
                  description:
                      'We Do not Collect Any of Your Data either Knowingly Or unknowingly. And Why Would WE ? I haven\'t created this APP to DESTROY myself ON the Day OF JUDGEMENT but rather to BE CLOSE TO MY LORD THE MOST HIGH (ALLAHUAKBAR) , May Allah (The Almighty) Forgive us All AND ADMIT us all TO JANNATUL FIRDAUSI AL AALA.'),
              const Text('*** * ***'),
            ],
          ),
        );
      },
    );
  }

  Padding permissionsInfo(
      {required title, required description, required cmh, required cmw}) {
    return Padding(
      padding: EdgeInsets.only(
        left: cmh * 0.03,
        right: cmh * 0.03,
        top: cmh * 0.015,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '$title',
            style: GoogleFonts.raleway(
                fontSize: 13.sp, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: cmh * 0.01,
          ),
          Text(
            '$description',
            style: GoogleFonts.raleway(fontSize: 11.sp),
            textAlign: TextAlign.left,
          ),
          const Divider(),
        ],
      ),
    );
  }
}
