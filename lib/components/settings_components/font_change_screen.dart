import 'package:ahadith_collection/components/custom_widgets.dart';
import 'package:ahadith_collection/components/remove_listview_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../providers/data_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';

class FontChangeScreen extends StatefulWidget {
  const FontChangeScreen({Key? key}) : super(key: key);

  @override
  State<FontChangeScreen> createState() => _FontChangeScreenState();
}

class _FontChangeScreenState extends State<FontChangeScreen> {
  @override
  void initState() {
    Provider.of<SettingsProvider>(context, listen: false)
        .fontSizeTextSampleSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final cmh = constraints.maxHeight;
        final cmw = constraints.maxWidth;
        return Scaffold(
          backgroundColor: themeProvider.settingsScaffoldColor,
          appBar: CustomWidgets().customAppBar(
            themeProvider: themeProvider,
            showFontResetIcon: true,
            showSettings: false,
            context: context,
            cmh: cmh,
            cmw: cmw,
            settingsProvider: settingsProvider,
            simpleStringTitle: 'FontSize',
          ),
          body: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///***************************************
              ///TEXT SAMPLE DISPLAYED HERE CHANGING DIAL
              ///***************************************
              Container(
                height: cmh * 0.65,
                decoration: const BoxDecoration(
                    // color: Colors.red,
                    ),
                // child: Text(settingsProvider.fontSizeSample.toString() , style: TextStyle(
                //   fontSize: settingsProvider.fontSize
                // ),),
                child: ScrollConfiguration(
                  behavior: RemoveListViewGlow(),
                  child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        if (settingsProvider.fontSizeSample.isEmpty) {
                          return CustomWidgets().customProgressIndicator(
                              themeProvider: themeProvider);
                        } else {
                          return hadithCard(
                              cmh,
                              cmw,
                              themeProvider,
                              dataProvider,
                              0,
                              settingsProvider,
                              settingsProvider.selectedLanguage,
                              settingsProvider.fontSizeSample);
                        }
                      }),
                ),
              ),

              ///***************************************
              ///FONT CHANGING DIAL
              ///***************************************
              fontChangingDial(cmw, settingsProvider, cmh)
            ],
          ),
        );
      },
    );
  }

  ///***************************************
  ///
  ///WIDGET FUNCTION START FROM HERE
  ///
  ///***************************************

  Widget fontChangingDial(
      double cmw, SettingsProvider settingsProvider, double cmh) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: cmh * 0.03),
        child: SfRadialGauge(enableLoadingAnimation: true, axes: <RadialAxis>[
          RadialAxis(
              minimum: 11.sp,
              maximum: 19.sp,
              startAngle: 180,
              endAngle: 360,
              showLabels: false,
              showTicks: false,
              radiusFactor: 1,
              axisLineStyle: AxisLineStyle(
                  cornerStyle: CornerStyle.bothFlat,
                  color: Colors.black12,
                  thickness: cmw * 0.029),
              pointers: <GaugePointer>[
                RangePointer(
                  value: settingsProvider.fontSize,
                  cornerStyle: CornerStyle.bothFlat,
                  width: 12,
                  sizeUnit: GaugeSizeUnit.logicalPixel,
                  color: Colors.orangeAccent,
                  gradient: SweepGradient(
                    colors: <Color>[
                      // Color(0XFFFFD180),
                      // Color(0XFFFFAB40)
                      Colors.teal.withOpacity(.5),
                      Colors.teal,
                    ],
                    stops: const <double>[0.25, 0.75],
                  ),
                ),
                MarkerPointer(
                    animationType: AnimationType.ease,
                    value: settingsProvider.fontSize,
                    enableDragging: true,
                    onValueChanged: (value) async {
                      settingsProvider.changeFontSize(value: value);
                    },
                    markerHeight: cmh * 0.025,
                    markerWidth: cmw * 0.05,
                    markerType: MarkerType.circle,
                    color: const Color(0XFFFFAB40),
                    borderWidth: 2,
                    borderColor: Colors.white54)
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    angle: 90,
                    // axisValue: 5,
                    // positionFactor: 0.1,
                    widget: Text(
                        settingsProvider.fontSize.truncate().toString(),
                        style: GoogleFonts.josefinSans(
                            fontSize: 29.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal)))
              ])
        ]),
      ),
    );
  }

  ///Hadith Card
  Container hadithCard(
      double cmh,
      double cmw,
      ThemeProvider themeProvider,
      DataProvider dataProvider,
      int index,
      SettingsProvider settingsProvider,
      String selectedLanguage,
      fontSizeSampleData) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.teal,
              spreadRadius: -cmh * 0.041,
              blurRadius: cmh * 0.021)
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: cmw,
            child: Padding(
              padding: EdgeInsets.only(
                // bottom: cmh * 0.015,
                left: cmw * 0.05,
                top: cmh * 0.015,
                right: cmw * 0.05,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(cmh * 0.025),
                  topRight: Radius.circular(cmh * 0.025),
                ),
                child: Directionality(
                  textDirection: settingsProvider.selectedLanguage !='en'? TextDirection.rtl:TextDirection.ltr,
                  child: Container(
                    ///Hadith Box Color
                    decoration:
                        BoxDecoration(color: themeProvider.hadithScreenCardColor),
                    child: Padding(
                      padding: EdgeInsets.all(cmh * 0.015),
                      child: Column(
                        children: [
                          ///***************************
                          ///Narrator displayed is here
                          ///***************************
                          Padding(
                            padding: EdgeInsets.all(cmh * 0.01),
                            child: Text(
                              'Narrated by',
                              style:
                                  TextStyle(fontSize: 11.sp, color: Colors.teal),
                            ),
                          ),

                          if (dataProvider.extractNarratorName(
                                    englishText: fontSizeSampleData[index]
                                            ['englishText']
                                        .toString(),
                                  ) !=
                                  '' &&
                              (settingsProvider.selectedLanguage == 'ur' ||
                                  settingsProvider.selectedLanguage != 'ar'))
                            Container(
                              padding: EdgeInsets.only(bottom: cmh * 0.01),
                              child: Text(
                                dataProvider.extractNarratorName(
                                  englishText: fontSizeSampleData[index]
                                          ['englishText']
                                      .toString(),
                                ),
                                style: GoogleFonts.roboto(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                          SizedBox(
                            height: cmh * 0.01,
                          ),

                          ///***************************
                          ///Hadith displayed is here
                          ///***************************
                          Text(
                            dataProvider
                                    .hadithFilter(
                                        text: fontSizeSampleData[index][
                                            settingsProvider.selectedLanguage ==
                                                    'ur'
                                                ? 'hadith_text'
                                                : settingsProvider
                                                            .selectedLanguage ==
                                                        'ar'
                                                    ? "arabicText"
                                                    : "englishText"])
                                    .toString()
                                    .substring(0, 145)
                                    .trim() +
                                ' ..... .',
                            style:
                                settingsProvider.changeStyleAccordingToLanguage(
                                    settingsProvider: settingsProvider,
                                    themeProvider: themeProvider),
                            textAlign: TextAlign.justify,
                          ),

                          ///
                          // Html(
                          //   data: snapshotData[index]
                          //           ['englishText']
                          //       .toString(),
                          //   style: {
                          //     'html': Style(
                          //         color: Colors.teal),
                          //     'p': Style(
                          //       fontSize: FontSize(15.sp),
                          //       color: Colors.black
                          //     ),
                          //     'b':Style(
                          //         fontSize: FontSize(15.sp),
                          //         color: Colors.red
                          //     ),
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: cmh * 0.015,
              left: cmw * 0.05,
              right: cmw * 0.05,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(cmh * 0.025),
                bottomLeft: Radius.circular(cmh * 0.025),
              ),
              child: Container(
                padding: EdgeInsets.only(
                  top: cmh * 0.015,
                  bottom: cmh * 0.015,
                  left: cmw * 0.03,
                  right: cmw * 0.03,
                ),
                color: Colors.teal.withOpacity(.75),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              references(title: 'Reference', cmh: cmh, cmw: cmw)
                            ],
                          ),
                        ),
                        SizedBox(width: cmw * 0.07),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Expanded(
                                child: referencesDynamic(
                                  reference:
                                      settingsProvider.selectedLanguage == 'ur'
                                          ? 'صحیح بخاری'
                                          : settingsProvider.selectedLanguage ==
                                                  'ar'
                                              ? 'صحيح البخاري'
                                              : 'Sahih al-Bukhari',
                                  dataProvider: dataProvider,
                                  cmw: cmw,
                                  cmh: cmh,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: cmh * 0.005,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              references(title: 'Hadith No', cmh: cmh, cmw: cmw)
                            ],
                          ),
                        ),
                        SizedBox(width: cmw * 0.07),

                        ///if urdu display this widget
                        if (selectedLanguage == 'ur')
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Expanded(
                                  child: referencesDynamic(
                                      reference: fontSizeSampleData[index]
                                                  ['hadith_text']
                                              .contains(': حديث نمبر')
                                          ? fontSizeSampleData[index]
                                                  ['hadith_text']
                                              .toString()
                                              .substring(
                                                  fontSizeSampleData[index]
                                                          ['hadith_text']
                                                      .toString()
                                                      .indexOf('حديث نمبر'))
                                          : fontSizeSampleData[index]
                                              ['hadith_number'],
                                      dataProvider: dataProvider,
                                      cmh: cmh,
                                      cmw: cmw),
                                ),
                              ],
                            ),
                          ),

                        ///if english or arabic display this widget
                        if (selectedLanguage != 'ur')
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Expanded(
                                  child: referencesDynamic(
                                      reference: fontSizeSampleData[index]
                                          ['hadithNumber'],
                                      dataProvider: dataProvider,
                                      cmh: cmh,
                                      cmw: cmw),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: cmh * 0.003,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              references(
                                  title: 'In Book Reference',
                                  cmh: cmh,
                                  cmw: cmw),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              SizedBox(width: cmw * .047),
                              Expanded(
                                child: referencesDynamic(
                                    reference: 'Book ' +
                                                settingsProvider
                                                    .selectedLanguage ==
                                            'ur'
                                        ? dataProvider.selectedUrduBookNumber
                                        : 'Book ' +
                                            dataProvider.selectedBookNumber +
                                            ' , ' +
                                            'Hadith ' +
                                            fontSizeSampleData[index][
                                                    selectedLanguage == 'ur'
                                                        ? "hadith_number"
                                                        : 'hadithNumber']
                                                .toString(),
                                    dataProvider: dataProvider,
                                    cmh: cmh,
                                    cmw: cmw),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: cmh * 0.003,
                    ),
                    if (selectedLanguage != 'ur')
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                references(title: 'Urn', cmh: cmh, cmw: cmw),
                              ],
                            ),
                          ),
                          SizedBox(width: cmw * 0.07),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Expanded(
                                  child: referencesDynamic(
                                    cmw: cmw,
                                    cmh: cmh,
                                    dataProvider: dataProvider,
                                    reference: fontSizeSampleData[index][
                                            selectedLanguage == 'ar'
                                                ? "arabicURN"
                                                : "englishURN"]
                                        .toString(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: cmh * 0.003,
                    ),
                    if (selectedLanguage != 'ur')
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                references(
                                    title: 'Last Updated', cmh: cmh, cmw: cmw),
                              ],
                            ),
                          ),
                          SizedBox(width: cmw * 0.07),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                referencesDynamic(
                                  reference: fontSizeSampleData[index]
                                          ['last_updated']
                                      .toString(),
                                  dataProvider: dataProvider,
                                  cmh: cmh,
                                  cmw: cmw,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: cmh * 0.003,
                    ),
                    if (selectedLanguage != 'ur')
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                references(title: 'Grade', cmw: cmw, cmh: cmh),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: cmw * 0.07,
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  ":  " +
                                      fontSizeSampleData[index][
                                              selectedLanguage == 'ar'
                                                  ? "arabicgrade1"
                                                  : 'englishgrade1']
                                          .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.sp),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding chapterNumberDisplay(
      double cmw,
      double cmh,
      ThemeProvider themeProvider,
      SettingsProvider settingsProvider,
      AsyncSnapshot<dynamic> snapshot,
      int index) {
    return Padding(
      padding: EdgeInsets.only(
          left: cmw * 0.05,
          right: cmw * 0.05,
          top: cmh * 0.035,
          bottom: cmh * 0.009),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Chapter ID ',
              style: TextStyle(
                color: themeProvider.hadithScreenFontColor,
                fontSize: 11.sp,
              ),
            ),
            WidgetSpan(
              child: Container(
                padding: const EdgeInsets.only(bottom: 4.3),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: cmh * .011,
                  color: themeProvider.hadithScreenFontColor,
                ),
              ),
            ),
            const TextSpan(
              text: ' ',
            ),

            /// displaying ChapterID here
            if (settingsProvider.selectedLanguage != 'ur')
              TextSpan(
                  text: snapshot.data[index]['babID'].truncate().toString(),
                  style: TextStyle(
                      color: themeProvider.hadithScreenFontColor,
                      fontWeight: FontWeight.bold)),
          ],
        ),
        // textAlign: TextAlign.left,
      ),
    );
  }

  Padding bookNumberNameDisplay(
      double cmw,
      double cmh,
      ThemeProvider themeProvider,
      SettingsProvider settingsProvider,
      DataProvider dataProvider,
      int index) {
    return Padding(
      padding: EdgeInsets.only(
        left: cmw * 0.05,
        right: cmw * 0.05,
        top: cmh * 0.03,
      ),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'BOOK NO  ',
                  style: TextStyle(
                    color: themeProvider.hadithScreenFontColor,
                    fontSize: 11.sp,
                  ),
                ),
                WidgetSpan(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4.3),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: cmh * .011,
                      color: themeProvider.hadithScreenFontColor,
                    ),
                  ),
                ),
                const TextSpan(
                  text: ' ',
                ),

                /// displaying BOOK NUMBER here
                if (settingsProvider.selectedLanguage != 'ur')
                  TextSpan(
                      text: dataProvider.selectedBookNumber,
                      style: TextStyle(
                          color: themeProvider.hadithScreenFontColor,
                          fontWeight: FontWeight.bold)),

                /// displaying ChapterID here (for urdu)
                if (settingsProvider.selectedLanguage == 'ur')
                  TextSpan(
                      text: dataProvider.selectedUrduBookNumber,
                      style: TextStyle(
                          color: themeProvider.hadithScreenFontColor,
                          fontWeight: FontWeight.bold)),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: cmh * 0.007),
            child: Text(
              dataProvider.selectedBookName,
              style: TextStyle(fontSize: 13.sp, color: Colors.teal),
            ),
          )
        ],
      ),
    );
  }

  Padding referencesDynamic(
      {required DataProvider dataProvider,
      required reference,
      required cmh,
      required cmw}) {
    return Padding(
      padding: EdgeInsets.only(bottom: cmh * 0.003),
      child: Text(
        ':  $reference',
        style: TextStyle(fontSize: 10.1.sp),
      ),
    );
  }

  Padding references({required String title, required cmh, required cmw}) =>
      Padding(
        padding: EdgeInsets.only(bottom: cmh * 0.003),
        child: Text(
          title,
          style: TextStyle(fontSize: 10.1.sp),
        ),
      );
}
