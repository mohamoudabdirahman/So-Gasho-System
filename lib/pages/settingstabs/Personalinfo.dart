import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/pages/loginpage.dart';
import 'package:somcable_web_app/userDatabase/userModel.dart';
import 'package:somcable_web_app/utils/Buttons.dart';
import 'package:somcable_web_app/utils/loginbox.dart';
import 'package:somcable_web_app/utils/settingForm.dart';

class PersonalInfo extends StatefulWidget {
  PersonalInfo({Key? key}) : super(key: key);

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  var obtaniedemail = Hive.box('CheckingLoggedInUser');
  var usersName = Hive.box('UsersName');
  var userrole = Hive.box('Role');
  TextEditingController fnamecontroller = TextEditingController();

  TextEditingController lnamecontroller = TextEditingController();

  TextEditingController usernamecontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();
  var email = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SettingsForm(controller: fnamecontroller, label: 'First Name'),
        SizedBox(
          height: 50,
        ),
        SettingsForm(controller: lnamecontroller, label: 'Last Name'),
        SizedBox(
          height: 50,
        ),
        SettingsForm(controller: usernamecontroller, label: 'Phone Number'),
        SizedBox(
          height: 50,
        ),
        Buttons(
            buttonText: 'Update',
            buttonColor: AppColors().maincolor,
            ontap: () {
              updatinginfo();
            })
      ],
    );
  }

  void updatinginfo() async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return AbsorbPointer(
              child: Center(
                  child: SizedBox(
                      height: 50,
                      width: 50,
                      child: LoadingIndicator(
                        colors: [AppColors().maincolor],
                        indicatorType: Indicator.ballClipRotatePulse,
                      ))),
            );
          });
      if (fnamecontroller.text.isNotEmpty ||
          lnamecontroller.text.isNotEmpty ||
          usernamecontroller.text.isNotEmpty) {
        if (fnamecontroller.text.isNotEmpty &&
            lnamecontroller.text.isEmpty &&
            usernamecontroller.text.isEmpty) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update(({
                'First Name': fnamecontroller.text,
              }));

          FirebaseFirestore.instance
              .collection('Messages')
              .where('sentBy', isEqualTo: usersName.get('UsersName'))
              .get()
              .then((QuerySnapshot snapshot) {
            for (var message in snapshot.docs) {
              if (message.get('sentBy') == usersName.get('UsersName')) {
                FirebaseFirestore.instance
                    .collection('Messages')
                    .doc(message.get('doc'))
                    .update(({'sentBy': fnamecontroller.text}));
              }
            }
          });
        } else if (lnamecontroller.text.isNotEmpty &&
            fnamecontroller.text.isEmpty &&
            usernamecontroller.text.isEmpty) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update(({
                'Last Name': lnamecontroller.text,
              }));
        } else if (usernamecontroller.text.isNotEmpty &&
            fnamecontroller.text.isEmpty &&
            lnamecontroller.text.isEmpty) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update(({
                'PhoneNumber': usernamecontroller.text.toString(),
              }));
        } else if (usernamecontroller.text.isNotEmpty &&
            fnamecontroller.text.isNotEmpty &&
            lnamecontroller.text.isNotEmpty) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update(({
                'First Name': fnamecontroller.text,
                'Last Name': lnamecontroller.text,
                'PhoneNumber': usernamecontroller.text.toString(),
              }));

          FirebaseFirestore.instance
              .collection('Messages')
              .where('sentBy', isEqualTo: usersName.get('UsersName'))
              .get()
              .then((QuerySnapshot snapshot) {
            for (var message in snapshot.docs) {
              if (message.get('sentBy') == usersName.get('UsersName')) {
                FirebaseFirestore.instance
                    .collection('Messages')
                    .doc(message.get('doc'))
                    .update(({'sentBy': fnamecontroller.text}));
              }
            }
          });
        } else if (fnamecontroller.text.isNotEmpty &&
            lnamecontroller.text.isNotEmpty &&
            usernamecontroller.text.isEmpty) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update(({
                'First Name': fnamecontroller.text,
                'Last Name': lnamecontroller.text,
              }));

          FirebaseFirestore.instance
              .collection('Messages')
              .where('sentBy', isEqualTo: usersName.get('UsersName'))
              .get()
              .then((QuerySnapshot snapshot) {
            for (var message in snapshot.docs) {
              if (message.get('sentBy') == usersName.get('UsersName')) {
                FirebaseFirestore.instance
                    .collection('Messages')
                    .doc(message.get('doc'))
                    .update(({'sentBy': fnamecontroller.text}));
              }
            }
          });
        } else if (fnamecontroller.text.isNotEmpty &&
            lnamecontroller.text.isEmpty &&
            usernamecontroller.text.isNotEmpty) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update(({
                'First Name': fnamecontroller.text,
                'PhoneNumber': usernamecontroller.text.toString(),
              }));

          FirebaseFirestore.instance
              .collection('Messages')
              .where('sentBy', isEqualTo: usersName.get('UsersName'))
              .get()
              .then((QuerySnapshot snapshot) {
            for (var message in snapshot.docs) {
              if (message.get('sentBy') == usersName.get('UsersName')) {
                FirebaseFirestore.instance
                    .collection('Messages')
                    .doc(message.get('doc'))
                    .update(({'sentBy': fnamecontroller.text}));
              }
            }
          });
        } else if (fnamecontroller.text.isEmpty &&
            lnamecontroller.text.isNotEmpty &&
            usernamecontroller.text.isNotEmpty) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update(({
                'Last Name': lnamecontroller.text,
                'PhoneNumber': usernamecontroller.text.toString(),
              }));
        }
        Navigator.of(context).pop();

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              var height = MediaQuery.of(context).size.height;
              return AlertDialog(
                shape: RoundedRectangleBorder(),
                backgroundColor: AppColors().secondcolor,
                elevation: 50,
                title: Text('Alert'),
                content: Container(
                  width: 500,
                  height: 100,
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'You will need to sign out to see the changes!',
                      style: TextStyle(
                          fontSize: 20, color: AppColors().fifthcolor),
                    ),
                  )),
                ),
                actions: [
                  MaterialButton(
                      color: AppColors().maincolor,
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                        obtaniedemail.put('Email', '');
                        usersName.put('UsersName', '');
                        userrole.put('UserRole', '');
                      },
                      child: Text(
                        'Sign Out',
                        style: TextStyle(color: AppColors().fifthcolor),
                      ))
                ],
              );
            });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors().thirdcolor,
            content: Text('Fields cannot be empty, please fill some of them',
                style: TextStyle(
                  color: AppColors().fifthcolor,
                ))));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors().thirdcolor,
          content: Text(e.toString(),
              style: TextStyle(
                color: AppColors().fifthcolor,
              ))));
    }
  }
}
