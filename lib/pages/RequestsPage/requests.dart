import 'package:flutter/material.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/pages/RequestsPage/siteDeletion.dart';
import 'package:somcable_web_app/pages/RequestsPage/useracception.dart';

class Requests extends StatefulWidget {
  const Requests({Key? key}) : super(key: key);

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  var selectedtab = 'SiteDeletion';
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 196,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 60,top: 15,right: 15.0),
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width - 196,
              decoration: BoxDecoration(
                  color:
                      AppColors().maincolor,
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          selectedtab = 'SiteDeletion';
                        });
                      },
                      height: 40,
                      shape: StadiumBorder(),
                      color: selectedtab != 'SiteDeletion'
                          ? AppColors().darkwhite
                          : AppColors().secondcolor,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        child: Text(
                          'Site Deletion Request',
                          style: TextStyle(
                              color: selectedtab != 'SiteDeletion'
                                  ? AppColors().black
                                  : AppColors().fifthcolor),
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          selectedtab = 'userDeletionRequest';
                        });
                      },
                      height: 40,
                      shape: StadiumBorder(),
                      color: selectedtab != 'userDeletionRequest'
                          ? AppColors().darkwhite
                          : AppColors().secondcolor,
                      child: Text('User Deletion Request',
                          style: TextStyle(
                              color: selectedtab != 'userDeletionRequest'
                                  ? AppColors().black
                                  : AppColors().fifthcolor)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              selectedtab == 'SiteDeletion' ? SiteDeletionRequest() : UserAcceptance(),
            ],
          )
        ],
      ),
    );
  }
}
