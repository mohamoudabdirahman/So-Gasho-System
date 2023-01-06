import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/pages/adminDashboard.dart';
import 'package:somcable_web_app/utils/Buttons.dart';

class WaitaingList extends StatefulWidget {
  const WaitaingList({super.key});

  @override
  State<WaitaingList> createState() => _WaitaingListState();
}

class _WaitaingListState extends State<WaitaingList> {
  Timer? timer;
  var userbox = Hive.box('Role');
  var usernames = Hive.box('UsersName');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 3), (_) => checkIfApproved());
  }

  void checkIfApproved() async {
    var data = await  FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (data.get('IsApproved') == 'accepted') {
        userbox.put('UserRole', data.get('role'));
          usernames.put('UsersName', data.get('First Name'));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AdminDashboard()));
        timer?.cancel();
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.network(
              'https://assets10.lottiefiles.com/packages/lf20_e6gbikSzxC.json',
              height: 600),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Your Account has not been approved by the admin yet, please wait until it is approved!',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Buttons(
              buttonColor: AppColors().secondcolor,
              buttonText: 'Go Back!',
              ontap: () {
                Navigator.pop(context);
                timer?.cancel();
                
                FirebaseAuth.instance.signOut();
                userbox.put('UserRole', '');
          usernames.put('UsersName', '');
              })
        ],
      ),
    ));
  }
}
