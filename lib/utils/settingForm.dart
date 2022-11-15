import 'package:flutter/material.dart';
import 'package:somcable_web_app/colors/Colors.dart';

class SettingsForm extends StatelessWidget {
  var controller;
  String? label;
  SettingsForm({Key? key, required this.controller, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 607,
              child: Text(
                label!,
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: 607,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    filled: false,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide:
                            BorderSide(width: 2, color: AppColors().greycolor)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                            width: 2, color: AppColors().greycolor))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
