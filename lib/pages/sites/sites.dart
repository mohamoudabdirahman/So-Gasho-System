import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/pages/sites/lte2.dart';

import 'package:somcable_web_app/pages/sites/p2p.dart';
import 'package:somcable_web_app/pages/sites/ptmp.dart';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 900,
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
                          color: selectedtab == 'ptmp'
                              ? AppColors().secondcolor
                              : AppColors().maincolor,
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
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 196,
                      child: SearchBarAnimation(
                        textEditingController: controller,
                        isOriginalAnimation: true,
                        enableKeyboardFocus: true,
                        durationInMilliSeconds: 500,
                        onExpansionComplete: () {
                          setState(() {
                            searchbuttontapped = true;
                          });
                        },
                        onCollapseComplete: () {
                          setState(() {
                            searchbuttontapped = false;
                          });
                        },
                        onPressButton: (isSearchBarOpens) {
                          debugPrint(
                              'do something before animation started. It\'s the ${isSearchBarOpens ? 'opening' : 'closing'} animation');
                        },
                        trailingWidget: const Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.black,
                        ),
                        secondaryButtonWidget: const Icon(
                          Icons.close,
                          size: 20,
                          color: const Color(0xffB91F3B),
                        ),
                        buttonWidget: const Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.deepOrange,
                        ),
                        searchBoxBorderColour: const Color(0xffB91F3B),
                        isSearchBoxOnRightSide: true,
                        onChanged: (value) {
                          searchedName = value;
                          setState(() {
                            searchedName = controller.text;
                          });
                        },
                      ),
                    ),
                  ),
                  Stack(children: [
                    searchbuttontapped == false
                        ? Align(
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                selectedtab == 'ptmp'
                                    ? Ptmp()
                                    : selectedtab == 'p2p'
                                        ? P2p()
                                        : selectedtab == 'lte'
                                            ? LTE()
                                            : SizedBox()
                              ],
                            ),
                          )
                        : StreamBuilder(
                            stream: selectedtab == 'ptmp'
                                ? FirebaseFirestore.instance
                                    .collection('SiteData')
                                    .snapshots()
                                : selectedtab == 'p2p'
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
                                  child: Text('Nothing to Show here!'),
                                );
                              }
                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: Expanded(
                                    child: Container(
                                      height: 700,
                                      width: MediaQuery.of(context).size.width -
                                          196,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            selectedtab == 'ptmp'
                                                ? Table(
                                                    children: [
                                                      TableRow(children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          child: Text(
                                                            'Region',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black),
                                                          ),
                                                        ),
                                                        Text('Site Name',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black)),
                                                        Text(
                                                          'Sectors',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors()
                                                                  .black),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ]),
                                                    ],
                                                  )
                                                : selectedtab == 'p2p'
                                                    ? Table(columnWidths: {
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
                                                        13: FlexColumnWidth(
                                                            2.8),
                                                        14: FlexColumnWidth(
                                                            2.8),
                                                        15: FlexColumnWidth(2),
                                                      }, children: [
                                                        TableRow(children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0),
                                                            child: Text(
                                                              'Region',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      AppColors()
                                                                          .black),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Site Name',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            'Device Name',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            'Mac Address',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            'Ip Address',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            'Ssid',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            'Port Number',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            'Wireless Mode',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            'Vlan',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            'Serving Mikrotic',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            'Height',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            'Azmuth',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            'Tilt',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            'Lat',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            'Lon',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            'Options',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ])
                                                      ])
                                                    : Table(
                                                    children: [
                                                      TableRow(children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          child: Text(
                                                            'Region',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black),
                                                          ),
                                                        ),
                                                        Text('Site Name',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColors()
                                                                        .black)),
                                                        Text(
                                                          'Sectors',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors()
                                                                  .black),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ]),
                                                    ],
                                                  ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    snapshot.data!.docs.length,
                                                itemBuilder: (contex, index) {
                                                  var data = snapshot
                                                          .data?.docs[index]
                                                          .data()
                                                      as Map<String, dynamic>;

                                                  if (data['SiteName']
                                                      .toString()
                                                      .toLowerCase()
                                                      .startsWith(searchedName
                                                          .toLowerCase())) {
                                                    // pmtp variables
                                                    var sitename =
                                                        data['SiteName'];
                                                    var region = data['Region'];

                                                    if (data['Isapproved'] ==
                                                        'Pending') {
                                                      issitedelete = true;
                                                    } else if (data[
                                                            'Isapproved'] ==
                                                        'notrequested') {
                                                      issitedelete = false;
                                                    }

                                                    // p2p variables

                                                    var p2psitename =
                                                        data['SiteName'];
                                                    var p2pdevicename =
                                                        data['DeviceName'];
                                                    var p2pAzmuth =
                                                        data['Azmuth'];
                                                    var p2pheight =
                                                        data['Height'];
                                                    var p2pIpaddress =
                                                        data['IpAddress'];
                                                    var p2plat = data['Lat'];
                                                    var p2plon = data['Long'];
                                                    var p2pMacaddress =
                                                        data['MacAddress'];
                                                    var p2pPortNumber =
                                                        data['PortNumber'];
                                                    var p2pRegion =
                                                        data['Region'];
                                                    var p2pServingMikrotic =
                                                        data['ServingMikrotic'];
                                                    var p2pSsid = data['Ssid'];
                                                    var p2pTilt = data['Tilt'];
                                                    var p2pVlan = data['Vlan'];
                                                    var p2pWirelessMode =
                                                        data['WirelessMode'];

                                                    // lte variables

                                                    var ltesitename =
                                                        data['SiteName'];
                                                    var lteSectorInsys =
                                                        data['SectorInSys'];
                                                    var lteAzmuth =
                                                        data['Azmuth'];
                                                    var lteHeightoftower =
                                                        data['HeightOfTower'];
                                                    var lteHeightOfAntena =
                                                        data['HeightOfAntena'];
                                                    var lteHeightOfBuilding =
                                                        data[
                                                            'HeightOfBuilding'];
                                                    var lteIsApproved =
                                                        data['IsApproved'];
                                                    var lteLat = data['Lat'];
                                                    var lteLong = data['Long'];
                                                    var lteMechanicTilt =
                                                        data['MechanicalTilt'];
                                                    var lteRegion =
                                                        data['Region'];
                                                    var lteSectId =
                                                        data['SectID'];
                                                    var lteTilt = data['Tilt'];

                                                    return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 15),
                                                        child:
                                                            selectedtab ==
                                                                    'ptmp'
                                                                ? Table(
                                                                    defaultVerticalAlignment:
                                                                        TableCellVerticalAlignment
                                                                            .middle,
                                                                    children: [
                                                                      TableRow(
                                                                          decoration: BoxDecoration(
                                                                              color: AppColors().fifthcolor,
                                                                              borderRadius: BorderRadius.circular(7),
                                                                              boxShadow: [
                                                                                BoxShadow(blurRadius: 8, offset: Offset(3, 4), spreadRadius: 5, color: AppColors().black.withOpacity(0.08))
                                                                              ]),
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10),
                                                                              child: Text(
                                                                                region,
                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors().black),
                                                                              ),
                                                                            ),
                                                                            Text(sitename,
                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors().black)),
                                                                            IconButton(
                                                                                onPressed: () {
                                                                                  showDialog(
                                                                                      context: context,
                                                                                      builder: (contex) {
                                                                                        return AlertDialog(
                                                                                          content: Column(children: [
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                                              
                                                                                              children: [
                                                                                                Container(
                                                                                                  decoration: BoxDecoration(
                                                                                                    shape: BoxShape.rectangle,
                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                    color: AppColors().maincolor
                                                                                                  ),
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
                                                                                                15: FlexColumnWidth(0.5),
                                                                                              },
                                                                                              children: [
                                                                                                TableRow(children: [
                                                                                                  Text(
                                                                                                    'Sector Name',style: TextStyle(fontWeight: FontWeight.bold),
                                                                                                    textAlign: TextAlign.center,
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'Ssid',
                                                                                                    textAlign: TextAlign.center
                                                                                                    ,style: TextStyle(fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'Band',
                                                                                                    textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'Rocket Name',
                                                                                                    textAlign: TextAlign.center
                                                                                                    ,style: TextStyle(fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'Ip address',
                                                                                                    textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'Mac address',
                                                                                                    textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'Port Number',
                                                                                                    textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'Wireless mode',
                                                                                                    textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'Vlan',
                                                                                                    textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'Serving Mikrotic',
                                                                                                    textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'Height',
                                                                                                    textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'Azmuth',
                                                                                                    textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'Tilt',
                                                                                                    textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'Lat',
                                                                                                    textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'Lon',
                                                                                                    textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),
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
                                                                                  Icons.expand_circle_down_rounded,
                                                                                  color: AppColors().secondcolor,
                                                                                )),
                                                                          ]),
                                                                    ],
                                                                  )
                                                                : selectedtab ==
                                                                        'p2p'
                                                                    ? Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 15.0),
                                                                        child: Table(
                                                                            //border: TableBorder.all(),
                                                                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                                                                            },
                                                                            children: [
                                                                              TableRow(
                                                                                  decoration: BoxDecoration(color: data['IsApproved'] == 'Pending' ? Colors.yellowAccent.withAlpha(180) : AppColors().fifthcolor, borderRadius: BorderRadius.circular(7), boxShadow: [
                                                                                    BoxShadow(blurRadius: 8, offset: Offset(3, 4), spreadRadius: 5, color: AppColors().black.withOpacity(0.08))
                                                                                  ]),
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(10),
                                                                                      child: SelectableText(
                                                                                        '${data['Region']}',
                                                                                        style: TextStyle(color: AppColors().black),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                    SelectableText(
                                                                                      '${data['SiteName']}',
                                                                                      style: TextStyle(color: AppColors().black),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                    SelectableText(
                                                                                      '${data['DeviceName']}',
                                                                                      style: TextStyle(color: AppColors().black),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                    SelectableText(
                                                                                      '${data['MacAddress']}',
                                                                                      style: TextStyle(color: AppColors().black),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                    SelectableText(
                                                                                      '${data['IpAddress']}',
                                                                                      style: TextStyle(color: AppColors().black),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                    SelectableText(
                                                                                      '${data['Ssid']}',
                                                                                      style: TextStyle(color: AppColors().black),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                    SelectableText(
                                                                                      '${data['PortNumber']}',
                                                                                      style: TextStyle(color: AppColors().black),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                    SelectableText(
                                                                                      '${data['WirelessMode']}',
                                                                                      style: TextStyle(color: AppColors().black),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                    SelectableText(
                                                                                      '${data['Vlan']}',
                                                                                      style: TextStyle(color: AppColors().black),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                    SelectableText(
                                                                                      '${data['ServingMikrotic']}',
                                                                                      style: TextStyle(color: AppColors().black),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                    SelectableText(
                                                                                      '${data['Height']}',
                                                                                      style: TextStyle(color: AppColors().black),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                    SelectableText(
                                                                                      '${data['Azmuth']}',
                                                                                      style: TextStyle(color: AppColors().black),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                    SelectableText(
                                                                                      '${data['Tilt']}',
                                                                                      style: TextStyle(color: AppColors().black),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                    SelectableText(
                                                                                      '${data['Lat']}',
                                                                                      style: TextStyle(color: AppColors().black),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                    SelectableText(
                                                                                      '${data['Long']}',
                                                                                      style: TextStyle(color: AppColors().black),
                                                                                      textAlign: TextAlign.center,
                                                                                    )
                                                                                  ])
                                                                            ]),
                                                                      )
                                                                    : Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 15),
                                                                        child: Table(
                                                                    defaultVerticalAlignment:
                                                                        TableCellVerticalAlignment
                                                                            .middle,
                                                                    children: [
                                                                      TableRow(
                                                                          decoration: BoxDecoration(
                                                                              color: AppColors().fifthcolor,
                                                                              borderRadius: BorderRadius.circular(7),
                                                                              boxShadow: [
                                                                                BoxShadow(blurRadius: 8, offset: Offset(3, 4), spreadRadius: 5, color: AppColors().black.withOpacity(0.08))
                                                                              ]),
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10),
                                                                              child: Text(
                                                                                region,
                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors().black),
                                                                              ),
                                                                            ),
                                                                            Text(sitename,
                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors().black)),
                                                                            IconButton(
                                                                                onPressed: () {
                                                                                  showDialog(
                                                                                      context: context,
                                                                                      builder: (contex) {
                                                                                        return AlertDialog(
                                                                                          content: Column(children: [
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                                              
                                                                                              children: [
                                                                                                Container(
                                                                                                  decoration: BoxDecoration(
                                                                                                    shape: BoxShape.rectangle,
                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                    color: AppColors().maincolor
                                                                                                  ),
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
                                                                                            SizedBox(
                                                                                              height: 20,
                                                                                            ),
                                                                                            Expanded(
                                                                                              child: Container(
                                                                                                width: MediaQuery.of(contex).size.width - 196,
                                                                                                height: 1000,
                                                                                                child: StreamBuilder(
                                                                                                  stream: FirebaseFirestore.instance.collection('LTE').doc(data['DocId']).collection('Sectors').snapshots(),
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
                                                                                                            return Table(defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                                                                                  Icons.expand_circle_down_rounded,
                                                                                  color: AppColors().secondcolor,
                                                                                )),
                                                                          ]),
                                                                    ],
                                                                  )
                                                                      ));
                                                  }

                                                  return Container();
                                                }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          )
                  ]),
                ]),
          ),
        ),
      ),
    );
  }
}
