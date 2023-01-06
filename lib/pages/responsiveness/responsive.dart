import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget desktopbody;

  final Widget mobilebody;
  Responsive({Key? key, required this.desktopbody, required this.mobilebody})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrainsts) {
      if (constrainsts.maxWidth < 1800) {
        return mobilebody;
      } else if (constrainsts.maxWidth > 1920) {
        return mobilebody;
      }else{
        return desktopbody;
      }
    });
  }
}
