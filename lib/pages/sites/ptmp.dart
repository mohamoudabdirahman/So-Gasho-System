import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/utils/siteTexfield.dart';

class Ptmp extends StatefulWidget {
  Ptmp({super.key});

  @override
  State<Ptmp> createState() => _PtmpState();
}

class _PtmpState extends State<Ptmp> {
  final regioncontroller = TextEditingController();
  final siteName = TextEditingController();
  final sectorName = TextEditingController();
  final ssid = TextEditingController();
  final band = TextEditingController();
  final rocketName = TextEditingController();
  final ipaddress = TextEditingController();
  final macaddress = TextEditingController();
  final portNumber = TextEditingController();
  final wirelessmode = TextEditingController();
  final vlan = TextEditingController();
  final servingmikrotic = TextEditingController();
  final height = TextEditingController();
  final azmuth = TextEditingController();
  final tilt = TextEditingController();
  final lat = TextEditingController();
  final lon = TextEditingController();
  final scrollcontroller = ScrollController();
  var check = false;
  var cancelling = true;
  var isupdating = false;
  var sectorview = false;
  var sectorfieldvisibilty = false;
  int? selectedIndex;
  var userbox = Hive.box('Role');
  var stream;
  var sectorStream;

  var searchedName = '';

  bool searchbuttontapped = false;

  bool issitedelete = false;

  final controller = TextEditingController();

  @override
  void initState() {
    stream = FirebaseFirestore.instance.collection('SiteData').snapshots();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    regioncontroller.dispose();
    siteName.dispose();
    sectorName.dispose();
    ssid.dispose();
    band.dispose();
    rocketName.dispose();
    ipaddress.dispose();
    macaddress.dispose();
    portNumber.dispose();
    wirelessmode.dispose();
    vlan.dispose();
    servingmikrotic.dispose();
    height.dispose();
    azmuth.dispose();
    tilt.dispose();
    lat.dispose();
    lon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            height: 800,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Container(
                  width: MediaQuery.of(context).size.width - 196,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                searchbuttontapped
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                400,
                                        child: SiteTextfield(
                                            hinText:
                                                'You can search any PTMP site here! (by Site Name)',
                                            controller: controller,
                                            onchange: (value) {
                                              searchedName = value;
                                              setState(() {
                                                searchedName = controller.text;
                                              });
                                            }))
                                    : SizedBox(),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (searchbuttontapped == false) {
                                          searchbuttontapped = true;
                                        } else {
                                          searchbuttontapped = false;
                                        }
                                      });
                                    },
                                    icon: Icon(
                                        searchbuttontapped
                                            ? Icons.close
                                            : Icons.search,
                                        color: AppColors().secondcolor)),
                              ],
                            ),
                          ),
                        ),
                        Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
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
                            stream: stream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data!.docs.isEmpty) {
                                return Column(
                                  children: [
                                    Text(
                                      'there is no sites registered!',
                                      style:
                                          TextStyle(color: AppColors().black),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                );
                              }

                              if (snapshot.hasData) {
                                return SizedBox(
                                  height: 500,
                                  child: Scrollbar(
                                    controller: scrollcontroller,
                                    child: searchbuttontapped
                                        ? ListView.builder(
                                            controller: scrollcontroller,
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            itemBuilder: ((context, index) {
                                              var sitename = snapshot.data!
                                                  .docs[index]['SiteName'];
                                              var regions = snapshot
                                                  .data!.docs[index]['Region'];
                                              var parentCollectionID = snapshot
                                                  .data!.docs[index]['DocId'];

                                              var sitedeleted = snapshot.data
                                                  ?.docs[index]['Isapproved'];
                                              var data = snapshot
                                                      .data?.docs[index]
                                                      .data()
                                                  as Map<String, dynamic>;

                                              if (data['SiteName']
                                                  .toString()
                                                  .toLowerCase()
                                                  .startsWith(searchedName
                                                      .toLowerCase())) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8),
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
                                                                      .circular(
                                                                          7),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    blurRadius:
                                                                        8,
                                                                    offset:
                                                                        Offset(
                                                                            3,
                                                                            4),
                                                                    spreadRadius:
                                                                        5,
                                                                    color: AppColors()
                                                                        .black
                                                                        .withOpacity(
                                                                            0.08))
                                                              ]),
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
                                                              child: isupdating ==
                                                                          true &&
                                                                      selectedIndex ==
                                                                          index
                                                                  ? SiteTextfield(
                                                                      hinText: snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                          [
                                                                          'Region'],
                                                                      controller:
                                                                          regioncontroller)
                                                                  : SelectableText(
                                                                      '${snapshot.data!.docs[index]['Region']}',
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
                                                                    ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: isupdating ==
                                                                          true &&
                                                                      selectedIndex ==
                                                                          index
                                                                  ? SiteTextfield(
                                                                      hinText: snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                          [
                                                                          'SiteName'],
                                                                      controller:
                                                                          siteName)
                                                                  : SelectableText(
                                                                      '${snapshot.data!.docs[index]['SiteName']}',
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black)),
                                                            ),
                                                            IconButton(
                                                                onPressed: () {
                                                                  isupdating ==
                                                                              true &&
                                                                          selectedIndex ==
                                                                              index
                                                                      ? updatesite(
                                                                          parentCollectionID,
                                                                          sitename,
                                                                          regions)
                                                                      : showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (contex) {
                                                                            return AlertDialog(
                                                                              backgroundColor: AppColors().fifthcolor,
                                                                              content: Column(children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                                  children: [
                                                                                    Container(
                                                                                      decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(10), color: AppColors().maincolor),
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(2.0),
                                                                                        child: Center(
                                                                                          child: IconButton(
                                                                                              onPressed: () {
                                                                                                Navigator.of(context).pop();
                                                                                              },
                                                                                              icon: Icon(
                                                                                                Icons.close,
                                                                                                color: AppColors().fifthcolor,
                                                                                                size: 30,
                                                                                              )),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 20,
                                                                                ),
                                                                                Table(
                                                                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                                                                                    15: FlexColumnWidth(0.5),
                                                                                  },
                                                                                  children: const [
                                                                                    TableRow(children: [
                                                                                      Text(
                                                                                        'Sector Name',
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      Text(
                                                                                        'Ssid',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                      Text(
                                                                                        'Band',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                      Text(
                                                                                        'Rocket Name',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                      Text(
                                                                                        'Ip address',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                      Text(
                                                                                        'Mac address',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                      Text(
                                                                                        'Port Number',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                      Text(
                                                                                        'Wireless mode',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                      Text(
                                                                                        'Vlan',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                      Text(
                                                                                        'Serving Mikrotic',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                      Text(
                                                                                        'Height',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                      Text(
                                                                                        'Azmuth',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                      Text(
                                                                                        'Tilt',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                      Text(
                                                                                        'Lat',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                      Text(
                                                                                        'Lon',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                      Text(
                                                                                        'OP',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                    ])
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 20,
                                                                                ),
                                                                                Expanded(
                                                                                  child: Container(
                                                                                    width: MediaQuery.of(contex).size.width - 196,
                                                                                    height: 1000,
                                                                                    child: StreamBuilder(
                                                                                      stream: FirebaseFirestore.instance.collection('SiteData').doc(data['DocId']).collection('Sectors').snapshots(),
                                                                                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                                                        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                                                                                          return Center(
                                                                                            child: Text('There is no Sectors on this site!'),
                                                                                          );
                                                                                        }
                                                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                          return Center(
                                                                                            child: CircularProgressIndicator(),
                                                                                          );
                                                                                        }
                                                                                        if (snapshot.hasData) {
                                                                                          return ListView.builder(
                                                                                              itemCount: snapshot.data!.docs.length,
                                                                                              shrinkWrap: true,
                                                                                              itemBuilder: (context, index) {
                                                                                                if (data['Isapproved'] == 'Pending') {
                                                                                                  issitedelete = true;
                                                                                                } else if (data['Isapproved'] == 'notrequested') {
                                                                                                  issitedelete = false;
                                                                                                }

                                                                                                var sectorId = snapshot.data!.docs[index]['SectorId'];
                                                                                                var sectorname = snapshot.data!.docs[index]['SectorName'];
                                                                                                var ssid = snapshot.data!.docs[index]['Ssid'];
                                                                                                var band = snapshot.data!.docs[index]['Band'];
                                                                                                var rName = snapshot.data!.docs[index]['RocketName'];
                                                                                                var ipadd = snapshot.data!.docs[index]['IpAddress'];
                                                                                                var macadd = snapshot.data!.docs[index]['MacAddress'];
                                                                                                var pNumber = snapshot.data!.docs[index]['PortNumber'];
                                                                                                var wMode = snapshot.data!.docs[index]['WirelessMode'];
                                                                                                var vlans = snapshot.data!.docs[index]['Vlan'];
                                                                                                var sMikrotic = snapshot.data!.docs[index]['ServingMikrotic'];
                                                                                                var heights = snapshot.data!.docs[index]['Height'];
                                                                                                var azmuths = snapshot.data!.docs[index]['Azmuth'];
                                                                                                var tilts = snapshot.data!.docs[index]['Tilt'];
                                                                                                var latt = snapshot.data!.docs[index]['Lat'];
                                                                                                var longitude = snapshot.data!.docs[index]['Long'];

                                                                                                return Table(defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                                                                                                    }, children: [
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
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                        SelectableText(
                                                                                                          '${snapshot.data!.docs[index]['Ssid']}',
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                        SelectableText(
                                                                                                          '${snapshot.data!.docs[index]['Band']}',
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                        SelectableText(
                                                                                                          '${snapshot.data!.docs[index]['RocketName']}',
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                        SelectableText(
                                                                                                          '${snapshot.data!.docs[index]['IpAddress']}',
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                        SelectableText(
                                                                                                          '${snapshot.data!.docs[index]['MacAddress']}',
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                        SelectableText(
                                                                                                          '${snapshot.data!.docs[index]['PortNumber']}',
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                        SelectableText(
                                                                                                          '${snapshot.data!.docs[index]['WirelessMode']}',
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                        SelectableText(
                                                                                                          '${snapshot.data!.docs[index]['Vlan']}',
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                        SelectableText(
                                                                                                          '${snapshot.data!.docs[index]['ServingMikrotic']}',
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                        SelectableText(
                                                                                                          '${snapshot.data!.docs[index]['Height']}',
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                        SelectableText(
                                                                                                          '${snapshot.data!.docs[index]['Azmuth']}',
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                        SelectableText(
                                                                                                          '${snapshot.data!.docs[index]['Tilt']}',
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                        SelectableText(
                                                                                                          '${snapshot.data!.docs[index]['Lat']}',
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                        SelectableText(
                                                                                                          '${snapshot.data!.docs[index]['Long']}',
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                        sitedeleted == 'Pending'
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
                                                                                                                      showDataOptions(sectorId, parentCollectionID, index, sectorname, ssid, band, rName, ipadd, macadd, pNumber, wMode, vlans, sMikrotic, heights, azmuths, tilts, latt, longitude);
                                                                                                                    },
                                                                                                                    icon: Icon(
                                                                                                                      Icons.more_horiz,
                                                                                                                      color: AppColors().secondcolor,
                                                                                                                    ))
                                                                                                      ])
                                                                                                ]);
                                                                                              });
                                                                                        }
                                                                                        return CircularProgressIndicator();
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ]),
                                                                            );
                                                                          });
                                                                },
                                                                icon: Icon(
                                                                  isupdating ==
                                                                              true &&
                                                                          selectedIndex ==
                                                                              index
                                                                      ? Icons
                                                                          .check
                                                                      : Icons
                                                                          .expand_circle_down_rounded,
                                                                  color: AppColors()
                                                                      .secondcolor,
                                                                )),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                snapshot.data!.docs[index]
                                                                            [
                                                                            'Isapproved'] ==
                                                                        'Pending'
                                                                    ? SizedBox()
                                                                    : IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          updatevariable(
                                                                              index);
                                                                        },
                                                                        icon:
                                                                            Icon(
                                                                          isupdating == true && selectedIndex == index
                                                                              ? Icons.close_outlined
                                                                              : Icons.edit_note_outlined,
                                                                          color:
                                                                              AppColors().secondcolor,
                                                                        )),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                snapshot.data!.docs[index]
                                                                            [
                                                                            'Isapproved'] ==
                                                                        'Pending'
                                                                    ? Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 5),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              35,
                                                                          height:
                                                                              35,
                                                                          child:
                                                                              LoadingIndicator(
                                                                            colors: [
                                                                              AppColors().maincolor
                                                                            ],
                                                                            indicatorType:
                                                                                Indicator.ballRotateChase,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          deletesite(
                                                                              parentCollectionID);
                                                                        },
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .delete_outline,
                                                                          color:
                                                                              AppColors().maincolor,
                                                                        ))
                                                              ],
                                                            )
                                                          ]),
                                                    ],
                                                  ),
                                                );
                                              }
                                              return Container();
                                            }))
                                        : ListView.builder(
                                            controller: scrollcontroller,
                                            //shrinkWrap: true,
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            itemBuilder: ((context, index) {
                                              var sitename = snapshot.data!
                                                  .docs[index]['SiteName'];
                                              var regions = snapshot
                                                  .data!.docs[index]['Region'];
                                              var parentCollectionID = snapshot
                                                  .data!.docs[index]['DocId'];

                                              var sitedeleted = snapshot.data
                                                  ?.docs[index]['Isapproved'];

                                              return Column(
                                                children: [
                                                  Table(children: [
                                                    TableRow(
                                                        decoration: BoxDecoration(
                                                            color: snapshot.data!
                                                                            .docs[index]
                                                                        [
                                                                        'Isapproved'] ==
                                                                    'Pending'
                                                                ? Colors
                                                                    .yellowAccent
                                                                    .withAlpha(
                                                                        180)
                                                                : AppColors()
                                                                    .fifthcolor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  blurRadius: 8,
                                                                  offset:
                                                                      Offset(
                                                                          3, 4),
                                                                  spreadRadius:
                                                                      5,
                                                                  color: AppColors()
                                                                      .black
                                                                      .withOpacity(
                                                                          0.1))
                                                            ]),
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: isupdating ==
                                                                        true &&
                                                                    selectedIndex ==
                                                                        index
                                                                ? SiteTextfield(
                                                                    hinText: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        'Region'],
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
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10),
                                                            child: isupdating ==
                                                                        true &&
                                                                    selectedIndex ==
                                                                        index
                                                                ? SiteTextfield(
                                                                    hinText: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        'SiteName'],
                                                                    controller:
                                                                        siteName)
                                                                : SelectableText(
                                                                    '${snapshot.data!.docs[index]['SiteName']}',
                                                                    style: TextStyle(
                                                                        color: AppColors()
                                                                            .black)),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    isupdating ==
                                                                                true &&
                                                                            selectedIndex ==
                                                                                index
                                                                        ? updatesite(
                                                                            parentCollectionID,
                                                                            sitename,
                                                                            regions)
                                                                        : updateSectorview(
                                                                            index);
                                                                  },
                                                                  icon: Icon(
                                                                    isupdating ==
                                                                                true &&
                                                                            selectedIndex ==
                                                                                index
                                                                        ? Icons
                                                                            .check_circle
                                                                        : Icons
                                                                            .expand_circle_down_rounded,
                                                                    color: AppColors()
                                                                        .secondcolor,
                                                                  )),
                                                              snapshot.data!.docs[
                                                                              index]
                                                                          [
                                                                          'Isapproved'] ==
                                                                      'Pending'
                                                                  ? SizedBox()
                                                                  : IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        sectorfield(
                                                                            snapshot.data!.docs[index]['DocId'],
                                                                            parentCollectionID);
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .add,
                                                                        color: AppColors()
                                                                            .secondcolor,
                                                                      )),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              snapshot.data!.docs[
                                                                              index]
                                                                          [
                                                                          'Isapproved'] ==
                                                                      'Pending'
                                                                  ? SizedBox()
                                                                  : IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        updatevariable(
                                                                            index);
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        isupdating == true &&
                                                                                selectedIndex == index
                                                                            ? Icons.close_outlined
                                                                            : Icons.edit_note_outlined,
                                                                        color: AppColors()
                                                                            .secondcolor,
                                                                      )),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              snapshot.data!.docs[
                                                                              index]
                                                                          [
                                                                          'Isapproved'] ==
                                                                      'Pending'
                                                                  ? Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              5),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            35,
                                                                        height:
                                                                            35,
                                                                        child:
                                                                            LoadingIndicator(
                                                                          colors: [
                                                                            AppColors().maincolor
                                                                          ],
                                                                          indicatorType:
                                                                              Indicator.ballRotateChase,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        deletesite(
                                                                            parentCollectionID);
                                                                      },
                                                                      icon:
                                                                          Icon(
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
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10),
                                                          child: Table(
                                                            defaultVerticalAlignment:
                                                                TableCellVerticalAlignment
                                                                    .middle,
                                                            columnWidths: const {
                                                              0: FlexColumnWidth(
                                                                  6),
                                                              1: FlexColumnWidth(
                                                                  5),
                                                              2: FlexColumnWidth(
                                                                  0.8),
                                                              3: FlexColumnWidth(
                                                                  1.8),
                                                              4: FlexColumnWidth(
                                                                  2.6),
                                                              5: FlexColumnWidth(
                                                                  2.8),
                                                              6: FlexColumnWidth(
                                                                  2),
                                                              7: FlexColumnWidth(
                                                                  3),
                                                              8: FlexColumnWidth(
                                                                  1),
                                                              9: FlexColumnWidth(
                                                                  3),
                                                              10: FlexColumnWidth(
                                                                  2),
                                                              11: FlexColumnWidth(
                                                                  2),
                                                              12: FlexColumnWidth(
                                                                  1),
                                                              13: FlexColumnWidth(
                                                                  2.8),
                                                              14: FlexColumnWidth(
                                                                  2.8),
                                                            },
                                                            children: [
                                                              TableRow(
                                                                  children: [
                                                                    Text(
                                                                      'Sector Name',
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                    Text(
                                                                      'Ssid',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
                                                                    ),
                                                                    Text(
                                                                      'Band',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
                                                                    ),
                                                                    Text(
                                                                      'Rocket Name',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
                                                                    ),
                                                                    Text(
                                                                      'Ip address',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
                                                                    ),
                                                                    Text(
                                                                      'Mac address',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
                                                                    ),
                                                                    Text(
                                                                      'Port Number',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
                                                                    ),
                                                                    Text(
                                                                      'Wireless mode',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
                                                                    ),
                                                                    Text(
                                                                      'Vlan',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
                                                                    ),
                                                                    Text(
                                                                      'Serving Mikrotic',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
                                                                    ),
                                                                    Text(
                                                                      'Height',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
                                                                    ),
                                                                    Text(
                                                                      'Azmuth',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
                                                                    ),
                                                                    Text(
                                                                      'Tilt',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
                                                                    ),
                                                                    Text(
                                                                      'Lat',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
                                                                    ),
                                                                    Text(
                                                                      'Lon',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
                                                                    ),
                                                                    Text(
                                                                      'OP',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
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
                                                                  stream: FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'SiteData')
                                                                      .doc(
                                                                          parentCollectionID)
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
                                                                            style:
                                                                                TextStyle(color: AppColors().black),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                30,
                                                                          ),
                                                                        ],
                                                                      );
                                                                    }
                                                                    if (snapshot
                                                                        .hasError) {
                                                                      return Center(
                                                                          child:
                                                                              Text('something went wrong!'));
                                                                    }
                                                                    if (snapshot
                                                                            .connectionState ==
                                                                        ConnectionState
                                                                            .waiting) {
                                                                      return Center(
                                                                          child:
                                                                              SizedBox(
                                                                        width:
                                                                            50,
                                                                        height:
                                                                            50,
                                                                        child: LoadingIndicator(
                                                                            strokeWidth:
                                                                                3,
                                                                            colors: [
                                                                              AppColors().secondcolor
                                                                            ],
                                                                            indicatorType:
                                                                                Indicator.ballRotateChase),
                                                                      ));
                                                                    }
                                                                    if (snapshot
                                                                        .hasData) {
                                                                      return ListView.builder(
                                                                          shrinkWrap: true,
                                                                          itemCount: snapshot.data!.docs.length,
                                                                          itemBuilder: (context, index) {
                                                                            var isapproved =
                                                                                snapshot.data!.docs[index]['IsectorApproved'];
                                                                            var sectorId =
                                                                                snapshot.data!.docs[index]['SectorId'];
                                                                            var sectorname =
                                                                                snapshot.data!.docs[index]['SectorName'];
                                                                            var ssid =
                                                                                snapshot.data!.docs[index]['Ssid'];
                                                                            var band =
                                                                                snapshot.data!.docs[index]['Band'];
                                                                            var rName =
                                                                                snapshot.data!.docs[index]['RocketName'];
                                                                            var ipadd =
                                                                                snapshot.data!.docs[index]['IpAddress'];
                                                                            var macadd =
                                                                                snapshot.data!.docs[index]['MacAddress'];
                                                                            var pNumber =
                                                                                snapshot.data!.docs[index]['PortNumber'];
                                                                            var wMode =
                                                                                snapshot.data!.docs[index]['WirelessMode'];
                                                                            var vlans =
                                                                                snapshot.data!.docs[index]['Vlan'];
                                                                            var sMikrotic =
                                                                                snapshot.data!.docs[index]['ServingMikrotic'];
                                                                            var heights =
                                                                                snapshot.data!.docs[index]['Height'];
                                                                            var azmuths =
                                                                                snapshot.data!.docs[index]['Azmuth'];
                                                                            var tilts =
                                                                                snapshot.data!.docs[index]['Tilt'];
                                                                            var latt =
                                                                                snapshot.data!.docs[index]['Lat'];
                                                                            var longitude =
                                                                                snapshot.data!.docs[index]['Long'];
                                                                            return Column(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 10),
                                                                                  child: Table(
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
                                                                                              color: sitedeleted == 'Pending'
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
                                                                                              '${snapshot.data!.docs[index]['Ssid']}',
                                                                                              style: TextStyle(color: AppColors().black),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                            SelectableText(
                                                                                              '${snapshot.data!.docs[index]['Band']}',
                                                                                              style: TextStyle(color: AppColors().black),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                            SelectableText(
                                                                                              '${snapshot.data!.docs[index]['RocketName']}',
                                                                                              style: TextStyle(color: AppColors().black),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                            SelectableText(
                                                                                              '${snapshot.data!.docs[index]['IpAddress']}',
                                                                                              style: TextStyle(color: AppColors().black),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                            SelectableText(
                                                                                              '${snapshot.data!.docs[index]['MacAddress']}',
                                                                                              style: TextStyle(color: AppColors().black),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                            SelectableText(
                                                                                              '${snapshot.data!.docs[index]['PortNumber']}',
                                                                                              style: TextStyle(color: AppColors().black),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                            SelectableText(
                                                                                              '${snapshot.data!.docs[index]['WirelessMode']}',
                                                                                              style: TextStyle(color: AppColors().black),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                            SelectableText(
                                                                                              '${snapshot.data!.docs[index]['Vlan']}',
                                                                                              style: TextStyle(color: AppColors().black),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                            SelectableText(
                                                                                              '${snapshot.data!.docs[index]['ServingMikrotic']}',
                                                                                              style: TextStyle(color: AppColors().black),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                            SelectableText(
                                                                                              '${snapshot.data!.docs[index]['Height']}',
                                                                                              style: TextStyle(color: AppColors().black),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                            SelectableText(
                                                                                              '${snapshot.data!.docs[index]['Azmuth']}',
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
                                                                                            sitedeleted == 'Pending'
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
                                                                                                          showDataOptions(sectorId, parentCollectionID, index, sectorname, ssid, band, rName, ipadd, macadd, pNumber, wMode, vlans, sMikrotic, heights, azmuths, tilts, latt, longitude);
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
                                                                            Container());
                                                                  }),
                                                            ]),
                                                          ],
                                                        )
                                                      : SizedBox(),
                                                ],
                                              );
                                            })),
                                  ),
                                );
                              }

                              return Center(child: CircularProgressIndicator());
                            }),
                        check == true
                            ? Table(
                                children: [
                                  TableRow(children: [
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
                                          padding:
                                              const EdgeInsets.only(top: 14),
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
                                                            ? AppColors()
                                                                .greycolor
                                                            : AppColors()
                                                                .secondcolor)),
                                            child: Text(
                                              cancelling ? 'Cancel' : 'Save',
                                            ),
                                          ),
                                        )),
                                    SizedBox()
                                  ])
                                ],
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 15,
                        ),
                        Visibility(
                          visible: searchbuttontapped == false ? true : false,
                          child: FloatingActionButton(
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
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          )
        ]),
      ),
    ]);
  }

  void deleteSector(docid, sectorid) {
    try {
      userbox.get('UserRole') == 'user'
          ? FirebaseFirestore.instance
              .collection('SiteData')
              .doc(docid)
              .collection('Sectors')
              .doc(sectorid)
              .update({'IsectorApproved': 'Pending'})
          : FirebaseFirestore.instance
              .collection('SiteData')
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
      ssids,
      bands,
      rocketnames,
      ipaddresses,
      macaddresses,
      portnumbers,
      wirelessmodes,
      vlans,
      servingmikrotics,
      heights,
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
                              backgroundColor: AppColors().fifthcolor,
                              content: Builder(builder: (context) {
                                return Container(
                                  height: 400,
                                  width:
                                      MediaQuery.of(context).size.width - 194,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Table(
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
                                        children: const [
                                          TableRow(children: [
                                            Text(
                                              'Sector Name',
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              'Ssid',
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              'Band',
                                              textAlign: TextAlign.start,
                                            ),
                                            Text(
                                              'Rocket Name',
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              'Ip address',
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              'Mac address',
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              'Port Number',
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              'Wireless mode',
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              'Vlan',
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              'Serving Mikrotic',
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              'Height',
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              'Azmuth',
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
                                          ])
                                        ],
                                      ),
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
                                          1: FlexColumnWidth(5),
                                          2: FlexColumnWidth(1.5),
                                          3: FlexColumnWidth(1.8),
                                          4: FlexColumnWidth(2.6),
                                          5: FlexColumnWidth(2.8),
                                          6: FlexColumnWidth(2),
                                          7: FlexColumnWidth(3),
                                          8: FlexColumnWidth(1.5),
                                          9: FlexColumnWidth(3),
                                          10: FlexColumnWidth(2),
                                          11: FlexColumnWidth(2),
                                          12: FlexColumnWidth(1.5),
                                          13: FlexColumnWidth(2.8),
                                          14: FlexColumnWidth(2.8),
                                        },
                                        children: [
                                          TableRow(children: [
                                            SiteTextfield(
                                              hinText: sname,
                                              controller: sectorName,
                                            ),
                                            SiteTextfield(
                                              controller: ssid,
                                              hinText: ssids,
                                            ),
                                            SiteTextfield(
                                              controller: band,
                                              hinText: bands,
                                            ),
                                            SiteTextfield(
                                              controller: rocketName,
                                              hinText: rocketnames,
                                            ),
                                            SiteTextfield(
                                              controller: ipaddress,
                                              hinText: ipaddresses,
                                            ),
                                            SiteTextfield(
                                              controller: macaddress,
                                              hinText: macaddresses,
                                            ),
                                            SiteTextfield(
                                              controller: portNumber,
                                              hinText: portnumbers,
                                            ),
                                            SiteTextfield(
                                              controller: wirelessmode,
                                              hinText: wirelessmodes,
                                            ),
                                            SiteTextfield(
                                              controller: vlan,
                                              hinText: vlans,
                                            ),
                                            SiteTextfield(
                                              controller: servingmikrotic,
                                              hinText: servingmikrotics,
                                            ),
                                            SiteTextfield(
                                              controller: height,
                                              hinText: heights,
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
                                                      .collection('SiteData')
                                                      .doc(docid)
                                                      .collection('Sectors')
                                                      .doc(sectorID)
                                                      .update({
                                                    'SectorName':
                                                        sectorName.text.isEmpty
                                                            ? sname
                                                            : sectorName.text,
                                                    'Ssid': ssid.text.isEmpty
                                                        ? ssids
                                                        : ssid.text,
                                                    'Band': band.text.isEmpty
                                                        ? bands
                                                        : band.text,
                                                    'RocketName':
                                                        rocketName.text.isEmpty
                                                            ? rocketnames
                                                            : rocketName.text,
                                                    'IpAddress':
                                                        ipaddress.text.isEmpty
                                                            ? ipaddresses
                                                            : ipaddress.text,
                                                    'MacAddress':
                                                        macaddress.text.isEmpty
                                                            ? macaddresses
                                                            : macaddress.text,
                                                    'PortNumber':
                                                        portNumber.text.isEmpty
                                                            ? portnumbers
                                                            : portNumber.text,
                                                    'WirelessMode': wirelessmode
                                                            .text.isEmpty
                                                        ? wirelessmodes
                                                        : wirelessmode.text,
                                                    'Vlan': vlan.text.isEmpty
                                                        ? vlans
                                                        : vlan.text,
                                                    'ServingMikrotic':
                                                        servingmikrotic
                                                                .text.isEmpty
                                                            ? servingmikrotics
                                                            : servingmikrotic
                                                                .text,
                                                    'Height':
                                                        height.text.isEmpty
                                                            ? heights
                                                            : height.text,
                                                    'Azmuth':
                                                        azmuth.text.isEmpty
                                                            ? azmuths
                                                            : azmuth.text,
                                                    'Tilt': tilt.text.isEmpty
                                                        ? tilts
                                                        : tilt.text,
                                                    'Lat': lat.text.isEmpty
                                                        ? lats
                                                        : lat.text,
                                                    'Long': lon.text.isEmpty
                                                        ? longs
                                                        : lon.text
                                                  });
                                                  Navigator.of(context).pop();
                                                  sectorName.clear();
                                                  ssid.clear();
                                                  band.clear();
                                                  rocketName.clear();
                                                  ipaddress.clear();
                                                  macaddress.clear();
                                                  portNumber.clear();
                                                  wirelessmode.clear();
                                                  vlan.clear();
                                                  servingmikrotic.clear();
                                                  height.clear();
                                                  azmuth.clear();
                                                  tilt.clear();
                                                  lat.clear();
                                                  lon.clear();
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
                                                  sectorName.clear();
                                                  ssid.clear();
                                                  band.clear();
                                                  rocketName.clear();
                                                  ipaddress.clear();
                                                  macaddress.clear();
                                                  portNumber.clear();
                                                  wirelessmode.clear();
                                                  vlan.clear();
                                                  servingmikrotic.clear();
                                                  height.clear();
                                                  azmuth.clear();
                                                  tilt.clear();
                                                  lat.clear();
                                                  lon.clear();
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
                                                  Navigator.of(context).pop();
                                                },
                                                minWidth: 150,
                                                color: AppColors().maincolor,
                                                shape: StadiumBorder(),
                                                child: Text(
                                                  'YES',
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

  void sectorfield(docid, parentCollectionID) {
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
                        children: const [
                          TableRow(children: [
                            Text(
                              'Sector Name',
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Ssid',
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Band',
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              'Rocket Name',
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Ip address',
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Mac address',
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Port Number',
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Wireless mode',
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Vlan',
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Serving Mikrotic',
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Height',
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Azmuth',
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
                          ])
                        ],
                      ),
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
                          1: FlexColumnWidth(5),
                          2: FlexColumnWidth(1.5),
                          3: FlexColumnWidth(1.8),
                          4: FlexColumnWidth(2.6),
                          5: FlexColumnWidth(2.8),
                          6: FlexColumnWidth(2),
                          7: FlexColumnWidth(3),
                          8: FlexColumnWidth(1.5),
                          9: FlexColumnWidth(3),
                          10: FlexColumnWidth(2),
                          11: FlexColumnWidth(2),
                          12: FlexColumnWidth(1.5),
                          13: FlexColumnWidth(2.8),
                          14: FlexColumnWidth(2.8),
                        },
                        children: [
                          TableRow(children: [
                            SiteTextfield(controller: sectorName),
                            SiteTextfield(controller: ssid),
                            SiteTextfield(controller: band),
                            SiteTextfield(controller: rocketName),
                            SiteTextfield(controller: ipaddress),
                            SiteTextfield(controller: macaddress),
                            SiteTextfield(controller: portNumber),
                            SiteTextfield(controller: wirelessmode),
                            SiteTextfield(controller: vlan),
                            SiteTextfield(controller: servingmikrotic),
                            SiteTextfield(controller: height),
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
                                      .collection('SiteData')
                                      .doc(docid)
                                      .collection('Sectors')
                                      .doc()
                                      .id;
                                  FirebaseFirestore.instance
                                      .collection('SiteData')
                                      .doc(docid)
                                      .collection('Sectors')
                                      .doc(sectorId)
                                      .set({
                                    'ParentCollectionID': parentCollectionID,
                                    'IsectorApproved': 'notrequested',
                                    'SectorId': sectorId,
                                    'SectorName': sectorName.text,
                                    'Ssid': ssid.text,
                                    'Band': band.text,
                                    'RocketName': rocketName.text,
                                    'IpAddress': ipaddress.text,
                                    'MacAddress': macaddress.text,
                                    'PortNumber': portNumber.text,
                                    'WirelessMode': wirelessmode.text,
                                    'Vlan': vlan.text,
                                    'ServingMikrotic': servingmikrotic.text,
                                    'Height': height.text,
                                    'Azmuth': azmuth.text,
                                    'Tilt': tilt.text,
                                    'Lat': lat.text,
                                    'Long': lon.text,
                                    'Type': 'PTMP',
                                    'CreatedDate': DateTime.now(),
                                  });
                                  Navigator.of(context).pop();
                                  sectorName.clear();
                                  ssid.clear();
                                  band.clear();
                                  rocketName.clear();
                                  ipaddress.clear();
                                  macaddress.clear();
                                  portNumber.clear();
                                  wirelessmode.clear();
                                  vlan.clear();
                                  servingmikrotic.clear();
                                  height.clear();
                                  azmuth.clear();
                                  tilt.clear();
                                  lat.clear();
                                  lon.clear();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor:
                                              AppColors().thirdcolor,
                                          content: Text(e.toString(),
                                              style: TextStyle(
                                                color: AppColors().fifthcolor,
                                              ))));
                                  sectorName.clear();
                                  ssid.clear();
                                  band.clear();
                                  rocketName.clear();
                                  ipaddress.clear();
                                  macaddress.clear();
                                  portNumber.clear();
                                  wirelessmode.clear();
                                  vlan.clear();
                                  servingmikrotic.clear();
                                  height.clear();
                                  azmuth.clear();
                                  tilt.clear();
                                  lat.clear();
                                  lon.clear();
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
      });
    }
  }

  void updatesite(documentId, region, sitename) {
    try {
      FirebaseFirestore.instance.collection('SiteData').doc(documentId).update({
        'Region':
            regioncontroller.text.isEmpty ? region : regioncontroller.text,
        'SiteName': siteName.text.isEmpty ? sitename : siteName.text
      });
      regioncontroller.clear();
      siteName.clear();
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
      regioncontroller.clear();
      siteName.clear();
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
                    .collection('SiteData')
                    .doc(documentId)
                    .update({'Isapproved': 'Pending'})
                : FirebaseFirestore.instance
                    .collection('SiteData')
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
        var doc = FirebaseFirestore.instance.collection('SiteData').doc().id;

        FirebaseFirestore.instance.collection('SiteData').doc(doc).set({
          'Region': regioncontroller.text,
          'SiteName': siteName.text,
          'DocId': doc,
          'Isapproved': 'notRequested',
          'CreatedDate': DateTime.now(),
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
