import 'package:flutter/material.dart';
import 'package:somcable_web_app/colors/Colors.dart';

class Buttons extends StatelessWidget {
  String? buttonText;
  var ontap;
  Color? buttonColor;
  Buttons({Key? key, required this.buttonText, required this.ontap,this.buttonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        minWidth: 250,
        height: 50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(38)),
        onPressed: ontap,
        color: buttonColor,
        child: Text(buttonText!,
            style: TextStyle(
              color: AppColors().fifthcolor,
            )),
      ),
    );
  }
}
