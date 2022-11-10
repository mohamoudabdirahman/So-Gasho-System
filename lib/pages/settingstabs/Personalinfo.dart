import 'package:flutter/material.dart';
import 'package:somcable_web_app/utils/loginbox.dart';

class PersonalInfo extends StatelessWidget {
  TextEditingController fnamecontroller = TextEditingController();
   PersonalInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginBox(
        placeholder: 'Please enter the first name',
        placeholdericon: Icon(Icons.person),
        passwordvisibility: false,
        controller: fnamecontroller,
        widthoftextfield: 607,
        autofill: AutofillHints.name,
        );
  }
}
