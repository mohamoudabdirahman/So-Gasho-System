import 'dart:html';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/pages/Waiting%20List/waitinglist.dart';
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
  TextEditingController resetingemail = TextEditingController();
  var disableduser;
  var loggingbox = Hive.box('CheckingLoggedInUser');
  var userrole = Hive.box('Role');
  var usernames = Hive.box('UsersName');
  bool isvisible = true;
  UserModel loggedInuser = UserModel();
  var isapproved;
  FocusNode emailfocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  StateMachineController? _stateMachineControllers;
  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  @override
  void initState() {
    // TODO: implement initState
    emailfocus.addListener(emailfocuses);
    passwordFocus.addListener(passwordfocus);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailfocus.removeListener(emailfocuses);
    passwordFocus.removeListener(passwordfocus);
    super.dispose();
  }

  void passwordfocus() {
    isHandsUp?.change(passwordFocus.hasFocus);
  }

  void emailfocuses() {
    isChecking?.change(emailfocus.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children:[
              Positioned(
                width: MediaQuery.of(context).size.width * 1.7,
                left: 400,
                bottom: 20,
                child: Image.asset('lib/images/Spline.png',fit: BoxFit.fill,)),
              RiveAnimation.asset("lib/images/shapes.riv",fit: BoxFit.fill,),
              
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child:  BackdropFilter(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                )),
              Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Login',
                    style: TextStyle(
                        fontSize: 100.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors().fifthcolor)),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 200,
                  child: RiveAnimation.asset('lib/images/tedybear.riv',
                      stateMachines: const ["Login Machine"], onInit: (artboard) {
                    _stateMachineControllers =
                        StateMachineController.fromArtboard(
                            artboard, "Login Machine");
                    if (_stateMachineControllers == null) return;
                    artboard.addController(_stateMachineControllers!);
                    isChecking =
                        _stateMachineControllers?.findInput('isChecking');
                    numLook = _stateMachineControllers?.findInput('numlook');
                    isHandsUp = _stateMachineControllers?.findInput('isHandsUp');
                    trigSuccess =
                        _stateMachineControllers?.findInput('trigSuccess');
                    trigFail = _stateMachineControllers?.findInput('trigFail');
                  }),
                ),
                LoginBox(
                  focusnode: emailfocus,
                  autofill: AutofillHints.email,
                  controller: emailcontroller,
                  passwordvisibility: false,
                  widthoftextfield: 600,
                  placeholder: 'Email',
                  placeholdericon: Icon(
                    Icons.person,
                    color: AppColors().fifthcolor,
                  ),
                  onchanges: (value) {
                    numLook?.change(value.length.toDouble());
                  },
                ),
                LoginBox(
                    focusnode: passwordFocus,
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
                Container(
                  width: 600,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'You forgot your password?',
                          style: TextStyle(
                              fontSize: 18, color: AppColors().fifthcolor),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        TextButton(
                          onPressed: () {
                            reset();
                          },
                          child: Text(
                            'Reset!',
                            style: TextStyle(
                                fontSize: 18, color: AppColors().greycolor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Buttons(
                  buttonColor: AppColors().secondcolor,
                  buttonText: 'Login',
                  ontap: () {
                    emailfocus.unfocus();
                    passwordFocus.unfocus();
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
            ),] 
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
          isapproved = value.get('IsApproved');

          if (userrole.get('UserRole') == '') {
            userrole.put('UserRole', value.get('role'));
            usernames.put('UsersName', value.get('First Name'));
          }
        });

        if (disableduser == true) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppColors().thirdcolor,
              content: Text('This user has been disabled by the administrator!',
                  style: TextStyle(
                    color: AppColors().fifthcolor,
                  ))));
        } else if (isapproved == 'requested') {
          Navigator.of(context).pop();
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => WaitaingList())));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppColors().thirdcolor,
              content: Text(
                  'Your Account has not been approved by the admin yet, please wait until it is approved!!',
                  style: TextStyle(
                    color: AppColors().fifthcolor,
                  ))));
        } else {
          loggingbox.put('Email', emailcontroller.text);
          Navigator.of(context).pop();
          trigSuccess?.change(true);
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => AdminDashboard())));
        }
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        trigFail?.change(true);
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

  void reset() async{
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              width: 500,
              height: 100,
              decoration: BoxDecoration(),
              child: LoginBox(
                  autofill: AutofillHints.email,
                  widthoftextfield: 150,
                  placeholder: 'Email',
                  placeholdericon: Icon(
                    Icons.email,
                    color: AppColors().fifthcolor,
                  ),
                  passwordvisibility: false,
                  controller: resetingemail),
            ),
            actions: [
              MaterialButton(
                onPressed: () async {
                  try {
                    if (resetingemail.text.isNotEmpty) {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: resetingemail.text);

                      Navigator.of(context).pop();
                      setState(() {
                        resetingemail.clear();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: AppColors().thirdcolor,
                          content: Text(
                              'An Email has been sent to your email! Please check your email.',
                              style: TextStyle(
                                color: AppColors().fifthcolor,
                              ))));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: AppColors().thirdcolor,
                          content: Text('The email field cannot be empty!',
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
                },
                child: Text(
                  'Reset',
                  style: TextStyle(color: AppColors().fifthcolor),
                ),
                color: AppColors().maincolor,
                shape: RoundedRectangleBorder(),
              )
            ],
          );
        });
  }
}
