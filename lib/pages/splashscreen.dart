import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/pages/adminDashboard.dart';
import 'package:somcable_web_app/pages/feji/feji.dart';
import 'package:somcable_web_app/pages/loginpage.dart';
import 'package:somcable_web_app/pages/messenger.dart';
import 'package:connectivity_plus_platform_interface/method_channel_connectivity.dart';
import 'package:somcable_web_app/pages/noconnection.dart';
import 'package:somcable_web_app/pages/responsiveness/mobilebody.dart';
import 'package:somcable_web_app/pages/responsiveness/responsive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool noconnection = false;
  var obtainedemail = '';
  var obtainedbox = Hive.box('CheckingLoggedInUser');
  

  @override
  void initState() {
    
    // TODO: implement initState

    super.initState();

    try {
      
      Timer(const Duration(seconds: 3), () {
        
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => noconnection
                      ? const NoconnectionPage()
                      :  const LoginPage())));
      
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors().thirdcolor,
          content: Text(e.toString(),
              style: TextStyle(
                color: AppColors().fifthcolor,
              ))));
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().greycolor,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: AbsorbPointer(
          child: ConnectivityBuilder(builder: (context, isConnected, status) {
            if (isConnected == true) {
            } else {
              noconnection = true;
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/images/so logo.png',
                  height: 150,
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 700),
                  child: LinearPercentIndicator(
                    barRadius: Radius.circular(50),
                    animation: true,
                    width: 500,
                    animationDuration: 2000,
                    lineHeight: 20,
                    percent: 1.0,
                    backgroundColor: AppColors().secondcolor,
                    progressColor: AppColors().maincolor,
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
