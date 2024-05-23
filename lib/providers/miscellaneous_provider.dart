import 'package:ahadith_collection/providers/data_provider.dart';
import 'package:ahadith_collection/providers/settings_provider.dart';
import 'package:ahadith_collection/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

class MiscellaneousProvider extends ChangeNotifier {
  ///Copy Hadith Function (copies hadith to clipboard)
  copyHadith(
      {required AsyncSnapshot snapshot,
      index,
      required snapshotData,
      required DataProvider dataProvider,
      required SettingsProvider settingsProvider,
      required context,
      required ThemeProvider themeProvider}) {
    // print('copying hadith');
    Clipboard.setData(
      ClipboardData(
        text: '${settingsProvider.selectedLanguage == 'ur' ? '' : 'Chapter iD : ' + snapshot.data[index]['babID'].truncate().toString()} \n\nChapter Name :  ${snapshot.data[index][settingsProvider.selectedLanguage == 'ur' ? 'title' : settingsProvider.selectedLanguage == 'ar' ? 'arabicBabName' : 'englishBabName'].toString()} ${settingsProvider.selectedLanguage == 'en' ? '\n\nNarrated by : ' + dataProvider.extractNarratorName(
              englishText: snapshot.data[index]['englishText'].toString(),
            ) : ''} \n\n${dataProvider.hadithFilter(text: snapshot.data[index][settingsProvider.selectedLanguage == 'ur' ? 'hadith_text' : settingsProvider.selectedLanguage == 'ar' ? "arabicText" : "englishText"])} \n\nReference :  ${dataProvider.selectedCollectionFullName.toString()} \n\nHadith No : ${settingsProvider.selectedLanguage == 'ur' ? snapshotData[index]['hadith_text'].contains(': حديث نمبر') ? snapshotData[index]['hadith_text'].toString().substring(snapshotData[index]['hadith_text'].toString().indexOf('حديث نمبر')) : snapshotData[index]['hadith_number'] : snapshot.data[index]['hadithNumber']} \n\nIn Book Reference : ${'Book ' + (settingsProvider.selectedLanguage == 'ur' ? dataProvider.selectedUrduBookNumber : dataProvider.selectedBookNumber) + ' , ' + 'Hadith ' + snapshot.data[index][settingsProvider.selectedLanguage == 'ur' ? "hadith_number" : 'hadithNumber'].toString()} \n\n${settingsProvider.selectedLanguage != 'ur' ? 'Last Updated :  ' + snapshot.data[index]['last_updated'].toString() : ''} \n\n${settingsProvider.selectedLanguage != 'ur' ? 'Grade : ' + snapshot.data[index][settingsProvider.selectedLanguage == 'ar' ? "arabicgrade1" : 'englishgrade1'] : ''}',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'Hadith copied to clipboard',
          style: TextStyle(fontSize: 10.5.sp),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  ///share hadith function( shares hadith to any platform )
  shareHadith(
      {required AsyncSnapshot snapshot,
      index,
      required snapshotData,
      required DataProvider dataProvider,
      required SettingsProvider settingsProvider,
      required context,
      required ThemeProvider themeProvider}) {
    Share.share(
      '${settingsProvider.selectedLanguage == 'ur' ? '' : 'Chapter iD : ' + snapshot.data[index]['babID'].truncate().toString()} \n\nChapter Name :  ${snapshot.data[index][settingsProvider.selectedLanguage == 'ur' ? 'title' : settingsProvider.selectedLanguage == 'ar' ? 'arabicBabName' : 'englishBabName'].toString()} ${settingsProvider.selectedLanguage == 'en' ? '\n\nNarrated by : ' + dataProvider.extractNarratorName(
            englishText: snapshot.data[index]['englishText'].toString(),
          ) : ''} \n\n${dataProvider.hadithFilter(text: snapshot.data[index][settingsProvider.selectedLanguage == 'ur' ? 'hadith_text' : settingsProvider.selectedLanguage == 'ar' ? "arabicText" : "englishText"])} \n\nReference :  ${dataProvider.selectedCollectionFullName.toString()} \n\nHadith No : ${settingsProvider.selectedLanguage == 'ur' ? snapshotData[index]['hadith_text'].contains(': حديث نمبر') ? snapshotData[index]['hadith_text'].toString().substring(snapshotData[index]['hadith_text'].toString().indexOf('حديث نمبر')) : snapshotData[index]['hadith_number'] : snapshot.data[index]['hadithNumber']} \n\nIn Book Reference : ${'Book ' + (settingsProvider.selectedLanguage == 'ur' ? dataProvider.selectedUrduBookNumber : dataProvider.selectedBookNumber) + ' , ' + 'Hadith ' + snapshot.data[index][settingsProvider.selectedLanguage == 'ur' ? "hadith_number" : 'hadithNumber'].toString()} \n\n${settingsProvider.selectedLanguage != 'ur' ? 'Last Updated :  ' + snapshot.data[index]['last_updated'].toString() : ''} \n\n${settingsProvider.selectedLanguage != 'ur' ? 'Grade : ' + snapshot.data[index][settingsProvider.selectedLanguage == 'ar' ? "arabicgrade1" : 'englishgrade1'] : ''}',
    );
  }
}
