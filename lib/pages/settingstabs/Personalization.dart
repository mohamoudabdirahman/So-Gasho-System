import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:somcable_web_app/colors/Colors.dart';

class Personalization extends StatefulWidget {
  const Personalization({super.key});

  @override
  State<Personalization> createState() => _PersonalizationState();
}

class _PersonalizationState extends State<Personalization> {
  bool darkmode = false;
  Box darkmodebox = Hive.box('darkmode');
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 936,
            height: 433,
            decoration: BoxDecoration(
                color: AppColors().darkwhite,
                borderRadius: BorderRadius.circular(70),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.5))
                ]),
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: []),
            ),
          ),
        )
      ],
    );
  }
}
