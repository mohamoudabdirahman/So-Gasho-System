import 'package:flutter/material.dart';
import 'package:searchbar_animation/const/colours.dart';
import 'package:somcable_web_app/colors/Colors.dart';

class NoconnectionPage extends StatelessWidget {
  const NoconnectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Image.asset('lib/images/Nointernet.jpg',height: 700,),
          Text('There is no Internet connection!, please check your Internet connection',
          style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),)
        ]),
      ),
    );
  }
}
