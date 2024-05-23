import 'dart:convert';
import 'package:ahadith_collection/components/custom_widgets.dart';
import 'package:ahadith_collection/components/remove_listview_glow.dart';
import 'package:ahadith_collection/providers/contact_portal_provider.dart';
import 'package:flutter/material.dart';

// import 'dart:ffi';
import 'package:ahadith_collection/components/custom_form.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../providers/bookmark_provider.dart';
import '../../../providers/data_provider.dart';
import '../../../providers/miscellaneous_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/theme_provider.dart';

class HadithReport extends StatefulWidget {
  final hadithData;

  const HadithReport({
    this.hadithData,
    Key? key,
  }) : super(key: key);

  @override
  _HadithReportState createState() => _HadithReportState();
}

enum Issue {
  misMatchedCollectionName,
  misMatchedCollectionNumber,
  misMatchedBookNumber,
  misMatchedChapterNumber,
  misMatchedHadithNumber,
  misMatchedChapterName,
  misMatchedNarrator,
  invalidUrnNumber,
  specify
}

class _HadithReportState extends State<HadithReport> {
  ///specified issue message
  String specifiedIssueMessage = '';

  Color unSelectedRadioColor = Colors.white;
  Color selectedRadioColor = Colors.red;

  ///here are the enums for issue
  int selectedRadioButton = 1;

  Issue reportedIssue = Issue.misMatchedCollectionNumber;
  final _form = GlobalKey<FormState>();

  ///here is the show specify flag
  bool showSpecifyContainer = false;

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    BookMarkProvider bookMarkProvider = Provider.of<BookMarkProvider>(context);
    ContactPortalProvider contactPortalProvider =
        Provider.of<ContactPortalProvider>(context);
    MiscellaneousProvider miscellaneousProvider =
        Provider.of<MiscellaneousProvider>(context);
    final mq = MediaQuery.of(context).size;

    void initState() {
      super.initState();
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        selectedRadioButton = 1;

        return true;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cmh = constraints.maxHeight;
          final cmw = constraints.maxWidth;

          return Scaffold(
            backgroundColor: themeProvider.scaffoldBackgroundColor,
            appBar: CustomWidgets().customAppBar(
                themeProvider: themeProvider,
                simpleStringTitle: 'REPORT',
                searchIcon: false,
                showSettings: false,
                context: context,
                cmh: cmh,
                cmw: cmw,
                settingsProvider: settingsProvider),
            body: Form(
              key: _form,
              child: ScrollConfiguration(
                behavior: RemoveListViewGlow(),
                child: ListView(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            // bottom: cmh * 0.05,
                            top: cmh * 0.015,
                            left: cmw * 0.05,
                            right: cmw * 0.05,
                          ),
                          padding: EdgeInsets.only(
                            bottom: cmh * 0.015,
                            top: cmh * 0.015,
                            left: cmw * 0.05,
                            right: cmw * 0.05,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(cmh * 0.025),

                            /// radio button background is here

                            color: Colors.teal.withOpacity(0.7),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              customRadio(
                                  themeProvider: themeProvider,
                                  settingsProvider: settingsProvider,
                                  cmh: cmh,
                                  cmw: cmw,
                                  value: 1,
                                  radioIssueTitle:
                                      ' Mismatched Collection Name'),
                              customRadio(
                                  themeProvider: themeProvider,
                                  settingsProvider: settingsProvider,
                                  cmh: cmh,
                                  cmw: cmw,
                                  value: 2,
                                  radioIssueTitle:
                                      ' Mismatched Collection Number'),
                              customRadio(
                                  themeProvider: themeProvider,
                                  settingsProvider: settingsProvider,
                                  cmh: cmh,
                                  cmw: cmw,
                                  value: 3,
                                  radioIssueTitle: 'Mismatched Book Number'),
                              customRadio(
                                  themeProvider: themeProvider,
                                  settingsProvider: settingsProvider,
                                  cmh: cmh,
                                  cmw: cmw,
                                  value: 4,
                                  radioIssueTitle: 'Mismatched Chapter Name'),
                              customRadio(
                                  themeProvider: themeProvider,
                                  settingsProvider: settingsProvider,
                                  cmh: cmh,
                                  cmw: cmw,
                                  value: 5,
                                  radioIssueTitle: 'Mismatched Chapter Number'),
                              customRadio(
                                  themeProvider: themeProvider,
                                  settingsProvider: settingsProvider,
                                  cmh: cmh,
                                  cmw: cmw,
                                  value: 6,
                                  radioIssueTitle: 'Mismatched Hadith Number'),
                              customRadio(
                                  themeProvider: themeProvider,
                                  settingsProvider: settingsProvider,
                                  cmh: cmh,
                                  cmw: cmw,
                                  value: 7,
                                  radioIssueTitle: 'Mismatched Narrator'),
                              customRadio(
                                  themeProvider: themeProvider,
                                  settingsProvider: settingsProvider,
                                  cmh: cmh,
                                  cmw: cmw,
                                  value: 8,
                                  radioIssueTitle: 'Invalid URN Number'),
                              customRadio(
                                  themeProvider: themeProvider,
                                  settingsProvider: settingsProvider,
                                  cmh: cmh,
                                  cmw: cmw,
                                  value: 9,
                                  radioIssueTitle: 'Specify'),

                              ///********************************
                              ///Specify container is here
                              ///*****************************
                              if (showSpecifyContainer == true)
                                CustomWidgets().customInputField(
                                  optionalMaxLength: 999,
                                  hintString:
                                      'Please Specify the problem here....... ',
                                  optionalMaxLines: 9,
                                  cmw: cmw,
                                  context: context,
                                  cmh: cmh,
                                  validatorFunction: (value) {
                                    {
                                      if (value == null || value.isEmpty) {
                                        return 'Please specify the issue';
                                      } else {
                                        setState(() {
                                          specifiedIssueMessage = value;
                                        });
                                      }
                                    }
                                  },
                                  themeProvider: themeProvider,
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(cmh * 0.05),
                          child: FlatButton(
                            color: Colors.pink,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(cmh * 0.011)),
                            child: Text(
                              'SUBMIT',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 10.5.sp),
                            ),
                            onPressed: () {
                              if (reportedIssue == Issue.specify) {
                                final isValid = _form.currentState!.validate();
                                if (isValid) {
                                  // print('is valid');

                                  contactPortalProvider.reportHadith(
                                    specificIssueExplained:
                                        specifiedIssueMessage,

                                    ///collection name only required for ur cause database has no collection Name
                                    collectionName:
                                        dataProvider.selectedCollectionFullName,

                                    ///
                                    issueType: reportedIssue,
                                    bookName: dataProvider.selectedBookName,
                                    lang: settingsProvider.selectedLanguage,
                                    reportedHadithData: widget.hadithData[0],
                                    reportedIssue: reportedIssue,
                                    context: context,
                                  );
                                } else {
                                  // print('not valid');
                                }
                              } else {
                                ///if the option is not specify then it is sent
                                contactPortalProvider.reportHadith(

                                    ///collection name only required for ur cause database has no collection Name
                                    collectionName:
                                        dataProvider.selectedCollectionFullName,

                                    ///
                                    issueType: reportedIssue,
                                    bookName: dataProvider.selectedBookName,
                                    lang: settingsProvider.selectedLanguage,
                                    reportedHadithData: widget.hadithData[0],
                                    reportedIssue: reportedIssue,
                                    context: context);
                              }
                              _form.currentState!.reset();
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget customRadio(
      {required ThemeProvider themeProvider,
      required SettingsProvider settingsProvider,
      required value,
      required String radioIssueTitle,
      required cmh,
      required cmw}) {
    return Row(
      children: [
        Theme(
          data: ThemeData(
            unselectedWidgetColor: unSelectedRadioColor,
          ),
          child: Transform.scale(
            scale: cmh * 0.0013,
            child: Padding(
              padding: EdgeInsets.zero,
              child: Radio<int>(
                  activeColor: selectedRadioColor,

                  // fillColor: MaterialStateProperty.all(unSelectedRadioColor),
                  value: value,
                  groupValue: selectedRadioButton,
                  onChanged: (value) async {
                    setState(() {
                      selectedRadioButton = value!;
                      if (value == 9) {
                        showSpecifyContainer = true;
                      } else {
                        showSpecifyContainer = false;
                      }
                    });

                    switch (value) {
                      case 1:
                        {
                          reportedIssue = Issue.misMatchedCollectionName;
                        }
                        break;
                      case 2:
                        {
                          reportedIssue = Issue.misMatchedCollectionNumber;
                        }
                        break;
                      case 3:
                        {
                          reportedIssue = Issue.misMatchedBookNumber;
                        }
                        break;
                      case 4:
                        {
                          reportedIssue = Issue.misMatchedChapterName;
                        }
                        break;
                      case 5:
                        {
                          reportedIssue = Issue.misMatchedChapterNumber;
                        }
                        break;
                      case 6:
                        {
                          reportedIssue = Issue.misMatchedHadithNumber;
                        }
                        break;
                      case 7:
                        {
                          reportedIssue = Issue.misMatchedNarrator;
                        }
                        break;
                      case 8:
                        {
                          reportedIssue = Issue.invalidUrnNumber;
                        }
                        break;
                      case 9:
                        {
                          reportedIssue = Issue.specify;
                        }
                        break;
                    }
                    // print(value);
                    // print(reportedIssue);
                  }),
            ),
          ),
        ),
        Text(
          radioIssueTitle.toString(),
          style: GoogleFonts.lato(
              fontSize: 11.7.sp,
              fontWeight: FontWeight.w500,
              color: themeProvider.settingsFontColor),
        ),
      ],
    );
  }
}
