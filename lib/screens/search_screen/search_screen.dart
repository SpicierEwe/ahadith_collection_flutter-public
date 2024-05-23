import 'package:ahadith_collection/components/custom_widgets.dart';
import 'package:ahadith_collection/components/remove_listview_glow.dart';
import 'package:ahadith_collection/components/subString_highlight.dart';
import 'package:ahadith_collection/providers/search_provider.dart';
import 'package:ahadith_collection/screens/search_screen/search_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:html/parser.dart' show parse;
import '../../providers/data_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

enum Language {
  english,
  urdu,
  arabic,
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    Provider.of<SearchProvider>(context, listen: false)
        .fetchCollections(context: context, fetchInInitState: true);
    Provider.of<SearchProvider>(context, listen: false)
        .defaultSearchSelectedCollectionName(isInitState: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    SearchProvider searchProvider = Provider.of<SearchProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        searchProvider.toggleShowSearchFilter(value: true);
        searchProvider.toggleShowSearchResultBox(value: false);
        return true;
      },
      child: LayoutBuilder(builder: (context, constraints) {
        final cmh = constraints.maxHeight;
        final cmw = constraints.maxWidth;
        return Scaffold(
          backgroundColor: themeProvider.scaffoldBackgroundColor,
          appBar: CustomWidgets().customAppBar(
              themeProvider: themeProvider,
              appbarColor: themeProvider.settingsAppBarColor,
              searchIcon: false,
              simpleStringTitle: 'Search',
              context: context,
              cmh: cmh,
              cmw: cmw,
              settingsProvider: settingsProvider),
          body: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: cmh * 0.03),

                    ///***********************************************
                    ///INPUT FIELD        ///////////////////////////
                    ///******************************************************
                    child: Form(
                        child: Column(
                      children: [
                        customInputField(
                            settingsProvider: settingsProvider,
                            optionalMaxLines: 1,
                            optionalTextInputType: TextInputType.number,
                            labelName: 'search',
                            hintString: 'Enter Hadith Number....',
                            cmw: cmw,
                            context: context,
                            cmh: cmh,
                            validatorFunction: () {},
                            onChangedFunction: (value) {
                              if (value.isNotEmpty) {
                                searchProvider.toggleShowSearchFilter(
                                    value: false);
                                searchProvider.updateSearchedHadithNumber(
                                    value: value.toString().trim());

                                ///showing ShowSearchResultDisplayBox when the search value is not empty
                                searchProvider.toggleShowSearchResultBox(
                                    value: true);
                                // print(value);
                              } else {
                                // print('item em 2 and empty');
                                ///Hiding ShowSearchResultDisplayBox when the search value is not empty
                                searchProvider.toggleShowSearchResultBox(
                                    value: false);
                                searchProvider.toggleShowSearchFilter(
                                    value: true);
                              }
                            },
                            themeProvider: themeProvider)
                      ],
                    )),
                  ),
                ],
              ),

              ///FILTER ICON IS SHOW HERE
              Padding(
                padding: EdgeInsets.only(left: cmw * 0.055),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      splashRadius: cmh * 0.025,

                      ///filter icon on pressed
                      onPressed: () => searchProvider.toggleShowSearchFilter(
                          value:
                              searchProvider.showSearchFilter ? false : true),
                      icon: Icon(
                        searchProvider.showSearchFilter
                            ? Icons.filter_alt_sharp
                            : Icons.filter_alt_outlined,
                        color: Colors.teal,
                      ),
                    )),
              ),

              ///FILTER (the option of changing language and collections falls under the category of FILTER)
              if (searchProvider.showSearchFilter == true)
                filter(searchProvider, settingsProvider, cmh, cmw,
                    themeProvider, context),

              ///here is the search Result display box
              if (searchProvider.showSearchResultBox == true)
                Expanded(
                  child: FutureBuilder(
                      future: searchProvider.searchHadith(),
                      builder: (context, AsyncSnapshot snapshot) {
                        ///if snapshot has no data
                        if (!snapshot.hasData) {
                          return CustomWidgets().customProgressIndicator(
                              themeProvider: themeProvider);
                        }

                        ///when no matching query is found display this
                        if (snapshot.data.isEmpty &&
                            searchProvider.searchedHadithNumber != null) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: cmh * 0.015,
                              ),
                              Text(
                                'Sorry but Nothing Found.',
                                style: GoogleFonts.josefinSans(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ],
                          );
                        }
                        return Directionality(
                          textDirection:
                              searchProvider.language == Language.arabic ||
                                      searchProvider.language == Language.urdu
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: cmw * 0.015, right: cmw * 0.015),
                            child: ScrollConfiguration(
                              behavior: RemoveListViewGlow(),
                              child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    if (snapshot.data.isEmpty) {
                                      return CustomWidgets()
                                          .customProgressIndicator(
                                              themeProvider: themeProvider);
                                    }

                                    ///here displaying the query result
                                    return Column(
                                      children: [
                                        if (index == 0)
                                          SizedBox(height: cmh * 0.011),
                                        FlatButton(
                                          color: index == 0
                                              ? settingsProvider.darkTheme
                                                  ? Colors.teal
                                                  : Colors.teal.withOpacity(.15)
                                              : settingsProvider.darkTheme
                                                  ? Colors.grey
                                                  : null,
                                          // color: settingsProvider.darkTheme
                                          //     ? Colors.grey
                                          //     : null,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      cmh * 0.015)),

                                          padding: EdgeInsets.only(
                                              left: cmw * 0.02,
                                              right: cmw * 0.02),
                                          onPressed: () async {
                                            ///selectedSearchResult updates and displays the opened result on the search result screen
                                            searchProvider
                                                .updateSelectedSearchResult(
                                                    value:
                                                        snapshot.data[index]);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SearchResultScreen(),
                                                ));
                                          },
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: cmh * 0.015,
                                              ),

                                              ///if hadith contains the searched hadith highlight the number
                                              // if (hadithItemTitle == 'Hadith No')
                                              Row(
                                                children: [
                                                  ///hadith number is created separated cause of some unknown bugs
                                                  Text('Hadith No : ',
                                                      style: TextStyle(
                                                        fontSize: 10.5.sp,
                                                      )),
                                                  SubstringHighlight(
                                                    textStyleHighlight:
                                                        TextStyle(
                                                      color: settingsProvider
                                                              .darkTheme
                                                          ? const Color(
                                                              0xffae1e25)
                                                          : Colors.red,
                                                    ),

                                                    /// ..... is displayed while data is being loaded
                                                    text: snapshot.data[
                                                                index][searchProvider
                                                                        .language ==
                                                                    Language
                                                                        .urdu
                                                                ? 'hadith_number'
                                                                : 'hadithNumber'] ==
                                                            null
                                                        ? '......'
                                                        : snapshot
                                                            .data[index][searchProvider
                                                                        .language ==
                                                                    Language
                                                                        .urdu
                                                                ? 'hadith_number'
                                                                : 'hadithNumber']
                                                            .toString(),
                                                    terms: [
                                                      searchProvider
                                                          .searchedHadithNumber
                                                    ],
                                                  ),
                                                ],
                                              ),

                                              ///Chapter No
                                              ///chapter number not available for urdu
                                              if (searchProvider.language !=
                                                  Language.urdu)
                                                hadithItem(
                                                  settingsProvider:
                                                      settingsProvider,
                                                  themeProvider: themeProvider,
                                                  dataProvider: dataProvider,
                                                  searchProvider:
                                                      searchProvider,
                                                  cmh: cmh,
                                                  cmw: cmw,
                                                  optionalMaxLines: 1,
                                                  snapshot: snapshot,
                                                  index: index,
                                                  hadithItemTitle: 'Chapter No',
                                                  hadithItem: 'babID',
                                                ),

                                              ///Chapter Name
                                              hadithItem(
                                                settingsProvider:
                                                    settingsProvider,
                                                themeProvider: themeProvider,
                                                dataProvider: dataProvider,
                                                searchProvider: searchProvider,
                                                cmh: cmh,
                                                cmw: cmw,
                                                optionalMaxLines: 1,
                                                snapshot: snapshot,
                                                index: index,
                                                hadithItemTitle: 'Chapter',
                                                hadithItem: searchProvider
                                                            .language ==
                                                        Language.urdu
                                                    ? 'title'
                                                    : searchProvider.language ==
                                                            Language.english
                                                        ? 'englishBabName'
                                                        : 'arabicBabName',
                                              ),

                                              ///hadithText
                                              hadithItem(
                                                settingsProvider:
                                                    settingsProvider,
                                                themeProvider: themeProvider,
                                                dataProvider: dataProvider,
                                                searchProvider: searchProvider,
                                                cmh: cmh,
                                                cmw: cmw,
                                                optionalMaxLines: 1,
                                                snapshot: snapshot,
                                                index: index,
                                                hadithItemTitle: 'Hadith',
                                                hadithItem: searchProvider
                                                            .language ==
                                                        Language.urdu
                                                    ? 'hadith_text'
                                                    : searchProvider.language ==
                                                            Language.english
                                                        ? 'englishText'
                                                        : 'arabicText',
                                              ),

                                              ///collection name
                                              ///collection name is auto captured and auto displayed when user changes the collection if not changed by
                                              ///the collection is fetched from the default collection
                                              hadithItem(
                                                settingsProvider:
                                                    settingsProvider,
                                                themeProvider: themeProvider,
                                                dataProvider: dataProvider,
                                                automaticCollectionName: true,
                                                searchProvider: searchProvider,
                                                cmh: cmh,
                                                cmw: cmw,
                                                optionalMaxLines: 1,
                                                snapshot: snapshot,
                                                index: index,
                                                hadithItemTitle: 'Collection',
                                                hadithItem: 'collection',
                                              ),

                                              ///grade
                                              ///not available for urdu cause grade is placed inside hadith_text(the hadith) itself and not given separately
                                              if (searchProvider.language !=
                                                      Language.urdu &&
                                                  (snapshot.data[index]
                                                              ['englishgrade1']
                                                          .toString()
                                                          .isNotEmpty ||
                                                      snapshot.data[index]
                                                              ['arabicgrade1']
                                                          .toString()
                                                          .isNotEmpty))
                                                hadithItem(
                                                  settingsProvider:
                                                      settingsProvider,
                                                  themeProvider: themeProvider,
                                                  dataProvider: dataProvider,
                                                  searchProvider:
                                                      searchProvider,
                                                  cmh: cmh,
                                                  cmw: cmw,
                                                  optionalMaxLines: 1,
                                                  snapshot: snapshot,
                                                  index: index,
                                                  hadithItemTitle: 'Grade',
                                                  hadithItem:
                                                      searchProvider.language ==
                                                              Language.english
                                                          ? 'englishgrade1'
                                                          : 'arabicgrade1',
                                                ),

                                              SizedBox(
                                                height: cmh * 0.015,
                                              ),
                                              CustomWidgets().customDivider(
                                                  themeProvider: themeProvider,
                                                  cmh: cmh)
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: cmh * 0.015,
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        );
                      }),
                ),
            ],
          ),
        );
      }),
    );
  }

  ///***********************************
  ///===================================
  ///***********************************
  ///===================================
  ///EXTRACTED WIDGETS
  ///***********************************
  ///===================================
  ///***********************************
  ///===================================

  ///hadith Searched Items Displaying Widget
  Widget hadithItem(
      {required DataProvider dataProvider,
      automaticCollectionName,
      required SearchProvider searchProvider,
      required SettingsProvider settingsProvider,
      required AsyncSnapshot<dynamic> snapshot,
      required int index,
      required ThemeProvider themeProvider,
      optionalMaxLines,
      cmh,
      cmw,
      hadithItemTitle,
      hadithItem}) {
    TextStyle itemStyle = searchProvider.language == Language.urdu
        ? TextStyle(
            fontFamily: 'Noto',
            fontSize: 10.5.sp,
          )
        : GoogleFonts.roboto(
            fontSize: searchProvider.language == Language.arabic &&
                    hadithItemTitle != 'Chapter No'
                ? 12.7.sp
                : 10.5.sp,
            color: hadithItemTitle == 'Grade' && settingsProvider.darkTheme
                ? Colors.black
                : hadithItemTitle == 'Grade'
                    ? Colors.teal
                    : null,
            backgroundColor:
                hadithItemTitle == 'Grade' && settingsProvider.darkTheme
                    ? Colors.teal
                    : null,
            fontWeight: hadithItemTitle == 'Grade' ? FontWeight.bold : null);
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('$hadithItemTitle = ',
            style: TextStyle(
              fontSize: 10.5.sp,
            )),

        ///
        if (automaticCollectionName != true)
          Expanded(
            child: Text(
              ///here this expression is used because babId is a double in order to parse it as3
              ///int im using this expression
              snapshot.data[index]['$hadithItem'] == null
                  ? '......'
                  : searchProvider
                      .searchedHadithFilter(
                          text: snapshot.data[index]['$hadithItem'].toString())
                      .toString(),

              overflow: TextOverflow.ellipsis,
              style: itemStyle,
              maxLines: 1,
            ),
          ),

        ///this is the automatic collection title when displayed automaticCollectionTitle ==true
        if (automaticCollectionName = true && hadithItemTitle == 'Collection')
          Text(
            // snapshot.data[index]['$hadithItem'] == null
            //     ? '......'
            //     :
            searchProvider.searchCollectionFullName.toString(),
            style: itemStyle,
          )
      ],
    );
  }

  ///FILTER WIDGET (this is linked to filter icon )
  Column filter(
      SearchProvider searchProvider,
      SettingsProvider settingsProvider,
      double cmh,
      double cmw,
      ThemeProvider themeProvider,
      BuildContext context) {
    return Column(
      children: [
        ///*********************************
        ///search language Selection
        ///*********************************
        selectSearchLanguage(
          searchProvider: searchProvider,
          settingsProvider: settingsProvider,
          cmh: cmh,
          cmw: cmw,
          themeProvider: themeProvider,
        ),
        SizedBox(
          height: cmh * 0.045,
        ),
        Text(
          'CHOOSE COLLECTION',
          style: TextStyle(
              fontSize: cmh * 0.0235, color: themeProvider.settingsFontColor),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: cmh * 0.02,
        ),
        TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.teal),
                  borderRadius: BorderRadius.circular(cmh * 0.015))),
              padding: MaterialStateProperty.all(EdgeInsets.only(
                left: cmw * 0.03,
                right: cmw * 0.03,
              )),
              // backgroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(
                  settingsProvider.darkTheme
                      ? Colors.black
                      : themeProvider.scaffoldBackgroundColor),
            ),

            ///***********************************
            ///selected collection name is displayed here
            ///******************************************
            child: Text(searchProvider.searchCollectionFullName.toString(),
                style: searchProvider.changeStyleAccordingToLanguage()),
            onPressed: () {
              ///**********************************************
              ///here is the MODAL which displays the hadith collections
              ///************************************************
              // print('this in the show collection name button');
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                context: context,
                builder: (context) => Container(
                  height: cmh * 0.67,
                  decoration: BoxDecoration(
                    color: themeProvider.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(cmh * 0.015),
                      topRight: Radius.circular(cmh * 0.015),
                    ),
                  ),
                  child: ScrollConfiguration(
                    behavior: RemoveListViewGlow(),
                    child: ListView.builder(
                      itemCount: searchProvider.collectionNamesList.length,
                      itemBuilder: (context, index) {
                        final collections = searchProvider.collectionNamesList;
                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FlatButton(
                                padding: EdgeInsets.only(
                                  top: cmh * 0.021,
                                  bottom: cmh * 0.021,
                                ),
                                child: Container(
                                  ///=================================================
                                  ///hadith collection title shown here inside modal
                                  ///=================================================
                                  child: Text(
                                    searchProvider.language == Language.urdu
                                        ? collections[index]['source']
                                        : collections[index]['collection'][
                                                searchProvider.language ==
                                                        Language.arabic
                                                    ? 1
                                                    : 0]['title']
                                            .toString(),
                                    style: searchProvider
                                        .changeStyleAccordingToLanguage(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  // print('im modal hiii ');
                                  switch (searchProvider.language) {
                                    case Language.urdu:
                                      {
                                        setState(() {
                                          searchProvider
                                                  .searchCollectionShortName =
                                              collections[index]['source'];
                                          searchProvider
                                                  .searchCollectionFullName =
                                              collections[index]['source'];
                                        });
                                      }
                                      break;
                                    case Language.english:
                                      {
                                        // print('modal (english)');
                                        setState(() {
                                          searchProvider
                                                  .searchCollectionShortName =
                                              collections[index]['name'];
                                          searchProvider
                                                  .searchCollectionFullName =
                                              collections[index]['collection']
                                                  [0]['title'];
                                        });
                                      }
                                      break;
                                    case Language.arabic:
                                      {
                                        // print('modal (arabic)');
                                        setState(() {
                                          searchProvider
                                                  .searchCollectionShortName =
                                              collections[index]['name'];
                                          searchProvider
                                                  .searchCollectionFullName =
                                              collections[index]['collection']
                                                  [1]['title'];
                                        });
                                      }
                                  }
                                },
                              ),
                              CustomWidgets().customDivider(
                                  themeProvider: themeProvider, cmh: cmh),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }),
      ],
    );
  }

  ///===================
  ///select search language
  ///==========================
  Widget selectSearchLanguage({
    required SettingsProvider settingsProvider,
    required SearchProvider searchProvider,
    required double cmh,
    required double cmw,
    required ThemeProvider themeProvider,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: cmh * 0.021,
        right: cmh * 0.021,
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(cmh * 0.007),
          decoration: BoxDecoration(
            // border: Border.all(
            //     color: Colors.teal.withOpacity(.15), width: cmw * 0.0025),
            borderRadius: BorderRadius.circular(cmh * 0.035),
            boxShadow: !settingsProvider.darkTheme
                ? [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: cmh * 0.025,
                        spreadRadius: -17),
                  ]
                : null,
          ),
          child: FlutterToggleTab(
            // width in percent, to set full width just set to 100

            width: cmw * 0.217,
            borderRadius: cmh * 0.035,
            height: cmh * 0.06,
            marginSelected: EdgeInsets.only(
              top: cmh * 0.005,
              bottom: cmh * 0.005,
              left: cmh * 0.005,
              right: cmh * 0.005,
            ),

            isShadowEnable: true,
            // selectedBackgroundColors: [themeProvider.settingsAppBarColor],
            selectedBackgroundColors: const [Colors.teal],
            selectedTextStyle: GoogleFonts.josefinSans(
                // color: Colors.white,
                color: Colors.white,
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w700),
            unSelectedTextStyle: TextStyle(
              color: themeProvider.hadithScreenFontColor,
              fontSize: 12.5.sp,
            ),
            unSelectedBackgroundColors: [themeProvider.settingsScaffoldColor],
            labels: const ["اردو", "English", "اَلْعَرَبِيَّةُ"],
            selectedIndex: searchProvider.searchLanguageTabIndex,
            selectedLabelIndex: (index) {
              // print("Selected Index $index");
              setState(() {
                searchProvider.changeTabIndex(value: index);
                switch (index) {
                  case 0:
                    {
                      setState(() {
                        searchProvider.language = Language.urdu;
                      });
                      searchProvider.defaultSearchSelectedCollectionName(
                          isInitState: false,
                          localSearchLanguage: Language.urdu);
                      searchProvider.fetchCollections(
                          fetchInInitState: false,
                          searchLocalLanguage: Language.urdu);
                    }
                    break;
                  case 1:
                    {
                      setState(() {
                        searchProvider.language = Language.english;
                      });
                      searchProvider.defaultSearchSelectedCollectionName(
                          isInitState: false,
                          localSearchLanguage: Language.english);

                      searchProvider.fetchCollections(
                          fetchInInitState: false,
                          searchLocalLanguage: Language.english);
                    }
                    break;
                  case 2:
                    {
                      setState(() {
                        searchProvider.language = Language.arabic;
                      });

                      ///updates default collection associated with the language
                      searchProvider.defaultSearchSelectedCollectionName(
                          isInitState: false,
                          localSearchLanguage: Language.arabic);
                      searchProvider.defaultSearchSelectedCollectionName(
                          isInitState: false,
                          localSearchLanguage: Language.arabic);
                      searchProvider.fetchCollections(
                          fetchInInitState: false,
                          searchLocalLanguage: Language.arabic);
                    }
                    break;
                }
              });
            },
          ),
        ),
      ),
    );
  }

  ///custom input field widget
  ///
  SizedBox customInputField({
    required double cmw,
    required BuildContext context,
    required double cmh,
    labelName,
    hintString,
    required Function validatorFunction,
    optionalMaxLines,
    optionalMaxLength,
    optionalTextInputType,
    required onChangedFunction,
    required ThemeProvider themeProvider,
    required SettingsProvider settingsProvider,
  }) {
    return SizedBox(
      width: cmw * 0.85,
      child: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.transparent),
        child: TextFormField(
          keyboardType: optionalTextInputType,
          maxLines: optionalMaxLines,
          maxLength: optionalMaxLength,
          textAlign: TextAlign.center,
          autofocus: false,
          style: TextStyle(fontSize: cmh * 0.021, color: Colors.black),
          decoration: InputDecoration(
            labelText: labelName.toString(),
            filled: true,
            fillColor: settingsProvider.darkTheme ? Colors.grey : Colors.white,
            hintText: hintString.toString(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            alignLabelWithHint: true,

            floatingLabelStyle: const TextStyle(color: Colors.teal),

            ///focused Border style
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.teal),
              borderRadius: BorderRadius.circular(cmh * 0.025),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(cmh * 0.025),
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: Colors.blueGrey.withOpacity(.55),
              ),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(cmh * 0.015)),
          ),
          onChanged: (value) {
            onChangedFunction(value);
          },
          validator: (value) {
            return validatorFunction(value);
          },
        ),
      ),
    );
  }
}
