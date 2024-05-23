import 'dart:convert';
import 'package:ahadith_collection/screens/display_screens/contact_us_screens/hadith_report.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:date_format/date_format.dart';

class ContactPortalProvider extends ChangeNotifier {
  ///
  /// device report sent time initialization
  DateTime now = DateTime.now();

  bool loadingScreen = false;

  toggleLoadingScreen({loadingScreenBool}) {
    loadingScreen = loadingScreenBool;
    notifyListeners();
  }

  successfulMessageSnackBar(context, formKey) {
    toggleLoadingScreen(loadingScreenBool: false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Submitted Successfully',
            textAlign: TextAlign.center,
          )),
    );
    formKey.currentState?.reset();
  }

  failedMessageSnackBar(context) {
    toggleLoadingScreen(loadingScreenBool: false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Submission Failed! Please try again later',
            textAlign: TextAlign.center,
          )),
    );
  }

  ///[portalType] is only to identify and  send data to specific categories in data base
  gatherInformation(
      {incomingName,
      incomingEmail,
      incomingTitle,
      incomingExplainedInDetail,
      portalType,
      context,
      formKey}) async {
    ///getting time
    String formattedDate = (DateFormat.yMMMMEEEEd().add_jms().format(now));

    Map gatheredData = {
      'name': incomingName,
      'email': incomingEmail,
      'title': incomingTitle,
      'explained_in_detail': incomingExplainedInDetail,
      'sent_date': formattedDate
    };
    if (portalType == 'report') {
      print('its a report ');

      final url = Uri.parse(
          'https://ahadiths-reporting-portal-default-rtdb.firebaseio.com/portals/report_portal.json');

      http.post(url, body: jsonEncode(gatheredData)).catchError((err) {
        failedMessageSnackBar(context);
      }).then((value) => successfulMessageSnackBar(context, formKey));
    }
    if (portalType == 'feature_suggestion') {
      print('its a feature_suggestion ');

      final url = Uri.parse(
          'https://ahadiths-reporting-portal-default-rtdb.firebaseio.com/portals/feature_suggestion_portal.json');

      http.post(url, body: jsonEncode(gatheredData)).catchError((err) {
        failedMessageSnackBar(context);
      }).then((value) => successfulMessageSnackBar(context, formKey));
    }

    if (portalType == 'contact_us') {
      print('its a contact us ');

      final url = Uri.parse(
          'https://ahadiths-reporting-portal-default-rtdb.firebaseio.com/portals/contact_us_portal.json');

      http.post(url, body: jsonEncode(gatheredData)).catchError((err) {
        failedMessageSnackBar(context);
      }).then((value) => successfulMessageSnackBar(context, formKey));
    }
    // print(gatheredData);
  }

  ///****************************************************
  ///****************************************************
  ///****************************************************
  ///****************************************************
  ///****************************************************
  ///****************************************************
  ///****************************************************
  ///****************************************************
  ///****************************************************
  ///****************************************************
  ///
  /// individual hadith report
  ///
  ///*******************************************************************
  ///*******************************************************************
  ///*******************************************************************
  ///*******************************************************************
  ///*******************************************************************
  ///*******************************************************************

  //todo posting radio report here
  reportHadith(
      {specificIssueExplained,
      required lang,
      required reportedHadithData,
      required reportedIssue,
      required bookName,
      required issueType,
      required context,
      required collectionName}) async {
    switch (lang) {
      case 'en':
        {
          hadithReportStructure(
              lang: 'en',
              collectionFullName: reportedHadithData['collection'],
              bookName: bookName,
              bookNumber: reportedHadithData['bookNumber'],
              chapterName: reportedHadithData['englishBabName'],
              chapterId: reportedHadithData['babID'],
              hadithNumber: reportedHadithData['hadithNumber'],
              urn: reportedHadithData['englishURN'],
              reportedIssue: issueType,
              grade: reportedHadithData['englishgrade1'],

              ///only posted when user reports through Issue.specify option
              specificIssueExplained: specificIssueExplained.toString(),
              context: context);
        }
        break;
      case 'ar':
        {
          hadithReportStructure(
              lang: 'ar',
              collectionFullName: reportedHadithData['collection'],
              bookName: bookName,
              bookNumber: reportedHadithData['bookNumber'],
              chapterName: reportedHadithData['arabicBabName'],
              chapterId: reportedHadithData['babID'],
              hadithNumber: reportedHadithData['hadithNumber'],
              urn: reportedHadithData['arabicURN'],
              grade: reportedHadithData['englishgrade1'],
              reportedIssue: issueType,

              ///only posted when user reports through Issue.specify option
              specificIssueExplained: specificIssueExplained.toString(),
              context: context);
        }
        break;
      case 'ur':
        {
          hadithReportStructure(
              lang: 'ur',
              collectionFullName: collectionName,
              bookName: bookName,
              bookNumber: reportedHadithData['book_id'],
              chapterName: reportedHadithData['title'],
              chapterId: reportedHadithData['babID'],

              ///i've to this in order to get the hadith number in the urdu cause hadith numbers provided
              ///in the urdu hadith database are not correct so im extracting them frm the hadith text as
              /// in the end of the hadith text they have been provided correctly
              hadithNumber:
                  reportedHadithData['hadith_text'].contains(': حديث نمبر')
                      ? reportedHadithData['hadith_text'].toString().substring(
                          reportedHadithData['hadith_text']
                              .toString()
                              .indexOf('حديث نمبر'))
                      : reportedHadithData['hadith_number'],
              reportedIssue: issueType,

              ///only posted when user reports through Issue.specify option
              specificIssueExplained: specificIssueExplained.toString(),
              context: context);
        }
        break;
    }
  }

  hadithReportStructure({
    required lang,
    specificIssueExplained,
    reportedIssue,
    collectionFullName,
    bookNumber,
    bookName,
    chapterId,
    chapterName,
    hadithNumber,
    urn,
    grade,
    context,
  }) async {
    String formattedDate = (DateFormat.yMMMMEEEEd().add_jms().format(now));

    try {
      var url = Uri.parse(
          'https://ahadiths-reporting-portal-default-rtdb.firebaseio.com/reported_hadith/${reportedIssue == Issue.specify ? lang + "/critical" : lang + '/not_critical'}.json');
      if (reportedIssue != Issue.specify) {
        http.post(
          url,
          body: jsonEncode(
            {
              'sent_time': formattedDate,
              'problemIn': {
                'collectionName': collectionFullName.toString(),
                'bookNumber': bookNumber.toString(),
                'bookName': bookName.toString(),
                'chapterId': chapterId.toString(),
                'chapterName': chapterName.toString(),
                'hadithNumber': hadithNumber.toString(),
                'grade': grade,
                'urn': urn.toString(),
              },
              'reportedIssue': reportedIssue.toString()
            },
          ),
        );
      } else {
        ///this is posted when the user has reported through Issue.specify
        http.post(
          url,
          body: jsonEncode(
            {
              'sent_time': formattedDate,
              'problemIn': {
                'collectionName': collectionFullName.toString(),
                'bookNumber': bookNumber.toString(),
                'bookName': bookName.toString(),
                'chapterId': chapterId.toString(),
                'chapterName': chapterName.toString(),
                'hadithNumber': hadithNumber.toString(),
                'grade': grade,
                'urn': urn.toString(),
              },
              'issue_explained': specificIssueExplained,
              'reportedIssue': reportedIssue.toString()
            },
          ),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Issue Reported Successfully',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } catch (err) {
      print('error white posting radio report = ' + err.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Something Gone Wrong',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
