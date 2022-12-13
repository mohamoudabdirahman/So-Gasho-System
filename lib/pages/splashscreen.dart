import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/pages/adminDashboard.dart';
import 'package:somcable_web_app/pages/loginpage.dart';
import 'package:somcable_web_app/pages/messenger.dart';
import 'package:connectivity_plus_platform_interface/method_channel_connectivity.dart';
import 'package:somcable_web_app/pages/noconnection.dart';

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
      Timer(Duration(seconds: 3), () {
        if (obtainedbox.get('Email') == null ||
            obtainedbox.get('Email') == '' ) {
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => noconnection ? NoconnectionPage() : LoginPage())));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => noconnection ? NoconnectionPage() : AdminDashboard())));
        }
        
      });
    } on Exception catch (e) {
      print(e);
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
