import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/custom_form.dart';
import '../../../components/remove_listview_glow.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Contact us',
          style: GoogleFonts.josefinSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: mq.height * 0.029,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: ScrollConfiguration(
        behavior: RemoveListViewGlow(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: mq.height -
                (AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top),
            width: mq.width,
            child: const CustomForm(
              specificPortalColor: Colors.black,
              portalType: 'contact_us',
            ),
          ),
        ),
      ),
    );
  }
}
