import 'package:flutter/material.dart';
import 'package:somcable_web_app/colors/Colors.dart';

class LoginBox extends StatelessWidget {
  String? placeholder;
  var placeholdericon;
  var widthoftextfield;
  var autofill;
  var labeling;
  TextEditingController controller = TextEditingController();
  bool passwordvisibility;
  
  LoginBox(
      {Key? key,
      required this.placeholder,
      required this.placeholdericon,
      required this.passwordvisibility,
      required this.controller,
      
      this.labeling,
      this.autofill,
      this.widthoftextfield})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: widthoftextfield,
        child: AutofillGroup(
          child: TextFormField(
            autofillHints: [autofill],
            onSaved: (value) {},
            
            controller: controller,
            obscureText: passwordvisibility,
            decoration: InputDecoration(
              labelText: labeling,
              fillColor: AppColors().secondcolor,
              filled: true,
              focusColor: AppColors().fifthcolor,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(39),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors().fifthcolor, width: 1),
                  borderRadius: BorderRadius.circular(39)),
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 1, color: AppColors().fifthcolor)),
              hintText: placeholder,
              hintStyle: TextStyle(color: AppColors().fifthcolor),
              suffixIcon: placeholdericon,
            ),
          ),
        ),
      ),
    );
  }
}
