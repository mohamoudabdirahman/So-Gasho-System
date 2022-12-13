import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/pages/Waiting%20List/waitinglist.dart';
import 'package:somcable_web_app/pages/adminDashboard.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool isverified = false;
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isverified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isverified) {
      sendverificationemail();

      timer = Timer.periodic(Duration(seconds: 3), (_) => checkemail());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('lib/images/email.jpg',height: 600,),
            SizedBox(
              height: 20,
            ),
            Text(
              'We have sent a verification email to your email, please check it out!',
              style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  sendverificationemail() async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors().thirdcolor,
          content: Text(e.toString(),
              style: TextStyle(
                color: AppColors().fifthcolor,
              ))));
    }
  }

  checkemail() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isverified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isverified) {
      timer?.cancel();
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => WaitaingList())));
    }
  }
}
