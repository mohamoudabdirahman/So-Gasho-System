import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/pages/emailVerification.dart';
import 'package:somcable_web_app/pages/loginpage.dart';
import 'package:somcable_web_app/userDatabase/userModel.dart';
import 'package:somcable_web_app/utils/Buttons.dart';
import 'package:somcable_web_app/utils/checkboxes.dart';
import 'package:somcable_web_app/utils/loginbox.dart';
import 'package:loading_indicator/loading_indicator.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  String? roles;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool isvisible = false;
  bool? newvalue;
  bool? firstnamevalidator;
  bool? lastvalidator;
  bool? usernamevalidator;
  bool? pwvalidator;
  bool? isvalid;
  bool admin = false;
  bool user = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().secondcolor,
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Registration',
                  style: TextStyle(
                      fontSize: 100.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors().fifthcolor)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoginBox(
                      autofill: AutofillHints.name,
                      controller: firstname,
                      passwordvisibility: false,
                      widthoftextfield: 292,
                      placeholder: 'First Name',
                      placeholdericon: Icon(
                        Icons.person_add,
                        color: AppColors().fifthcolor,
                      )),
                  LoginBox(
                      autofill: AutofillHints.name,
                      controller: lastname,
                      passwordvisibility: false,
                      widthoftextfield: 292,
                      placeholder: 'Last Name',
                      placeholdericon: Icon(
                        Icons.person_add_alt,
                        color: AppColors().fifthcolor,
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlutterPwValidator(
                    width: 200,
                    height: 50,
                    minLength: 3,
                    controller: firstname,
                    onSuccess: () {
                      setState(() {
                        firstnamevalidator = true;
                      });
                    },
                    normalCharCount: 3,
                    onFail: () {
                      setState(() {
                        firstnamevalidator = false;
                      });
                    },
                  ),
                  FlutterPwValidator(
                    width: 292,
                    height: 50,
                    minLength: 3,
                    controller: lastname,
                    onSuccess: () {
                      setState(() {
                        lastvalidator = true;
                      });
                    },
                    onFail: () {
                      setState(() {
                        lastvalidator = false;
                      });
                    },
                    normalCharCount: 3,
                  ),
                ],
              ),
              LoginBox(
                  autofill: AutofillHints.email,
                  controller: email,
                  passwordvisibility: false,
                  widthoftextfield: 600,
                  placeholder: 'Email',
                  placeholdericon: Icon(
                    Icons.email,
                    color: AppColors().fifthcolor,
                  )),
              LoginBox(
                  autofill: AutofillHints.username,
                  controller: username,
                  passwordvisibility: false,
                  widthoftextfield: 600,
                  placeholder: 'username',
                  placeholdericon: Icon(
                    Icons.verified_user_rounded,
                    color: AppColors().fifthcolor,
                  )),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FlutterPwValidator(
                      width: 292,
                      height: 50,
                      minLength: 10,
                      numericCharCount: 10,
                      controller: username,
                      onSuccess: () {
                        setState(() {
                          usernamevalidator = true;
                        });
                      },
                      onFail: () {
                        setState(() {
                          usernamevalidator = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              LoginBox(
                  autofill: AutofillHints.password,
                  controller: password,
                  passwordvisibility: isvisible,
                  widthoftextfield: 600,
                  placeholder: 'password',
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
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FlutterPwValidator(
                      width: 292,
                      height: 100,
                      minLength: 8,
                      controller: password,
                      uppercaseCharCount: 1,
                      specialCharCount: 1,
                      numericCharCount: 1,
                      onSuccess: () {
                        setState(() {
                          pwvalidator = true;
                        });
                      },
                      onFail: () {
                        setState(() {
                          pwvalidator = false;
                        });
                      },
                      normalCharCount: 1,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            value: admin,
                            onChanged: (value) {
                              if (admin == false) {
                                setState(() {
                                  admin = value!;
                                });
                              } else if (admin == true) {
                                setState(() {
                                  admin = value!;
                                });
                              }
                              setState(() {
                                if (user == true) {
                                  admin = false;
                                }
                              });
                            }),
                        Text('Admin',
                            style: TextStyle(color: AppColors().fifthcolor)),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: user,
                            onChanged: (value) {
                              if (user == false) {
                                setState(() {
                                  user = value!;
                                });
                              } else if (user == true) {
                                setState(() {
                                  user = value!;
                                });
                              }
                              setState(() {
                                if (admin == true) {
                                  user = false;
                                }
                              });
                            }),
                        Text(
                          'User',
                          style: TextStyle(color: AppColors().fifthcolor),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Buttons(
                buttonText: 'Register',
                ontap: () {
                  isvalid = EmailValidator.validate(email.text);
                  registration(email.text, password.text);
                },
                buttonColor: AppColors().thirdcolor,
              )
            ],
          ),
        ),
      ),
    );
  }

  void registration(String email, String password) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    if (admin == true) {
      roles = 'admin';
    } else {
      roles = 'user';
    }

    try {
      if (isvalid == true &&
          firstnamevalidator == true &&
          lastvalidator == true &&
          usernamevalidator == true &&
          pwvalidator == true) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        UserModel userModel = UserModel();

        showDialog(
            context: context,
            builder: (context) {
              return AbsorbPointer(
                child: Center(
                    child: SizedBox(
                        width: 60,
                        height: 60,
                        child: LoadingIndicator(
                            colors: [AppColors().maincolor],
                            indicatorType: Indicator.ballClipRotatePulse))),
              );
            });

        await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          postingdata();
          Navigator.of(context).pop();
        });
        //posting data to firebaseFirestore

      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors().thirdcolor,
          content: Text(e.toString(),
              style: TextStyle(
                color: AppColors().fifthcolor,
              ))));
    }
  }

  postingdata() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    UserModel userModel = UserModel();
    userModel.uid = FirebaseAuth.instance.currentUser!.uid;
    userModel.firstname = firstname.text;
    userModel.lastname = lastname.text;
    userModel.email = email.text;
    userModel.phonenumber = username.text;
    userModel.role = roles;
    userModel.isdisabled = false;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.uid)
        .set(userModel.tomap());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColors().thirdcolor,
        content: Text('You have successfully been Registered',
            style: TextStyle(
              color: AppColors().fifthcolor,
            ))));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EmailVerificationPage()));
  }
}
