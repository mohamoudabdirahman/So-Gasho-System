import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/utils/Buttons.dart';
import 'package:somcable_web_app/utils/settingForm.dart';

class Securitypage extends StatefulWidget {
  Securitypage({Key? key}) : super(key: key);

  @override
  State<Securitypage> createState() => _SecuritypageState();
}

class _SecuritypageState extends State<Securitypage> {
  TextEditingController emailreset = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'This Information is very Sensitive!',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors().black.withOpacity(0.5),
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'If you forget your password, you can reset it after you provide your Email!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors().black.withOpacity(0.5),
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SettingsForm(controller: emailreset, label: 'Email'),
          SizedBox(
            height: 20,
          ),
          Buttons(
              buttonColor: AppColors().secondcolor,
              buttonText: 'Reset',
              ontap: () {
                resetpassword();
              })
        ],
      ),
    );
  }

  void resetpassword() async {
    try {
      if (emailreset.text.isNotEmpty) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailreset.text);
        print('i have sent it');
      }

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
                    'Email has been sent to your email address,check it out and follow the instructions',
                    style:
                        TextStyle(fontSize: 20, color: AppColors().fifthcolor),
                  ),
                )),
              ),
              actions: [
                MaterialButton(
                    color: AppColors().maincolor,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Ok',
                      style: TextStyle(color: AppColors().fifthcolor),
                    ))
              ],
            );
          });
    } on Exception catch (e) {
      print(e);
    }
  }
}
