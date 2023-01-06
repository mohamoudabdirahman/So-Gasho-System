import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:searchbar_animation/const/colours.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/utils/Buttons.dart';
import 'package:url_launcher/url_launcher.dart';

class FejiPage extends StatefulWidget {
  FejiPage({Key? key}) : super(key: key);

  @override
  State<FejiPage> createState() => _FejiPageState();
}

class _FejiPageState extends State<FejiPage> {
  bool whyDba = false;
  final Uri _url = Uri.parse('https://www.careerexplorer.com/careers/database-administrator/');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Stack(
        children: [
          Container(
             decoration: BoxDecoration(
              
              color: Color.fromARGB(255, 16, 9, 75),
              image:  DecorationImage(
                fit: BoxFit.cover,
                colorFilter:  ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                image: const AssetImage('lib/images/404.jpg'),
             ))),
          Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
               Container(
                decoration: BoxDecoration(
                  color: AppColors().fifthcolor,
                  borderRadius: BorderRadius.circular(15),

                ),
                 child: Padding(
                   padding: const EdgeInsets.all(25.0),
                   child: Text(
                      '''The System detected no database Adminstrator activities inside the system for the last five days,
      This system will no longer work until it detects a database admin activity,
      if you want to know what is the database admin press the button bellow!''',
      style: TextStyle(fontSize: 25,color: AppColors().black,),
      
      textAlign: TextAlign.center,),
                 ),
               ),
              const SizedBox(
                height: 10,
              ),
              Buttons(
                buttonColor: AppColors().maincolor,
                  buttonText: 'Why Database Admin',
                  ontap: () {
                    setState(() {
                      whyDba = true;
                    });
                    launchUrl(_url);
                  })
            ],
        ),
          ),
        
        ]
      ),
    );
  }

}

