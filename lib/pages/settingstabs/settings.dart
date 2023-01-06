import 'package:flutter/material.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/pages/settingstabs/Personalinfo.dart';
import 'package:somcable_web_app/pages/settingstabs/Personalization.dart';
import 'package:somcable_web_app/pages/settingstabs/securitypage.dart';
import 'package:somcable_web_app/utils/TextButton.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? settingTab = 'PersonalInfo';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
          width: MediaQuery.of(context).size.width - 196,
          
          decoration: BoxDecoration(
              color: AppColors().fifthcolor,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 3),
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.3))
              ]),
          child: Padding(
            padding: const EdgeInsets.all(65),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: TextStyle(
                      fontSize: 31,
                      color: AppColors().maincolor,
                      fontWeight: FontWeight.bold),
                ),
                Divider(
                  color: AppColors().greycolor,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28, bottom: 28),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: Duration(microseconds: 300),
                        decoration: BoxDecoration(
                          color: settingTab == 'PersonalInfo' ? AppColors().secondcolor : AppColors().fifthcolor,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextButtons(
                            buttoncolor: settingTab == 'PersonalInfo' ? AppColors().fifthcolor : AppColors().black,
                            ontap: () {
                            setState(() {
                                  settingTab = 'PersonalInfo';
                                });
                          }, title: 'Personal Information'),
                        ),
                      ),
                      SizedBox(
                        width: 132,
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: settingTab == 'Security' ? AppColors().secondcolor : AppColors().fifthcolor,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextButtons(
                              buttoncolor: settingTab == 'Security' ? AppColors().fifthcolor : AppColors().black,
                            ontap: () {
                            setState(() {
                                  settingTab = 'Security';
                                });
                          }, title: 'Security'),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                // the area that changes frequently
               const  SizedBox(
                  height: 5,
                ),
                 settingTab == 'PersonalInfo' ? PersonalInfo() : settingTab == 'Security' ? Securitypage() : SizedBox()
              ],
            ),
          )),
    );
  }
}
