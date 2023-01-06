import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/pages/CustomerLocation/customerLocation.dart';
import 'package:somcable_web_app/pages/sites/lte2.dart';
import 'package:flutter_map/flutter_map.dart' as marker;
import 'package:latlong2/latlong.dart';
import 'package:somcable_web_app/pages/sites/p2p.dart';
import 'package:somcable_web_app/pages/sites/ptmp.dart';
import 'package:somcable_web_app/utils/Buttons.dart';
import 'package:somcable_web_app/utils/TextButton.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class Sites extends StatefulWidget {
  const Sites({Key? key}) : super(key: key);

  @override
  State<Sites> createState() => _SitesState();
}

class _SitesState extends State<Sites> {
  var searchbuttontapped = false;
  String? selectedtab = 'ptmp';
  TextEditingController controller = TextEditingController();
  var searchedName = '';
  var issitedelete = false;

  var expand = false;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 196,
                      decoration: BoxDecoration(
                          color: AppColors().maincolor,
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                setState(() {
                                  selectedtab = 'ptmp';
                                  if (searchbuttontapped == true) {
                                    setState(() {
                                      searchbuttontapped = false;
                                    });
                                  }
                                });
                              },
                              height: 40,
                              shape: StadiumBorder(),
                              color: selectedtab != 'ptmp'
                                  ? AppColors().darkwhite
                                  : AppColors().secondcolor,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 20, left: 20),
                                child: Text(
                                  'Fixed Wireless PTMP',
                                  style: TextStyle(
                                      color: selectedtab != 'ptmp'
                                          ? AppColors().black
                                          : AppColors().fifthcolor),
                                ),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                setState(() {
                                  selectedtab = 'p2p';
                                  if (searchbuttontapped == true) {
                                    setState(() {
                                      searchbuttontapped = false;
                                    });
                                  }
                                });
                              },
                              height: 40,
                              shape: StadiumBorder(),
                              color: selectedtab != 'p2p'
                                  ? AppColors().darkwhite
                                  : AppColors().secondcolor,
                              child: Text('P2P',
                                  style: TextStyle(
                                      color: selectedtab != 'p2p'
                                          ? AppColors().black
                                          : AppColors().fifthcolor)),
                            ),
                            MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    selectedtab = 'lte';
                                    // if (searchbuttontapped == true) {
                                    //   setState(() {
                                    //     searchbuttontapped = false;
                                    //   });
                                    // }
                                  });
                                },
                                height: 40,
                                shape: StadiumBorder(),
                                color: selectedtab != 'lte'
                                    ? AppColors().darkwhite
                                    : AppColors().secondcolor,
                                child: Text(
                                  'LTE',
                                  style: TextStyle(
                                      color: selectedtab != 'lte'
                                          ? AppColors().black
                                          : AppColors().fifthcolor),
                                )),
                            MaterialButton(
                              onPressed: () {
                                setState(() {
                                  selectedtab = 'CustomerLocation';
                                  if (searchbuttontapped == true) {
                                    setState(() {
                                      searchbuttontapped = false;
                                    });
                                  }
                                });
                              },
                              height: 40,
                              shape: StadiumBorder(),
                              color: selectedtab != 'CustomerLocation'
                                  ? AppColors().darkwhite
                                  : AppColors().secondcolor,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 20, left: 20),
                                child: Text(
                                  'Customer Location',
                                  style: TextStyle(
                                      color: selectedtab != 'CustomerLocation'
                                          ? AppColors().black
                                          : AppColors().fifthcolor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Stack(children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            selectedtab == 'ptmp'
                                ? Ptmp()
                                : selectedtab == 'p2p'
                                    ? P2p()
                                    : selectedtab == 'lte'
                                        ? LTE()
                                        : CustomerLocation()
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: 25,
                        left: 15,
                        child: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actions: [
                                        Buttons(
                                            buttonColor: AppColors().maincolor,
                                            buttonText: 'Cancel',
                                            ontap: () {
                                              Navigator.of(context).pop();
                                            })
                                      ],
                                      title: Text(
                                        'Information!',
                                        style: TextStyle(
                                            fontSize: 35,
                                            color: AppColors().secondcolor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      icon: Icon(
                                        Icons.help_rounded,
                                        size: 35,
                                      ),
                                      iconColor: AppColors().maincolor,
                                      content: const Text(
                                        '''The sites that have yellow background color are in a pending deletion request made by a user,
You will not be able to add or edit anything about this site until it is approved or denied by the administrator!
please be patient.''',
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  });
                            },
                            icon: Icon(
                              Icons.help,
                              color: AppColors().maincolor,
                            )))
                  ]),
                ]),
          ),
        ),
      ),
    );
  }
}
