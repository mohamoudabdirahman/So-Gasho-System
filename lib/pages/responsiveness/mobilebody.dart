import 'package:flutter/material.dart';
import 'package:somcable_web_app/colors/Colors.dart';

class MobileBody extends StatelessWidget {
  const MobileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().fifthcolor,
      body: Center(
        child: Text('This is system does not support smaller screens please maximize your tab!',style: TextStyle(fontSize: 20,color: AppColors().black),),
      ),
    );
  }
}