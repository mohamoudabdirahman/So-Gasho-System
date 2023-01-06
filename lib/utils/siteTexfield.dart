import 'package:flutter/material.dart';
import 'package:somcable_web_app/colors/Colors.dart';

class SiteTextfield extends StatelessWidget {
  var controller;
  var onchange;
  var hinText;
  SiteTextfield({Key? key, required this.controller, this.onchange,this.hinText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          autofocus: true,
          onChanged: onchange,
          decoration: InputDecoration(
            
            contentPadding: EdgeInsets.all(0),
            hintText: hinText,
            hintStyle: TextStyle(color: AppColors().darkwhite),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors().black,
                  width: 0.5,
                  style: BorderStyle.solid,
                )),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: AppColors().black,
                    width: 0.5,
                    style: BorderStyle.solid)),
          ),
          controller: controller,
        ));
  }
}
