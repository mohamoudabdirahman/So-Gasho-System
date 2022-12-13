

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/utils/siteTexfield.dart';

class LTE extends StatefulWidget {
  LTE({super.key});

  @override
  State<LTE> createState() => _LTEState();
}

class _LTEState extends State<LTE> {
  final regioncontroller = TextEditingController();
  final siteName = TextEditingController();
  final sectorName = TextEditingController();
  final sectid = TextEditingController();
  final heightOfTower = TextEditingController();
  final heightOfBuilding = TextEditingController();
  final heightOfAntena = TextEditingController();
  final mechanicTilt = TextEditingController();
  final electicalTilt = TextEditingController();
  final azmuth = TextEditingController();
  final tilt = TextEditingController();
  final lat = TextEditingController();
  final lon = TextEditingController();
  var check = false;
  var cancelling = true;
  var isupdating = false;
  var sectorview = false;
  var sectorfieldvisibilty = false;
  int? selectedIndex;
  var userbox = Hive.box('Role');
  var issitedelete = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    regioncontroller.dispose();
    siteName.dispose();
    sectorName.dispose();
    sectid.dispose();
    heightOfTower.dispose();
    heightOfBuilding.dispose();
    heightOfAntena.dispose();
    mechanicTilt.dispose();
    electicalTilt.dispose();

    azmuth.dispose();
    tilt.dispose();
    lat.dispose();
    lon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 40, left: 8, right: 8),
          child: Container(
              width: MediaQuery.of(context).size.width - 196,
              child: Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Table(
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Region',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors().black),
                            ),
                          ),
                          Text('Site Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors().black)),
                          Text(
                            'Sectors',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors().black),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Options',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors().black),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                        check == true
                            ? TableRow(children: [
                                SiteTextfield(
                                  controller: regioncontroller,
                                  onchange: (value) {
                                    if (regioncontroller.text.isEmpty &&
                                        siteName.text.isEmpty) {
                                      setState(() {
                                        cancelling = true;
                                      });
                                    } else {
                                      setState(() {
                                        cancelling = false;
                                      });
                                    }
                                  },
                                ),
                                SiteTextfield(
                                  controller: siteName,
                                  onchange: (value) {
                                    if (siteName.text.isEmpty &&
                                        regioncontroller.text.isEmpty) {
                                      setState(() {
                                        cancelling = true;
                                      });
                                    } else {
                                      setState(() {
                                        cancelling = false;
                                      });
                                    }
                                  },
                                ),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          cancelling
                                              ? check = false
                                              : saveSite();
                                          setState(() {
                                            check = false;
                                            regioncontroller.clear();
                                            siteName.clear();
                                          });
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    cancelling
                                                        ? AppColors().greycolor
                                                        : AppColors()
                                                            .secondcolor)),
                                        child: Text(
                                          cancelling ? 'Cancel' : 'Save',
                                        ),
                                      ),
                                    )),
                                SizedBox()
                              ])
                            : TableRow(children: [
                                SizedBox(),
                                SizedBox(),
                                SizedBox(),
                                SizedBox()
                              ])
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      height: 1,
                      color: AppColors().black.withOpacity(0.5),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('LTE')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                            //print(snapshot.data!.docs[0]['SiteName']);
                            return Column(
                              children: [
                                Text(
                                  'there is no sites registered!',
                                  style: TextStyle(color: AppColors().black),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            );
                          }
                          if (snapshot.hasData) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: ((context, index) {
                                  var docid =
                                      snapshot.data!.docs[index]['DocId'];
                                  if (snapshot.data!.docs[index]
                                          ['Isapproved'] ==
                                      'Pending') {
                                    issitedelete = true;
                                  } else if (snapshot.data!.docs[index]
                                          ['Isapproved'] ==
                                      'notrequested') {
                                    issitedelete = false;
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 13),
                                    child: Column(
                                      children: [
                                        Table(children: [
                                          TableRow(
                                              decoration: BoxDecoration(
                                                  color: snapshot.data!
                                                                  .docs[index]
                                                              ['Isapproved'] ==
                                                          'Pending'
                                                      ? Colors.yellowAccent
                                                          .withAlpha(180)
                                                      : AppColors().fifthcolor,
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
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: isupdating == true &&
                                                          selectedIndex == index
                                                      ? SiteTextfield(
                                                          hinText: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                              ['Region'],
                                                          controller:
                                                              regioncontroller)
                                                      : SelectableText(
                                                          '${snapshot.data!.docs[index]['Region']}',
                                                          style: TextStyle(
                                                              color: AppColors()
                                                                  .black),
                                                        ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: isupdating == true &&
                                                          selectedIndex == index
                                                      ? SiteTextfield(
                                                          hinText: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                              ['SiteName'],
                                                          controller: siteName)
                                                      : SelectableText(
                                                          '${snapshot.data!.docs[index]['SiteName']}',
                                                          style: TextStyle(
                                                              color: AppColors()
                                                                  .black)),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          isupdating == true &&
                                                                  selectedIndex ==
                                                                      index
                                                              ? updatesite(
                                                                  docid)
                                                              : updateSectorview(
                                                                  index);
                                                        },
                                                        icon: Icon(
                                                          isupdating == true &&
                                                                  selectedIndex ==
                                                                      index
                                                              ? Icons
                                                                  .check_circle
                                                              : Icons
                                                                  .expand_circle_down_rounded,
                                                          color: AppColors()
                                                              .secondcolor,
                                                        )),
                                                    snapshot.data!.docs[index][
                                                                'Isapproved'] ==
                                                            'Pending'
                                                        ? SizedBox()
                                                        : IconButton(
                                                            onPressed: () {
                                                              sectorfield(
                                                                snapshot.data!
                                                                            .docs[
                                                                        index]
                                                                    ['DocId'],
                                                              );
                                                            },
                                                            icon: Icon(
                                                              Icons.add,
                                                              color: AppColors()
                                                                  .secondcolor,
                                                            )),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    snapshot.data!.docs[index][
                                                                'Isapproved'] ==
                                                            'Pending'
                                                        ? SizedBox()
                                                        : IconButton(
                                                            onPressed: () {
                                                              updatevariable(
                                                                  index);
                                                            },
                                                            icon: Icon(
                                                              isupdating ==
                                                                          true &&
                                                                      selectedIndex ==
                                                                          index
                                                                  ? Icons
                                                                      .close_outlined
                                                                  : Icons
                                                                      .edit_note_outlined,
                                                              color: AppColors()
                                                                  .secondcolor,
                                                            )),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    snapshot.data!.docs[index][
                                                                'Isapproved'] ==
                                                            'Pending'
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5),
                                                            child: Container(
                                                              width: 35,
                                                              height: 35,
                                                              child:
                                                                  LoadingIndicator(
                                                                colors: [
                                                                  AppColors()
                                                                      .maincolor
                                                                ],
                                                                indicatorType:
                                                                    Indicator
                                                                        .ballRotateChase,
                                                              ),
                                                            ),
                                                          )
                                                        : IconButton(
                                                            onPressed: () {
                                                              deletesite(docid);
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .delete_outline,
                                                              color: AppColors()
                                                                  .maincolor,
                                                            ))
                                                  ],
                                                )
                                              ]),
                                        ]),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        sectorview == true &&
                                                selectedIndex == index
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: Table(
                                                  defaultVerticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  columnWidths: {
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
                                                    TableRow(children: [
                                                      Text(
                                                        'Sector In Sys',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Sectid',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Height Of Tower',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Height Of Building',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Height Of Antena',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Azmuth',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Mechanic Tilt',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'ELectical Tilt',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Tilt',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Lat',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Lon',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Options',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ])
                                                  ],
                                                ),
                                              )
                                            : SizedBox(),
                                        sectorview == true &&
                                                selectedIndex == index
                                            ? Divider()
                                            : SizedBox(),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        sectorview == true &&
                                                selectedIndex == index
                                            ? Table(
                                                children: [
                                                  TableRow(children: [
                                                    StreamBuilder(
                                                        stream:
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'LTE')
                                                                .doc(docid)
                                                                .collection(
                                                                    'Sectors')
                                                                .snapshots(),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<
                                                                    QuerySnapshot>
                                                                snapshot) {
                                                          if (snapshot
                                                                  .hasData &&
                                                              snapshot
                                                                  .data!
                                                                  .docs
                                                                  .isEmpty) {
                                                            return Column(
                                                              children: [
                                                                Text(
                                                                  'there is no Sectors registered!',
                                                                  style: TextStyle(
                                                                      color: AppColors()
                                                                          .black),
                                                                ),
                                                                SizedBox(
                                                                  height: 30,
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                          if (snapshot
                                                              .hasError) {
                                                            print(
                                                                'there is error');
                                                          }
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return Center(
                                                                child: SizedBox(
                                                              width: 50,
                                                              height: 50,
                                                              child: LoadingIndicator(
                                                                  strokeWidth:
                                                                      3,
                                                                  colors: [
                                                                    AppColors()
                                                                        .secondcolor
                                                                  ],
                                                                  indicatorType:
                                                                      Indicator
                                                                          .ballRotateChase),
                                                            ));
                                                          }
                                                          if (snapshot
                                                              .hasData) {
                                                            return ListView
                                                                .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: snapshot
                                                                        .data!
                                                                        .docs
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      var isapproved = snapshot
                                                                          .data!
                                                                          .docs[index]['IsectorApproved'];
                                                                      var sectorId = snapshot
                                                                          .data!
                                                                          .docs[index]['SectorId'];
                                                                      var sectorname = snapshot
                                                                          .data!
                                                                          .docs[index]['SectorName'];
                                                                      var sectid = snapshot
                                                                          .data!
                                                                          .docs[index]['sectid'];
                                                                      var heightOfTower = snapshot
                                                                          .data!
                                                                          .docs[index]['heightOfTower'];
                                                                      var heightofBuildings = snapshot
                                                                          .data!
                                                                          .docs[index]['heightOfBuilding'];
                                                                      var heightofantenas = snapshot
                                                                          .data!
                                                                          .docs[index]['heightOfAntena'];
                                                                      var mechanicalTilts = snapshot
                                                                          .data!
                                                                          .docs[index]['mechanicTilt'];
                                                                      var electicalTilts = snapshot
                                                                          .data!
                                                                          .docs[index]['electicalTilt'];
                                                                  
                                                                      var azmuths = snapshot
                                                                          .data!
                                                                          .docs[index]['Azmuth'];
                                                                      var tilts = snapshot
                                                                          .data!
                                                                          .docs[index]['Tilt'];
                                                                      var latt = snapshot
                                                                          .data!
                                                                          .docs[index]['Lat'];
                                                                      var longitude = snapshot
                                                                          .data!
                                                                          .docs[index]['Long'];
                                                                      return Column(
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 10),
                                                                            child:
                                                                                Table(
                                                                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                                                                                        color: issitedelete == true
                                                                                            ? Colors.grey.withOpacity(0.4)
                                                                                            : snapshot.data!.docs[index]['IsectorApproved'] == 'Pending'
                                                                                                ? Colors.yellowAccent.withAlpha(180)
                                                                                                : AppColors().fifthcolor,
                                                                                        borderRadius: BorderRadius.circular(7),
                                                                                        boxShadow: [
                                                                                          BoxShadow(blurRadius: 8, offset: Offset(3, 4), spreadRadius: 5, color: AppColors().black.withOpacity(0.08))
                                                                                        ]),
                                                                                    children: [
                                                                                      SelectableText(
                                                                                        '${snapshot.data!.docs[index]['SectorName']}',
                                                                                        style: TextStyle(color: AppColors().black),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SelectableText(
                                                                                        '${snapshot.data!.docs[index]['sectid']}',
                                                                                        style: TextStyle(color: AppColors().black),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SelectableText(
                                                                                        '${snapshot.data!.docs[index]['heightOfTower']}',
                                                                                        style: TextStyle(color: AppColors().black),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SelectableText(
                                                                                        '${snapshot.data!.docs[index]['heightOfBuilding']}',
                                                                                        style: TextStyle(color: AppColors().black),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SelectableText(
                                                                                        '${snapshot.data!.docs[index]['heightOfAntena']}',
                                                                                        style: TextStyle(color: AppColors().black),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SelectableText(
                                                                                        '${snapshot.data!.docs[index]['Azmuth']}',
                                                                                        style: TextStyle(color: AppColors().black),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SelectableText(
                                                                                        '${snapshot.data!.docs[index]['mechanicTilt']}',
                                                                                        style: TextStyle(color: AppColors().black),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SelectableText(
                                                                                        '${snapshot.data!.docs[index]['electicalTilt']}',
                                                                                        style: TextStyle(color: AppColors().black),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SelectableText(
                                                                                        '${snapshot.data!.docs[index]['Tilt']}',
                                                                                        style: TextStyle(color: AppColors().black),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SelectableText(
                                                                                        '${snapshot.data!.docs[index]['Lat']}',
                                                                                        style: TextStyle(color: AppColors().black),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SelectableText(
                                                                                        '${snapshot.data!.docs[index]['Long']}',
                                                                                        style: TextStyle(color: AppColors().black),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      issitedelete == true
                                                                                          ? const SizedBox()
                                                                                          : snapshot.data!.docs[index]['IsectorApproved'] == 'Pending'
                                                                                              ? Padding(
                                                                                                  padding: const EdgeInsets.only(top: 5),
                                                                                                  child: Container(
                                                                                                    width: 35,
                                                                                                    height: 35,
                                                                                                    child: LoadingIndicator(
                                                                                                      colors: [AppColors().maincolor],
                                                                                                      indicatorType: Indicator.ballRotateChase,
                                                                                                    ),
                                                                                                  ),
                                                                                                )
                                                                                              : IconButton(
                                                                                                  onPressed: () {
                                                                                                   // showDataOptions(sectorId, docid, index, sectorname, sectid, heightOfTower, heightofBuildings, heightofantenas, mechanicalTilts, electicalTilts, azmuths, tilts, latt, longitude);
                                                                                                  },
                                                                                                  icon: Icon(
                                                                                                    Icons.more_horiz,
                                                                                                    color: AppColors().secondcolor,
                                                                                                  ))
                                                                                    ]),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    });
                                                          }
                                                          return Center(
                                                              child:
                                                                  CircularProgressIndicator());
                                                        }),
                                                  ]),
                                                ],
                                              )
                                            : SizedBox(),
                                      ],
                                    ),
                                  );
                                }));
                          }

                          return Center(child: CircularProgressIndicator());
                        }),
                    SizedBox(
                      height: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        if (check == false) {
                          setState(() {
                            check = true;
                          });
                        }
                      },
                      backgroundColor: AppColors().secondcolor,
                      child: Icon(
                        Icons.add,
                        color: AppColors().fifthcolor,
                      ),
                    )
                  ],
                ),
              )),
        )
      ]),
      Positioned(
          top: 25,
          right: 0,
          child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
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
    ]);
  }

  void deleteSector(docid, sectorid) {
    try {
      userbox.get('UserRole') == 'user'
          ? FirebaseFirestore.instance
              .collection('LTE')
              .doc(docid)
              .collection('Sectors')
              .doc(sectorid)
              .update({'IsectorApproved': 'Pending'})
          : FirebaseFirestore.instance
              .collection('LTE')
              .doc(docid)
              .collection('Sectors')
              .doc(sectorid)
              .delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors().thirdcolor,
          content: Text(e.toString(),
              style: TextStyle(
                color: AppColors().fifthcolor,
              ))));
    }
  }

  void showDataOptions(
      sectorID,
      docid,
      index,
      sname,
      sectids,
      heightOfTowers,
      heightOfBuildings,
      heightOfAntenaes,
      mechanicTiltes,
      electicalTilts,
      
      azmuths,
      tilts,
      lats,
      longs) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                MaterialButton(
                  shape: StadiumBorder(),
                  minWidth: 150,
                  color: AppColors().secondcolor,
                  onPressed: () {
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(30),
                            child: AlertDialog(
                              content: Builder(builder: (context) {
                                return Container(
                                  height: 400,
                                  width:
                                      MediaQuery.of(context).size.width - 194,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                     Table(
                                                  defaultVerticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  columnWidths: {
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
                                                    
                                                  },
                                                  children: [
                                                    TableRow(children: [
                                                      Text(
                                                        'Sector In Sys',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Sectid',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Height Of Tower',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Height Of Building',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Height Of Antena',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Azmuth',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Mechanic Tilt',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'ELectical Tilt',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Tilt',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Lat',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Lon',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      ])]),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Divider(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Table(
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
                                                    
                                        },
                                        children: [
                                          TableRow(children: [
                                            SiteTextfield(
                                              hinText: sname,
                                              controller: sectorName,
                                            ),
                                            SiteTextfield(
                                              controller: sectid,
                                              hinText: sectids,
                                            ),
                                            SiteTextfield(
                                              controller: heightOfTower,
                                              hinText: heightOfTowers,
                                            ),
                                            SiteTextfield(
                                              controller: heightOfBuilding,
                                              hinText: heightOfBuildings,
                                            ),
                                            SiteTextfield(
                                              controller: heightOfAntena,
                                              hinText: heightOfAntenaes,
                                            ),
                                            SiteTextfield(
                                              controller: mechanicTilt,
                                              hinText: mechanicTiltes,
                                            ),
                                            SiteTextfield(
                                              controller: electicalTilt,
                                              hinText: electicalTilts,
                                            ),
                                            SiteTextfield(
                                              controller: azmuth,
                                              hinText: azmuths,
                                            ),
                                            SiteTextfield(
                                              controller: tilt,
                                              hinText: tilts,
                                            ),
                                            SiteTextfield(
                                              controller: lat,
                                              hinText: lats,
                                            ),
                                            SiteTextfield(
                                              controller: lon,
                                              hinText: longs,
                                            ),
                                          ])
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          MaterialButton(
                                            shape: StadiumBorder(),
                                            minWidth: 150,
                                            color: AppColors().maincolor,
                                            onPressed: () {
                                              if (sectorName.text.isNotEmpty) {
                                                try {
                                                  FirebaseFirestore.instance
                                                      .collection('LTE')
                                                      .doc(docid)
                                                      .collection('Sectors')
                                                      .doc(sectorID)
                                                      .update({
                                                    'SectorName':
                                                        sectorName.text,
                                                    'sectid': sectid.text,
                                                    'heightOfTower':
                                                        heightOfTower.text,
                                                    'heightOfBuilding':
                                                        heightOfBuilding.text,
                                                    'heightOfAntena':
                                                        heightOfAntena.text,
                                                    'mechanicTilt':
                                                        mechanicTilt.text,
                                                    'electicalTilt':
                                                        electicalTilt.text,
                                                    'Azmuth': azmuth.text,
                                                    'Tilt': tilt.text,
                                                    'Lat': lat.text,
                                                    'Long': lon.text
                                                  });
                                                  Navigator.of(context).pop();
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          backgroundColor:
                                                              AppColors()
                                                                  .thirdcolor,
                                                          content: Text(
                                                              e.toString(),
                                                              style: TextStyle(
                                                                color: AppColors()
                                                                    .fifthcolor,
                                                              ))));
                                                }
                                              }
                                            },
                                            child: Text(
                                              'Save',
                                              style: TextStyle(
                                                  color:
                                                      AppColors().fifthcolor),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          MaterialButton(
                                            shape: StadiumBorder(),
                                            minWidth: 150,
                                            color: AppColors().secondcolor,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color:
                                                      AppColors().fifthcolor),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ),
                          );
                        });
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(color: AppColors().fifthcolor),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                MaterialButton(
                  shape: StadiumBorder(),
                  minWidth: 150,
                  color: AppColors().maincolor,
                  onPressed: () {
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(30),
                            child: AlertDialog(
                              content: Builder(builder: (context) {
                                return Container(
                                    height: 150,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Do you really want to delete this sector?',
                                            style: TextStyle(
                                                color: AppColors().black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 35,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              MaterialButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                minWidth: 150,
                                                color: AppColors().secondcolor,
                                                shape: StadiumBorder(),
                                                child: Text(
                                                  'NO',
                                                  style: TextStyle(
                                                      color: AppColors()
                                                          .fifthcolor),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              MaterialButton(
                                                onPressed: () {
                                                  deleteSector(docid, sectorID);
                                                },
                                                minWidth: 150,
                                                color: AppColors().maincolor,
                                                shape: StadiumBorder(),
                                                child: Text(
                                                  'yES',
                                                  style: TextStyle(
                                                      color: AppColors()
                                                          .fifthcolor),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ));
                              }),
                            ),
                          );
                        });
                    //confirmSectorDeletion(docid, sectorID);
                    // Navigator.of(context).pop();
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: AppColors().fifthcolor),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void sectorfield(
    docid,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(30),
            child: AlertDialog(
              content: Builder(builder: (context) {
                return Container(
                  height: 400,
                  width: MediaQuery.of(context).size.width - 194,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Table(
                                                  defaultVerticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  columnWidths: {
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
                                                    
                                                  },
                                                  children: [
                                                    TableRow(children: [
                                                      Text(
                                                        'Sector In Sys',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Sectid',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Height Of Tower',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Height Of Building',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Height Of Antena',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Azmuth',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Mechanic Tilt',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'ELectical Tilt',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Tilt',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Lat',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Lon',
                                                        textAlign:
                                                            TextAlign.center,
                                                      )
                                                      ,])]),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      Table(
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
                                                   
                        },
                        children: [
                          TableRow(children: [
                            SiteTextfield(controller: sectorName),
                            SiteTextfield(controller: sectid),
                            SiteTextfield(controller: heightOfTower),
                            SiteTextfield(controller: heightOfBuilding),
                            SiteTextfield(controller: heightOfAntena),
                            SiteTextfield(controller: mechanicTilt),
                            SiteTextfield(controller: electicalTilt),
                            SiteTextfield(controller: azmuth),
                            SiteTextfield(controller: tilt),
                            SiteTextfield(controller: lat),
                            SiteTextfield(controller: lon),
                          ])
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            shape: StadiumBorder(),
                            minWidth: 150,
                            color: AppColors().maincolor,
                            onPressed: () {
                              if (sectorName.text.isNotEmpty) {
                                try {
                                  var sectorId = FirebaseFirestore.instance
                                      .collection('LTE')
                                      .doc(docid)
                                      .collection('Sectors')
                                      .doc()
                                      .id;
                                  FirebaseFirestore.instance
                                      .collection('LTE')
                                      .doc(docid)
                                      .collection('Sectors')
                                      .doc(sectorId)
                                      .set({
                                    'IsectorApproved': 'notrequested',
                                    'SectorId': sectorId,
                                    'SectorName': sectorName.text,
                                    'sectid': sectid.text,
                                    'heightOfTower': heightOfTower.text,
                                    'heightOfBuilding': heightOfBuilding.text,
                                    'heightOfAntena': heightOfAntena.text,
                                    'mechanicTilt': mechanicTilt.text,
                                    'electicalTilt': electicalTilt.text,
                                    'Azmuth': azmuth.text,
                                    'Tilt': tilt.text,
                                    'Lat': lat.text,
                                    'Long': lon.text
                                  });
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor:
                                              AppColors().thirdcolor,
                                          content: Text(e.toString(),
                                              style: TextStyle(
                                                color: AppColors().fifthcolor,
                                              ))));
                                }
                              }
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(color: AppColors().fifthcolor),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          MaterialButton(
                            shape: StadiumBorder(),
                            minWidth: 150,
                            color: AppColors().secondcolor,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: AppColors().fifthcolor),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
            ),
          );
        });
  }

  void updatevariable(index) {
    if (isupdating == false) {
      setState(() {
        isupdating = true;
        selectedIndex = index;
      });
    } else {
      setState(() {
        isupdating = false;
      });
    }
  }

  void updateSectorview(index) {
    if (sectorview == false) {
      setState(() {
        sectorview = true;
        selectedIndex = index;
      });
    } else {
      setState(() {
        sectorview = false;
        print(index.toString());
      });
    }
  }

  void updatesite(documentId) {
    if (regioncontroller.text.isNotEmpty && siteName.text.isNotEmpty) {
      try {
        FirebaseFirestore.instance.collection('LTE').doc(documentId).update(
            {'Region': regioncontroller.text, 'SiteName': siteName.text});
        setState(() {
          isupdating = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors().thirdcolor,
            content: Text(e.toString(),
                style: TextStyle(
                  color: AppColors().fifthcolor,
                ))));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors().thirdcolor,
          content: Text("These fields can't be empty!, please fill them",
              style: TextStyle(
                color: AppColors().fifthcolor,
              ))));
    }
  }

  void confirmSectorDeletion(String documentId, sectorid) {
    showDialog(
        context: context,
        builder: (context) {
          return Text('hello');
        });
  }

  void deletesite(String documentId) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      desc: 'Do you really want to delete this Site?',
      btnOk: MaterialButton(
        color: AppColors().maincolor,
        onPressed: () {
          try {
            userbox.get('UserRole') == 'user'
                ? FirebaseFirestore.instance
                    .collection('LTE')
                    .doc(documentId)
                    .update({'Isapproved': 'Pending'})
                : FirebaseFirestore.instance
                    .collection('LTE')
                    .doc(documentId)
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

  void saveSite() async {
    try {
      if (regioncontroller.text.isNotEmpty && siteName.text.isNotEmpty) {
        var doc = FirebaseFirestore.instance.collection('LTE').doc().id;

        FirebaseFirestore.instance.collection('LTE').doc(doc).set({
          'Region': regioncontroller.text,
          'SiteName': siteName.text,
          'DocId': doc,
          'Isapproved': 'notRequested'
        });
        regioncontroller.clear();
        siteName.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors().thirdcolor,
            content: Text("These fields can't be empty!, please fill them",
                style: TextStyle(
                  color: AppColors().fifthcolor,
                ))));
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors().thirdcolor,
          content: Text(e.toString(),
              style: TextStyle(
                color: AppColors().fifthcolor,
              ))));
      regioncontroller.clear();
      siteName.clear();
    }
  }
}
