import 'package:flutter/material.dart';
import 'package:somcable_web_app/colors/Colors.dart';

class TextButtons extends StatelessWidget {
  var ontap;
  var buttoncolor;
  String? title;
  TextButtons({Key? key, required this.ontap, required this.title,required this.buttoncolor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: ontap,
        child: Text(
          title!,
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: buttoncolor),
        ));
  }
}
