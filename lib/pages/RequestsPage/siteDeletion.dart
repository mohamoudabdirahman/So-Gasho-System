import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:searchbar_animation/const/colours.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/utils/Buttons.dart';

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
  var requestchecking = false;
  var items = [
    'Sites',
    'Sectors',
  ];
  var disableditem = 'P2P';
  var modes = [
    'PTMP',
    'P2P',
    'LTE',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 210,
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
                      disabledHint: Text('You cannot select this!'),
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
                                child: Text(
                                  modes,
                                  style: TextStyle(
                                      color: disableditem.contains(modes) &&
                                              dropdownvalue == 'Sectors'
                                          ? Colors.grey
                                          : AppColors().black),
                                ),
                              )),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        if (disableditem.contains(newValue!) &&
                            dropdownvalue == 'Sites') {
                          setState(() {
                            modedropdownvalue = newValue;
                          });
                        } else if (!disableditem.contains(newValue)) {
                          setState(() {
                            modedropdownvalue = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            dropdownvalue == 'Sites'
                ? Padding(
                    padding: const EdgeInsets.only(left: 20, top: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Table(
                            children: [
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    'Region',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors().black),
                                  ),
                                ),
                                Text(
                                  'Site Name',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors().black),
                                ),
                                Text(
                                  'Decision',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors().black),
                                ),
                              ]),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(),
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
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: Text(
                                    'There is no Site deletion Requests yet!',
                                    style: TextStyle(color: AppColors().black),
                                  ),
                                );
                              }
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    'Something went wrong!',
                                    style: TextStyle(color: AppColors().black),
                                  ),
                                );
                              }

                              if (snapshot.hasData) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      var docid =
                                          snapshot.data!.docs[index]['DocId'];
                                      if (snapshot.data!.docs[index]
                                              ['Isapproved'] ==
                                          'Pending') {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Table(
                                                defaultVerticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                children: [
                                                  TableRow(
                                                      decoration: BoxDecoration(
                                                          color: AppColors()
                                                              .fifthcolor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                blurRadius: 8,
                                                                offset: Offset(
                                                                    3, 4),
                                                                spreadRadius: 5,
                                                                color: AppColors()
                                                                    .black
                                                                    .withOpacity(
                                                                        0.1))
                                                          ]),
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child: Text(
                                                            '${snapshot.data!.docs[index]['Region']}',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${snapshot.data!.docs[index]['SiteName']}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors()
                                                                  .black),
                                                        ),
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  acceptingSiteDeletion(
                                                                      docid);
                                                                },
                                                                icon: Icon(
                                                                  Icons
                                                                      .check_box_rounded,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          3,
                                                                          133,
                                                                          57),
                                                                )),
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                            IconButton(
                                                                onPressed: () {
                                                                  rejectingDeltion(
                                                                      docid);
                                                                },
                                                                icon: Icon(
                                                                  Icons
                                                                      .cancel_rounded,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          150,
                                                                          13,
                                                                          4),
                                                                ))
                                                          ],
                                                        )
                                                      ])
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      } else {
                                        var request = true;
                                        return Container();
                                      }
                                    });
                              }
                              return Center(child: CircularProgressIndicator());
                            }),
                      ],
                    ),
                  )
                : StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collectionGroup('Sectors')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            'There is no Site deletion Requests yet!',
                            style: TextStyle(color: AppColors().black),
                          ),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Something went wrong!',
                            style: TextStyle(color: AppColors().black),
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10, top: 30),
                            child: modedropdownvalue == 'PTMP'
                                ? Table(
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    columnWidths: {
                                      0: FlexColumnWidth(6),
                                      1: FlexColumnWidth(5),
                                      2: FlexColumnWidth(0.8),
                                      3: FlexColumnWidth(1.8),
                                      4: FlexColumnWidth(2.6),
                                      5: FlexColumnWidth(2.8),
                                      6: FlexColumnWidth(2),
                                      7: FlexColumnWidth(3),
                                      8: FlexColumnWidth(1),
                                      9: FlexColumnWidth(3),
                                      10: FlexColumnWidth(2),
                                      11: FlexColumnWidth(2),
                                      12: FlexColumnWidth(1),
                                      13: FlexColumnWidth(2.8),
                                      14: FlexColumnWidth(2.8),
                                    },
                                    children: [
                                      TableRow(children: [
                                        Text(
                                          'Sector Name',
                                          style: TextStyle(
                                              color: AppColors().black,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Ssid',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors().black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Band',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors().black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Rocket Name',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors().black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Ip address',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors().black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Mac address',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors().black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Port Number',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors().black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Wireless mode',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors().black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Vlan',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors().black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Serving Mikrotic',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors().black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Height',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors().black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Azmuth',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors().black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Tilt',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors().black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Lat',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors().black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Lon',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors().black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Decision',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors().black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ])
                                    ],
                                  )
                                : Table(
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    columnWidths: const {
                                      0: FlexColumnWidth(6),
                                      1: FlexColumnWidth(2),
                                      2: FlexColumnWidth(2),
                                      3: FlexColumnWidth(2),
                                      4: FlexColumnWidth(2),
                                      5: FlexColumnWidth(2),
                                      6: FlexColumnWidth(2),
                                      7: FlexColumnWidth(2),
                                      8: FlexColumnWidth(2),
                                      9: FlexColumnWidth(4),
                                      10: FlexColumnWidth(4),
                                      11: FlexColumnWidth(3),
                                    },
                                    children: const [
                                      TableRow(children: [
                                        Text(
                                          'Sector In Sys',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Sectid',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Height Of Tower',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Height Of Building',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Height Of Antena',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Azmuth',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Mechanic Tilt',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'ELectical Tilt',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Tilt',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Lat',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Lon',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Options',
                                          textAlign: TextAlign.center,
                                        ),
                                      ])
                                    ],
                                  ),
                          ),
                          Divider(),
                          SizedBox(
                            height: 15,
                          ),
                          ListView.builder(
                              itemCount: snapshot.data?.docs.length,
                              shrinkWrap: true,
                              itemBuilder: ((context, index) {
                                if (snapshot.data!.docs[index]['Type'] ==
                                        'PTMP' &&
                                    modedropdownvalue == 'PTMP' &&
                                    snapshot.data!.docs[index]
                                            ['IsectorApproved'] ==
                                        'Pending') {
                                  var docid =
                                      snapshot.data!.docs[index]['SectorId'];
                                  var parentid = snapshot.data!.docs[index]
                                      ['ParentCollectionID'];
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Table(
                                          defaultVerticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          // border: TableBorder.all(width: 0.5),
                                          columnWidths: const {
                                            0: FlexColumnWidth(6),
                                            1: FlexColumnWidth(5),
                                            2: FlexColumnWidth(0.8),
                                            3: FlexColumnWidth(1.8),
                                            4: FlexColumnWidth(2.6),
                                            5: FlexColumnWidth(2.8),
                                            6: FlexColumnWidth(2),
                                            7: FlexColumnWidth(3),
                                            8: FlexColumnWidth(1),
                                            9: FlexColumnWidth(3),
                                            10: FlexColumnWidth(2),
                                            11: FlexColumnWidth(2),
                                            12: FlexColumnWidth(1),
                                            13: FlexColumnWidth(2.8),
                                            14: FlexColumnWidth(2.8),
                                          },
                                          children: [
                                            TableRow(
                                                decoration: BoxDecoration(
                                                    color:
                                                        AppColors().fifthcolor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 8,
                                                          offset: Offset(3, 4),
                                                          spreadRadius: 5,
                                                          color: AppColors()
                                                              .black
                                                              .withOpacity(
                                                                  0.08))
                                                    ]),
                                                children: [
                                                  SelectableText(
                                                    '${snapshot.data!.docs[index]['SectorName']}',
                                                    style: TextStyle(
                                                        color:
                                                            AppColors().black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SelectableText(
                                                    '${snapshot.data!.docs[index]['Ssid']}',
                                                    style: TextStyle(
                                                        color:
                                                            AppColors().black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SelectableText(
                                                    '${snapshot.data!.docs[index]['Band']}',
                                                    style: TextStyle(
                                                        color:
                                                            AppColors().black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SelectableText(
                                                    '${snapshot.data!.docs[index]['RocketName']}',
                                                    style: TextStyle(
                                                        color:
                                                            AppColors().black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SelectableText(
                                                    '${snapshot.data!.docs[index]['IpAddress']}',
                                                    style: TextStyle(
                                                        color:
                                                            AppColors().black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SelectableText(
                                                    '${snapshot.data!.docs[index]['MacAddress']}',
                                                    style: TextStyle(
                                                        color:
                                                            AppColors().black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SelectableText(
                                                    '${snapshot.data!.docs[index]['PortNumber']}',
                                                    style: TextStyle(
                                                        color:
                                                            AppColors().black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SelectableText(
                                                    '${snapshot.data!.docs[index]['WirelessMode']}',
                                                    style: TextStyle(
                                                        color:
                                                            AppColors().black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SelectableText(
                                                    '${snapshot.data!.docs[index]['Vlan']}',
                                                    style: TextStyle(
                                                        color:
                                                            AppColors().black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SelectableText(
                                                    '${snapshot.data!.docs[index]['ServingMikrotic']}',
                                                    style: TextStyle(
                                                        color:
                                                            AppColors().black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SelectableText(
                                                    '${snapshot.data!.docs[index]['Height']}',
                                                    style: TextStyle(
                                                        color:
                                                            AppColors().black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SelectableText(
                                                    '${snapshot.data!.docs[index]['Azmuth']}',
                                                    style: TextStyle(
                                                        color:
                                                            AppColors().black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SelectableText(
                                                    '${snapshot.data!.docs[index]['Tilt']}',
                                                    style: TextStyle(
                                                        color:
                                                            AppColors().black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SelectableText(
                                                    '${snapshot.data!.docs[index]['Lat']}',
                                                    style: TextStyle(
                                                        color:
                                                            AppColors().black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SelectableText(
                                                    '${snapshot.data!.docs[index]['Long']}',
                                                    style: TextStyle(
                                                        color:
                                                            AppColors().black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                content:
                                                                    Container(
                                                                  height: 150,
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        'Take a decision whether you would approve to delete this sector or not!',
                                                                        style: TextStyle(
                                                                            color:
                                                                                AppColors().black),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Buttons(
                                                                              buttonColor: Colors.red,
                                                                              buttonText: 'Accept(Delete)',
                                                                              ontap: () {
                                                                                acceptingSectorDeletion(docid, parentid);
                                                                                Navigator.of(context).pop();
                                                                              }),
                                                                          SizedBox(
                                                                            width:
                                                                                30,
                                                                          ),
                                                                          Buttons(
                                                                              buttonColor: AppColors().secondcolor,
                                                                              buttonText: 'Deny',
                                                                              ontap: () {
                                                                                denyingSectorDeletion(docid, parentid);
                                                                                Navigator.of(context).pop();
                                                                              })
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: [
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Buttons(
                                                                        buttonColor: AppColors().greycolor,
                                                                        buttonText: 'Cancel',
                                                                        ontap: () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        }),
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      icon: Icon(
                                                        Icons.more_horiz_sharp,
                                                        color: AppColors()
                                                            .secondcolor,
                                                      ))
                                                ]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (snapshot.data!.docs[index]['Type'] ==
                                        'LTE' &&
                                    modedropdownvalue == 'LTE' &&
                                    snapshot.data!.docs[index]
                                            ['IsectorApproved'] ==
                                        'Pending') {
                                  var parentid = snapshot.data!.docs[index]
                                      ['ParentCollectionID'];
                                  var docid =
                                      snapshot.data!.docs[index]['SectorId'];
                                  return Table(
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      // border: TableBorder.all(width: 0.5),
                                      columnWidths: const {
                                        0: FlexColumnWidth(6),
                                        1: FlexColumnWidth(2),
                                        2: FlexColumnWidth(2),
                                        3: FlexColumnWidth(2),
                                        4: FlexColumnWidth(2),
                                        5: FlexColumnWidth(2),
                                        6: FlexColumnWidth(2),
                                        7: FlexColumnWidth(2),
                                        8: FlexColumnWidth(2),
                                        9: FlexColumnWidth(4),
                                        10: FlexColumnWidth(4),
                                        11: FlexColumnWidth(3),
                                      },
                                      children: [
                                        TableRow(
                                            decoration: BoxDecoration(
                                                color: AppColors().fifthcolor,
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 8,
                                                      offset: Offset(3, 4),
                                                      spreadRadius: 5,
                                                      color: AppColors()
                                                          .black
                                                          .withOpacity(0.08))
                                                ]),
                                            children: [
                                              SelectableText(
                                                '${snapshot.data!.docs[index]['SectorName']}',
                                                style: TextStyle(
                                                    color: AppColors().black),
                                                textAlign: TextAlign.center,
                                              ),
                                              SelectableText(
                                                '${snapshot.data!.docs[index]['sectid']}',
                                                style: TextStyle(
                                                    color: AppColors().black),
                                                textAlign: TextAlign.center,
                                              ),
                                              SelectableText(
                                                '${snapshot.data!.docs[index]['heightOfTower']}',
                                                style: TextStyle(
                                                    color: AppColors().black),
                                                textAlign: TextAlign.center,
                                              ),
                                              SelectableText(
                                                '${snapshot.data!.docs[index]['heightOfBuilding']}',
                                                style: TextStyle(
                                                    color: AppColors().black),
                                                textAlign: TextAlign.center,
                                              ),
                                              SelectableText(
                                                '${snapshot.data!.docs[index]['heightOfAntena']}',
                                                style: TextStyle(
                                                    color: AppColors().black),
                                                textAlign: TextAlign.center,
                                              ),
                                              SelectableText(
                                                '${snapshot.data!.docs[index]['Azmuth']}',
                                                style: TextStyle(
                                                    color: AppColors().black),
                                                textAlign: TextAlign.center,
                                              ),
                                              SelectableText(
                                                '${snapshot.data!.docs[index]['mechanicTilt']}',
                                                style: TextStyle(
                                                    color: AppColors().black),
                                                textAlign: TextAlign.center,
                                              ),
                                              SelectableText(
                                                '${snapshot.data!.docs[index]['electicalTilt']}',
                                                style: TextStyle(
                                                    color: AppColors().black),
                                                textAlign: TextAlign.center,
                                              ),
                                              SelectableText(
                                                '${snapshot.data!.docs[index]['Tilt']}',
                                                style: TextStyle(
                                                    color: AppColors().black),
                                                textAlign: TextAlign.center,
                                              ),
                                              SelectableText(
                                                '${snapshot.data!.docs[index]['Lat']}',
                                                style: TextStyle(
                                                    color: AppColors().black),
                                                textAlign: TextAlign.center,
                                              ),
                                              SelectableText(
                                                '${snapshot.data!.docs[index]['Long']}',
                                                style: TextStyle(
                                                    color: AppColors().black),
                                                textAlign: TextAlign.center,
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            content: Container(
                                                              height: 150,
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    'Take a decision whether you would approve to delete this sector or not!',
                                                                    style: TextStyle(
                                                                        color: AppColors()
                                                                            .black),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Buttons(
                                                                          buttonColor: Colors
                                                                              .red,
                                                                          buttonText:
                                                                              'Accept(Delete)',
                                                                          ontap:
                                                                              () {
                                                                            acceptingSectorDeletion(docid,
                                                                                parentid);
                                                                          }),
                                                                      SizedBox(
                                                                        width:
                                                                            30,
                                                                      ),
                                                                      Buttons(
                                                                          buttonColor: AppColors()
                                                                              .secondcolor,
                                                                          buttonText:
                                                                              'Deny',
                                                                          ontap:
                                                                              () {
                                                                            denyingSectorDeletion(docid,
                                                                                parentid);
                                                                          })
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: [
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Buttons(
                                                                    buttonColor:
                                                                        AppColors()
                                                                            .greycolor,
                                                                    buttonText:
                                                                        'Cancel',
                                                                    ontap: () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    }),
                                                              )
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  icon: Icon(
                                                    Icons.more_horiz_sharp,
                                                    color:
                                                        AppColors().secondcolor,
                                                  ))
                                            ])
                                      ]);
                                }
                                return Container();
                              })),
                        ]);
                      }
                      return Container();
                    })
          ],
        ),
      ),
    );
  }

  //Site accepting and denying functions.
  void rejectingDeltion(docid) {
    try {
      modedropdownvalue == 'PTMP'
          ? FirebaseFirestore.instance
              .collection('SiteData')
              .doc(docid)
              .update({'Isapproved': 'notRequested'})
          : modedropdownvalue == 'P2P'
              ? FirebaseFirestore.instance
                  .collection('P2P')
                  .doc(docid)
                  .update({'Isapproved': 'notRequested'})
              : FirebaseFirestore.instance
                  .collection('LTE')
                  .doc(docid)
                  .update({'Isapproved': 'notRequested'});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors().thirdcolor,
          content: Text(e.toString(),
              style: TextStyle(
                color: AppColors().fifthcolor,
              ))));
    }
  }

  void acceptingSiteDeletion(docid) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      desc: 'Do you really want to accept this Request and delete this Site?',
      btnOk: MaterialButton(
        color: AppColors().maincolor,
        onPressed: () {
          try {
            modedropdownvalue == 'PTMP'
                ? FirebaseFirestore.instance
                    .collection('SiteData')
                    .doc(docid)
                    .collection('Sectors')
                    .get()
                    .then((value) {
                    for (var element in value.docs) {
                      element.reference.delete();
                    }
                  })
                : modedropdownvalue == 'P2P'
                    ? FirebaseFirestore.instance
                    .collection('P2P')
                    .doc(docid)
                    .collection('Sectors')
                    .get()
                    .then((value) {
                    for (var element in value.docs) {
                      element.reference.delete();
                    }
                  })
                    : FirebaseFirestore.instance
                    .collection('LTE')
                    .doc(docid)
                    .collection('Sectors')
                    .get()
                    .then((value) {
                    for (var element in value.docs) {
                      element.reference.delete();
                    }
                  });
                  
            modedropdownvalue == 'PTMP'
                ? FirebaseFirestore.instance
                    .collection('SiteData')
                    .doc(docid)
                    .delete()
                : modedropdownvalue == 'P2P'
                    ? FirebaseFirestore.instance
                        .collection('P2P')
                        .doc(docid)
                        .delete()
                    : FirebaseFirestore.instance
                        .collection('LTE')
                        .doc(docid)
                        .delete();

            

            Navigator.of(context).pop();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: AppColors().thirdcolor,
                content: Text(e.toString(),
                    style: TextStyle(
                      color: AppColors().fifthcolor,
                    ))));
          }
        },
        child: Text(
          'Yes',
          style: TextStyle(color: AppColors().fifthcolor),
        ),
      ),
      btnCancel: MaterialButton(
        color: AppColors().greycolor,
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          'No',
          style: TextStyle(color: AppColors().maincolor),
        ),
      ),
    ).show();
  }

  //Sector accepting and denying functions
  void acceptingSectorDeletion(documentID, parentID) {
    try {
      if (modedropdownvalue == 'PTMP') {
        FirebaseFirestore.instance.collection('LTE').get().then((value) {
          FirebaseFirestore.instance
              .collection('SiteData')
              .doc(parentID)
              .collection('Sectors')
              .doc(documentID)
              .delete();
        });
      } else {
        FirebaseFirestore.instance.collection('LTE').get().then((value) {
          FirebaseFirestore.instance
              .collection('LTE')
              .doc(parentID)
              .collection('Sectors')
              .doc(documentID)
              .delete();
        });
      }
    } catch (e) {}
  }

  void denyingSectorDeletion(documentID, parentID) {
    try {
      if (modedropdownvalue == 'PTMP') {
        FirebaseFirestore.instance.collection('SiteData').get().then((value) {
          FirebaseFirestore.instance
              .collection('SiteData')
              .doc(parentID)
              .collection('Sectors')
              .doc(documentID)
              .update({'IsectorApproved': 'notrequested'});
        });
      } else {
        FirebaseFirestore.instance.collection('LTE').get().then((value) {
          FirebaseFirestore.instance
              .collection('LTE')
              .doc(parentID)
              .collection('Sectors')
              .doc(documentID)
              .update({'IsectorApproved': 'notrequested'});
        });
      }
    } catch (e) {}
  }
}
