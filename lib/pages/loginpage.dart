import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/pages/adminDashboard.dart';
import 'package:somcable_web_app/pages/registerration.dart';
import 'package:somcable_web_app/userDatabase/userModel.dart';
import 'package:somcable_web_app/utils/Buttons.dart';
import 'package:somcable_web_app/utils/loginbox.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController password = TextEditingController();
  var disableduser;
  var loggingbox = Hive.box('CheckingLoggedInUser');
  bool isvisible = true;
  UserModel loggedInuser = UserModel();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors().maincolor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Login',
                  style: GoogleFonts.poppins(
                      fontSize: 100.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors().fifthcolor)),
              const SizedBox(
                height: 30,
              ),
              LoginBox(
                autofill: AutofillHints.email,
                controller: emailcontroller,
                passwordvisibility: false,
                widthoftextfield: 600,
                placeholder: 'Email',
                placeholdericon: Icon(
                  Icons.person,
                  color: AppColors().fifthcolor,
                ),
              ),
              LoginBox(
                  autofill: AutofillHints.newPassword,
                  controller: password,
                  passwordvisibility: isvisible,
                  placeholder: 'Password',
                  widthoftextfield: 600,
                  placeholdericon: IconButton(
                      onPressed: () {
                        if (isvisible == false) {
                          setState(() {
                            isvisible = true;
                          });
                        } else if (isvisible == true) {
                          setState(() {
                            isvisible = false;
                          });
                        }
                      },
                      icon: Icon(
                        isvisible ? Icons.visibility_off : Icons.visibility,
                        color: AppColors().fifthcolor,
                      ))),
              Buttons(
                buttonColor: AppColors().secondcolor,
                buttonText: 'Login',
                ontap: () {
                  login();
                  // Navigator.push(context, MaterialPageRoute(builder: ((context) => AdminDashboard())));
                },
              ),
              Buttons(
                buttonColor: AppColors().secondcolor,
                buttonText: 'Register',
                ontap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => RegistrationPage())));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    UserModel userModel = UserModel();
    bool isverified = false;

    if (emailcontroller.text.isNotEmpty && password.text.isNotEmpty) {
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
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailcontroller.text, password: password.text);

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) {
          disableduser = value.get('Isdisabled');
        });

        if (disableduser == true) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColors().thirdcolor,
        content: Text('This user has been disabled by the administrator!',
            style: TextStyle(
              color: AppColors().fifthcolor,
            ))));
          
        } else {
          loggingbox.put('Email', emailcontroller.text);
          Navigator.of(context).pop();
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => AdminDashboard())));
        }
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors().thirdcolor,
            content: Text(e.toString(),
                style: TextStyle(
                  color: AppColors().fifthcolor,
                ))));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("These fields can't be empty"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'))
              ],
            );
          });
    }
  }
}
