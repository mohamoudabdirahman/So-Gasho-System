import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Box darkmode = Hive.box('darkmode');

class AppColors {
  Color maincolor = darkmode.get('darkmode') == false
      ? const Color(0xffB91F3B)
      : Color.fromARGB(181, 163, 199, 214);

  Color secondcolor = const Color(0xffF47C2A);

  Color thirdcolor = const Color(0xffD34D4D);
  Color fourthcolor = const Color(0xffCC3233);
  Color fifthcolor = darkmode.get('darkmode') == false
      ? const Color(0xffFFFFFF)
      : Color.fromARGB(255, 45, 5, 71);
  Color darkwhite = darkmode.get('darkmode') == false
      ? Color.fromARGB(255, 236, 236, 236)
      : Color.fromARGB(255, 65, 4, 105);
  Color greycolor = darkmode.get('darkmode') == false
      ? const Color(0xffD4D4D4)
      : Color(0xff0F3460);
  Color black = darkmode.get('darkmode') == false
      ? const Color(0xff070707)
      : const Color(0xffFFFFFF);
}
