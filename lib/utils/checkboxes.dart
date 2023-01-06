import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
  var obtainedvalue;
  CheckBox({
    Key? key,
    this.obtainedvalue
  }) : super(key: key);

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool role = false;
  @override
  Widget build(BuildContext context) {
    return Checkbox(
        value: role,
        onChanged: (value) {
          if (role == false) {
            setState(() {
              role = value!;
            });
          } else if (role == true) {
            setState(() {
              role = value!;
            });
          }
          
        });
  }
}
