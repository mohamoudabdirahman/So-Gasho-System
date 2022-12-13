import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:somcable_web_app/colors/Colors.dart';

class SiteDeletionRequest extends StatefulWidget {
  const SiteDeletionRequest({Key? key}) : super(key: key);

  @override
  State<SiteDeletionRequest> createState() => _SiteDeletionRequestState();
}

class _SiteDeletionRequestState extends State<SiteDeletionRequest> {
  var selectedtabs = 'DeletedSite';
  var selecteddeletionrequest = 'sites';
  var dropdownvalue = 'Sites';
  var modedropdownvalue = 'PTMP';
  var items = [
    'Sites',
    'Sectors',
  ];
  var modes = [
    'PTMP',
    'P2P',
    'LTE',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 180,
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors().greycolor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton(
                      style: TextStyle(color: Colors.black),
                      underline: Divider(
                        height: 0.0,
                      ),
                      borderRadius: BorderRadius.circular(10),

                      autofocus: true,
                      dropdownColor:
                          Color.fromARGB(255, 255, 218, 9).withAlpha(255),
                      focusColor:
                          Color.fromARGB(255, 182, 149, 0).withAlpha(255),
                      // Initial Value
                      value: dropdownvalue,

                      // Down Arrow Icon
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Icon(
                          Icons.expand_circle_down_rounded,
                          color: AppColors().maincolor,
                        ),
                      ),

                      // Array list of items
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Container(
                              width: 300,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(items),
                              )),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors().greycolor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton(
                      style: TextStyle(color: Colors.black),
                      underline: Divider(
                        height: 0.0,
                      ),
                      borderRadius: BorderRadius.circular(10),

                      autofocus: true,
                      dropdownColor:
                          Color.fromARGB(255, 255, 218, 9).withAlpha(255),
                      focusColor:
                          Color.fromARGB(255, 182, 149, 0).withAlpha(255),
                      // Initial Value
                      value: modedropdownvalue,

                      // Down Arrow Icon
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Icon(
                          Icons.expand_circle_down_rounded,
                          color: AppColors().maincolor,
                        ),
                      ),

                      // Array list of items
                      items: modes.map((String modes) {
                        return DropdownMenuItem(
                          value: modes,
                          child: Container(
                              width: 300,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(modes),
                              )),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          modedropdownvalue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            dropdownvalue == 'Sites'
                ? Column(
                  children: [
                    Table(
                                children: [
                                  TableRow(children: [
                                    Text(
                                      'Region',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors().black),
                                    ),
                                    Text(
                                      'Site Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors().black),
                                    ),
                                  ]),
                                  
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                    StreamBuilder(
                        stream: modedropdownvalue == 'PTMP'
                            ? FirebaseFirestore.instance
                                .collection('SiteData')
                                .snapshots()
                            : modedropdownvalue == 'P2P'
                                ? FirebaseFirestore.instance
                                    .collection('P2P')
                                    .snapshots()
                                : FirebaseFirestore.instance
                                    .collection('LTE')
                                    .snapshots(),
                        // stream:  dropdownvalue == 'Sites' && modedropdownvalue == 'PTMP' ? FirebaseFirestore.instance.collection('SiteData').snapshots() : dropdownvalue == 'Sites' && modedropdownvalue == 'P2P' ? FirebaseFirestore.instance.collection('P2P').snapshots() : dropdownvalue == 'Sites' && modedropdownvalue == 'LTE' ? FirebaseFirestore.instance.collection('LTE').snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            print('ther is no data');
                          }
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Table(
                                      children: [
                                        TableRow(
                                          decoration: BoxDecoration(
                                                    color:  AppColors().fifthcolor,
                                                    borderRadius:
                                                        BorderRadius.circular(7),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 8,
                                                          offset: Offset(3, 4),
                                                          spreadRadius: 5,
                                                          color: AppColors()
                                                              .black
                                                              .withOpacity(0.1))
                                                    ]),
                                          children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          '${snapshot.data!.docs[index]['Region']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors().black),
                                        ),
                                      ),
                                      Text(
                                        '${snapshot.data!.docs[index]['SiteName']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors().black),
                                      ),
                                    ])
                                      ],
                                    ),
                                  )
                                ],
                              );
                            });
                          }
                          return CircularProgressIndicator();
                        }),
                  ],
                )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
