import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/utils/siteTexfield.dart';

class P2p extends StatefulWidget {
  P2p({super.key});

  @override
  State<P2p> createState() => _P2pState();
}

class _P2pState extends State<P2p> {
  final regioncontroller = TextEditingController();
  final siteName = TextEditingController();
  final deviceName = TextEditingController();
  final ssid = TextEditingController();
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
  var check = false;
  var cancelling = true;
  var isupdating = false;
  var sectorview = false;
  var sectorfieldvisibilty = false;
  int? selectedIndex;
  var userbox = Hive.box('Role');

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    regioncontroller.dispose();
    siteName.dispose();
    deviceName.dispose();
    ssid.dispose();
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
    return Column(children: [
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
                    columnWidths: {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(3),
                      2: FlexColumnWidth(6),
                      3: FlexColumnWidth(3),
                      4: FlexColumnWidth(3),
                      5: FlexColumnWidth(5),
                      6: FlexColumnWidth(2),
                      7: FlexColumnWidth(2),
                      8: FlexColumnWidth(2),
                      9: FlexColumnWidth(3),
                      10: FlexColumnWidth(2),
                      11: FlexColumnWidth(2),
                      12: FlexColumnWidth(2),
                      13: FlexColumnWidth(2.8),
                      14: FlexColumnWidth(2.8),
                      15: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Text(
                            'Region',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors().black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          'Site Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors().black),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Device Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors().black),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Mac Address',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors().black),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Ip Address',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors().black),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Ssid',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors().black),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Port Number',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors().black),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Wireless Mode',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors().black),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Vlan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors().black),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Serving Mikrotic',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors().black),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Height',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors().black),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Azmuth',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors().black),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Tilt',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors().black),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Lat',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors().black),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Lon',
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
                              SiteTextfield(
                                controller: deviceName,
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
                              SiteTextfield(
                                controller: macaddress,
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
                              SiteTextfield(
                                controller: ipaddress,
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
                              SiteTextfield(
                                controller: ssid,
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
                              SiteTextfield(
                                controller: portNumber,
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
                              SiteTextfield(
                                controller: wirelessmode,
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
                              SiteTextfield(
                                controller: vlan,
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
                              SiteTextfield(
                                controller: servingmikrotic,
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
                              SiteTextfield(
                                controller: height,
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
                              SiteTextfield(
                                controller: azmuth,
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
                              SiteTextfield(
                                controller: tilt,
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
                              SiteTextfield(
                                controller: lat,
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
                              SiteTextfield(
                                controller: lon,
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
                                        cancelling ? check = false : saveSite();
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
                            ])
                          : TableRow(children: [
                              SizedBox(),
                              SizedBox(),
                              SizedBox(),
                              SizedBox(),
                              SizedBox(),
                              SizedBox(),
                              SizedBox(),
                              SizedBox(),
                              SizedBox(),
                              SizedBox(),
                              SizedBox(),
                              SizedBox(),
                              SizedBox(),
                              SizedBox(),
                              SizedBox(),
                              SizedBox(),
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
                          .collection('P2P')
                          .snapshots(),
                      builder: ((BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text('There is no data!'),
                          );
                        }

                        if (snapshot.hasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var siteName =
                                    snapshot.data!.docs[index]['SiteName'];
                                var region =
                                    snapshot.data!.docs[index]['Region'];
                                var docid = snapshot.data!.docs[index]['DocId'];
                                var ssid = snapshot.data!.docs[index]['Ssid'];
                                var deviceName =
                                    snapshot.data!.docs[index]['DeviceName'];
                                var ipadd =
                                    snapshot.data!.docs[index]['IpAddress'];
                                var macadd =
                                    snapshot.data!.docs[index]['MacAddress'];
                                var pNumber =
                                    snapshot.data!.docs[index]['PortNumber'];
                                var wMode =
                                    snapshot.data!.docs[index]['WirelessMode'];
                                var vlans = snapshot.data!.docs[index]['Vlan'];
                                var sMikrotic = snapshot.data!.docs[index]
                                    ['ServingMikrotic'];
                                var heights =
                                    snapshot.data!.docs[index]['Height'];
                                var azmuths =
                                    snapshot.data!.docs[index]['Azmuth'];
                                var tilts = snapshot.data!.docs[index]['Tilt'];
                                var latt = snapshot.data!.docs[index]['Lat'];
                                var longitude =
                                    snapshot.data!.docs[index]['Long'];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Table(
                                    //border: TableBorder.all(),
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    columnWidths: {
                                      0: FlexColumnWidth(3),
                                      1: FlexColumnWidth(3),
                                      2: FlexColumnWidth(6),
                                      3: FlexColumnWidth(3),
                                      4: FlexColumnWidth(3),
                                      5: FlexColumnWidth(5),
                                      6: FlexColumnWidth(2),
                                      7: FlexColumnWidth(2),
                                      8: FlexColumnWidth(2),
                                      9: FlexColumnWidth(3),
                                      10: FlexColumnWidth(2),
                                      11: FlexColumnWidth(2),
                                      12: FlexColumnWidth(2),
                                      13: FlexColumnWidth(2.8),
                                      14: FlexColumnWidth(2.8),
                                      15: FlexColumnWidth(2),
                                    },
                                    children: [
                                      TableRow(
                                          decoration: BoxDecoration(
                                              color: snapshot.data!.docs[index]['IsApproved'] == 'Pending' ? Colors.yellowAccent.withAlpha(180) : AppColors().fifthcolor,
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
                                              '${snapshot.data!.docs[index]['Region']}',
                                              style: TextStyle(
                                                  color: AppColors().black),
                                              textAlign: TextAlign.center,
                                            ),
                                            SelectableText(
                                              '${snapshot.data!.docs[index]['SiteName']}',
                                              style: TextStyle(
                                                  color: AppColors().black),
                                              textAlign: TextAlign.center,
                                            ),
                                            SelectableText(
                                              '${snapshot.data!.docs[index]['DeviceName']}',
                                              style: TextStyle(
                                                  color: AppColors().black),
                                              textAlign: TextAlign.center,
                                            ),
                                            SelectableText(
                                              '${snapshot.data!.docs[index]['MacAddress']}',
                                              style: TextStyle(
                                                  color: AppColors().black),
                                              textAlign: TextAlign.center,
                                            ),
                                            SelectableText(
                                              '${snapshot.data!.docs[index]['IpAddress']}',
                                              style: TextStyle(
                                                  color: AppColors().black),
                                              textAlign: TextAlign.center,
                                            ),
                                            SelectableText(
                                              '${snapshot.data!.docs[index]['Ssid']}',
                                              style: TextStyle(
                                                  color: AppColors().black),
                                              textAlign: TextAlign.center,
                                            ),
                                            SelectableText(
                                              '${snapshot.data!.docs[index]['PortNumber']}',
                                              style: TextStyle(
                                                  color: AppColors().black),
                                              textAlign: TextAlign.center,
                                            ),
                                            SelectableText(
                                              '${snapshot.data!.docs[index]['WirelessMode']}',
                                              style: TextStyle(
                                                  color: AppColors().black),
                                              textAlign: TextAlign.center,
                                            ),
                                            SelectableText(
                                              '${snapshot.data!.docs[index]['Vlan']}',
                                              style: TextStyle(
                                                  color: AppColors().black),
                                              textAlign: TextAlign.center,
                                            ),
                                            SelectableText(
                                              '${snapshot.data!.docs[index]['ServingMikrotic']}',
                                              style: TextStyle(
                                                  color: AppColors().black),
                                              textAlign: TextAlign.center,
                                            ),
                                            SelectableText(
                                              '${snapshot.data!.docs[index]['Height']}',
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
                                            snapshot.data!.docs[index]['IsApproved'] == 'Pending' ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5),
                                                            child: Container(
                                                              width: 35,
                                                              height: 35,
                                                              child:
                                                                  Center(
                                                                    child: LoadingIndicator(
                                                                colors: [
                                                                    AppColors()
                                                                        .maincolor
                                                                ],
                                                                indicatorType:
                                                                      Indicator
                                                                          .ballRotateChase,
                                                              ),
                                                                  ),
                                                            ),
                                                          ) :
                                            IconButton(
                                                onPressed: () {
                                                  showDataOptions(
                                                      docid,
                                                      index,
                                                      region,
                                                      siteName,
                                                      deviceName,
                                                      ssid,
                                                      ipadd,
                                                      macadd,
                                                      pNumber,
                                                      wMode,
                                                      vlans,
                                                      sMikrotic,
                                                      heights,
                                                      azmuths,
                                                      tilts,
                                                      latt,
                                                      longitude);
                                                },
                                                icon: Icon(Icons.more_horiz))
                                          ])
                                    ],
                                  ),
                                );
                              });
                        }
                        return CircularProgressIndicator();
                      })),
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
    ]);
  }

  void showDataOptions(
      docid,
      index,
      region,
      sname,
      devicename,
      ssids,
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
                                              'Region',
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              'Site Name',
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              'Device Name',
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              'Ssid',
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
                                              hinText: region,
                                              controller: regioncontroller,
                                            ),
                                            SiteTextfield(
                                              controller: siteName,
                                              hinText: sname,
                                            ),
                                            SiteTextfield(
                                              controller: deviceName,
                                              hinText: devicename,
                                            ),
                                            SiteTextfield(
                                              controller: macaddress,
                                              hinText: macaddresses,
                                            ),
                                            SiteTextfield(
                                              controller: ipaddress,
                                              hinText: ipaddresses,
                                            ),
                                            SiteTextfield(
                                              controller: ssid,
                                              hinText: ssids,
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
                                              updatesite(
                                                  docid,
                                                  index,
                                                  region,
                                                  sname,
                                                  devicename,
                                                  ssids,
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
                                                  longs);
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
                                                  'No',
                                                  style: TextStyle(
                                                      color: AppColors()
                                                          .fifthcolor),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 30,
                                              ),
                                              MaterialButton(
                                                onPressed: () {
                                                  deletesite(docid);
                                                },
                                                minWidth: 150,
                                                color: AppColors().maincolor,
                                                shape: StadiumBorder(),
                                                child: Text(
                                                  'Yes',
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

  void viewOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                MaterialButton(
                  onPressed: () {},
                  minWidth: 100,
                  color: AppColors().secondcolor,
                  child: Text('Update'),
                ),
                MaterialButton(
                  onPressed: () {},
                  minWidth: 100,
                  color: AppColors().maincolor,
                  child: Text('Delete'),
                )
              ],
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

  void updatesite(
      documentId,
      index,
      region,
      sname,
      devicename,
      ssids,
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
    if (regioncontroller.text.isNotEmpty ||
        siteName.text.isNotEmpty ||
        deviceName.text.isNotEmpty ||
        macaddress.text.isNotEmpty ||
        ipaddress.text.isNotEmpty ||
        ssid.text.isNotEmpty ||
        portNumber.text.isNotEmpty ||
        wirelessmode.text.isNotEmpty ||
        vlan.text.isNotEmpty ||
        servingmikrotic.text.isNotEmpty ||
        height.text.isNotEmpty ||
        azmuth.text.isNotEmpty ||
        tilt.text.isNotEmpty ||
        lat.text.isNotEmpty ||
        lon.text.isNotEmpty) {
      try {
        FirebaseFirestore.instance.collection('P2P').doc(documentId).update({
          'Region':
              regioncontroller.text.isEmpty ? region : regioncontroller.text,
          'SiteName': siteName.text.isEmpty ? sname : siteName.text,
          'DeviceName': deviceName.text.isEmpty ? devicename : deviceName.text,
          'MacAddress':
              macaddress.text.isEmpty ? macaddresses : macaddress.text,
          'IpAddress': ipaddress.text.isEmpty ? ipaddresses : ipaddress.text,
          'Ssid': ssid.text.isEmpty ? ssids : ssid.text,
          'PortNumber': portNumber.text.isEmpty ? portnumbers : portNumber.text,
          'WirelessMode':
              wirelessmode.text.isEmpty ? wirelessmodes : wirelessmode.text,
          'Vlan': vlan.text.isEmpty ? vlans : vlan.text,
          'ServingMikrotic': servingmikrotic.text.isEmpty
              ? servingmikrotics
              : servingmikrotic.text,
          'Height': height.text.isEmpty ? heights : height.text,
          'Azmuth': azmuth.text.isEmpty ? azmuths : azmuth.text,
          'Tilt': tilt.text.isEmpty ? tilts : tilt.text,
          'Lat': lat.text.isEmpty ? lats : lat.text,
          'Long': lon.text.isEmpty ? longs : lon.text,
        });
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

  void confirmSectorDeletion(
    String documentId,
  ) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      desc: 'Do you really want to delete this Site?',
      btnOk: MaterialButton(
        color: AppColors().maincolor,
        onPressed: () {
          deletesite(documentId);
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
    )..show();
  }

  void deletesite(String documentId) {
    try {
      userbox.get('UserRole') == 'user' ? FirebaseFirestore.instance.collection('P2P').doc(documentId).update({
        'IsApproved' : 'Pending'
      }):
      FirebaseFirestore.instance.collection('P2P').doc(documentId).delete();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors().thirdcolor,
          content: Text(e.toString(),
              style: TextStyle(
                color: AppColors().fifthcolor,
              ))));
    }
  }

  void saveSite() async {
    try {
      if (regioncontroller.text.isNotEmpty && siteName.text.isNotEmpty) {
        var doc = FirebaseFirestore.instance.collection('P2P').doc().id;

        FirebaseFirestore.instance.collection('P2P').doc(doc).set({
          'Region': regioncontroller.text,
          'IsApproved' : 'notrequested',
          'SiteName': siteName.text,
          'DeviceName': deviceName.text,
          'MacAddress': macaddress.text,
          'IpAddress': ipaddress.text,
          'Ssid': ssid.text,
          'PortNumber': portNumber.text,
          'WirelessMode': wirelessmode.text,
          'Vlan': vlan.text,
          'ServingMikrotic': servingmikrotic.text,
          'Height': height.text,
          'Azmuth': azmuth.text,
          'Tilt': tilt.text,
          'Lat': lat.text,
          'Long': lon.text,
          'DocId': doc
        });
        regioncontroller.clear();
        siteName.clear();
        deviceName.clear();
        macaddress.clear();
        ipaddress.clear();
        ssid.clear();
        portNumber.clear();
        wirelessmode.clear();
        vlan.clear();
        servingmikrotic.clear();
        height.clear();
        azmuth.clear();
        tilt.clear();
        lat.clear();
        lon.clear();
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
      deviceName.clear();
      macaddress.clear();
      ipaddress.clear();
      ssid.clear();
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
}
