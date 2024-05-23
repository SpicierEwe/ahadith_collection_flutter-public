import 'package:ahadith_collection/providers/settings_provider.dart';
import 'package:ahadith_collection/providers/contact_portal_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class CustomForm extends StatefulWidget {
  final Color specificPortalColor;
  final String portalType;

  const CustomForm(
      {Key? key, required this.specificPortalColor, required this.portalType})
      : super(key: key);

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String title = '';
  String explainedInDetail = '';
  String portalType = '';

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    ContactPortalProvider contactPortalProvider =
        Provider.of<ContactPortalProvider>(context);
    var mq = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraints) {
        var cmh = constraints.maxHeight;
        var cmw = constraints.maxWidth;

        return Stack(
          children: [
            Column(
              children: [
                Container(
                  color: settingsProvider.darkTheme
                      ? themeProvider.scaffoldBackgroundColor
                      : widget.specificPortalColor,
                  // height: cmh * 0.035,
                  width: cmw,
                ),
                Container(
                  height: cmh,
                  width: cmw,
                  decoration: BoxDecoration(
                    color: const Color(0xffFAF9F6),
                    // color: Colors.black,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(cmh * .1)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ///name field
                        SizedBox(height: cmh * 0.05),
                        customInputField(
                            optionalMaxLines: 1,
                            themeProvider: themeProvider,
                            cmw: cmw,
                            context: context,
                            cmh: cmh,
                            labelName: 'Name',
                            hintString: 'Your Name',
                            validatorFunction: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Name';
                              }
                              setState(() {
                                name = value;
                              });
                            }),
                        SizedBox(
                          height: cmh * 0.025,
                        ),

                        ///email field
                        customInputField(
                            optionalMaxLines: 1,
                            themeProvider: themeProvider,
                            cmw: cmw,
                            context: context,
                            cmh: cmh,
                            labelName: 'Email',
                            hintString: 'example@gmail.com',
                            optionalTextInputType: TextInputType.emailAddress,
                            validatorFunction: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains('@')) {
                                return 'Invalid Email Address';
                              }
                              setState(() {
                                email = value;
                              });
                            }),
                        SizedBox(
                          height: cmh * 0.025,
                        ),

                        ///title field
                        customInputField(
                            optionalMaxLines: 1,
                            themeProvider: themeProvider,
                            cmw: cmw,
                            context: context,
                            cmh: cmh,
                            labelName: 'Title',
                            hintString: 'Enter Title',
                            validatorFunction: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter a title';
                              }
                              setState(() {
                                title = value;
                              });
                            }),
                        SizedBox(
                          height: cmh * 0.025,
                        ),
                        customInputField(
                            themeProvider: themeProvider,
                            cmw: cmw,
                            context: context,
                            cmh: cmh,
                            labelName: 'Explain.....',
                            hintString: 'Explain in Detail',
                            optionalMaxLines: 13,
                            optionalMaxLength: 999,
                            validatorFunction: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Explain the Issue';
                              }
                              setState(() {
                                explainedInDetail = value;
                              });
                            }),

                        ///submit button----------------------------------------------
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  widget.specificPortalColor)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              contactPortalProvider.toggleLoadingScreen(
                                  loadingScreenBool: true);
                              contactPortalProvider.gatherInformation(
                                incomingName: name,
                                incomingEmail: email,
                                incomingTitle: title,
                                incomingExplainedInDetail: explainedInDetail,
                                portalType: widget.portalType,
                                context: context,
                                formKey: _formKey,
                              );
                            }
                          },
                          child: const Text(
                            'Submit',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            ///here is the [loading screen] which is displayed during request submission
            if (contactPortalProvider.loadingScreen == true)
              Column(
                children: [
                  Container(
                    height: cmh,
                    width: cmw,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.3),
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(cmh * .1)),
                    ),
                  ),
                ],
              ),
            if (contactPortalProvider.loadingScreen == true)
              Center(
                  child: CircularProgressIndicator(
                color: widget.specificPortalColor,
              )),
          ],
        );
      },
    );
  }

  SizedBox customInputField(
      {required double cmw,
      required BuildContext context,
      required double cmh,
      labelName,
      hintString,
      required Function validatorFunction,
      optionalMaxLines,
      optionalMaxLength,
      optionalTextInputType,
      required ThemeProvider themeProvider}) {
    return SizedBox(
      width: cmw * 0.85,
      child: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.transparent),
        child: TextFormField(
          keyboardType: optionalTextInputType,
          maxLines: optionalMaxLines,
          maxLength: optionalMaxLength,
          autofocus: false,
          style: TextStyle(fontSize: cmh * 0.021, color: Colors.black),
          decoration: InputDecoration(
            // labelStyle: TextStyle(
            //     color: themeProvider.sett,
            //   fontWeight: FontWeight.bold
            // ),
            labelText: labelName.toString(),
            filled: true,
            fillColor: Colors.white,
            hintText: hintString.toString(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            alignLabelWithHint: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(cmh * 0.015),
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: Colors.blueGrey.withOpacity(.55),
              ),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(cmh * 0.015)),
          ),
          validator: (value) {
            return validatorFunction(value);
          },
        ),
      ),
    );
  }
}
