import 'package:flutter/material.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/pages/adminDashboard.dart';
import 'package:somcable_web_app/pages/loginpage.dart';

class NavigationButtons extends StatefulWidget {
  String? navigationtitle;
  var navigationIcon;
  var onpressed;
  var backcolor;
  NavigationButtons(
      {Key? key,
      required this.navigationtitle,
      required this.navigationIcon,
      required this.onpressed,
      required this.backcolor})
      : super(key: key);

  @override
  State<NavigationButtons> createState() => _NavigationButtonsState();
}

class _NavigationButtonsState extends State<NavigationButtons> {
  bool? isvisible = false;

  bool ishovered = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Material(
        color: widget.backcolor,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
            onTap: widget.onpressed,
            splashColor: AppColors().thirdcolor.withOpacity(0.3),
            highlightColor: AppColors().greycolor.withOpacity(0.3),
            customBorder: StadiumBorder(),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors().fifthcolor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            widget.navigationIcon,
                            color: AppColors().secondcolor,
                            size: 30,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        widget.navigationtitle!,
                        style: TextStyle(
                            fontSize: 20, color: AppColors().fifthcolor),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      isvisible!
                          ? Container(
                              height: 40,
                              width: 7,
                              decoration: BoxDecoration(
                                  color: AppColors().secondcolor,
                                  borderRadius: BorderRadius.circular(10)),
                            )
                          : SizedBox()
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
