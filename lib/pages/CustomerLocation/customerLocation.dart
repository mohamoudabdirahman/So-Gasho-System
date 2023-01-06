import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as marker;
import 'package:latlong2/latlong.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:searchbar_animation/const/colours.dart';

import 'package:somcable_web_app/colors/Colors.dart';

import 'package:somcable_web_app/utils/siteTexfield.dart';

class CustomerLocation extends StatefulWidget {
  CustomerLocation({Key? key}) : super(key: key);

  @override
  State<CustomerLocation> createState() => _CustomerLocationState();
}

class _CustomerLocationState extends State<CustomerLocation> {
  var addingCustomer = false;
  final indexcontroller = TextEditingController();
  final latitudeController = TextEditingController();

  final longitudeController = TextEditingController();

  final connectedSectorController = TextEditingController();
  var expand = false;
  var selectedIndex;
  var longperssed = false;
  var longpresslat;
  var longpresslong;
  var stream;

  bool searchbuttontapped = false;

  var searchedName = '';
  final controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    stream = FirebaseFirestore.instance
        .collection('CustomerLocation')
        .orderBy('Index', descending: false)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 196,
      child: Column(
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
                          width: MediaQuery.of(context).size.width - 300,
                          child: SiteTextfield(
                            hinText: 'You can search specific customer location here!(by Index)',
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
                      icon: Icon(searchbuttontapped ? Icons.close : Icons.search,
                          color: AppColors().secondcolor)),
                ],
              ),
            ),
          ),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(children: [
                Text(
                  'Index',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors().black),
                ),
                Text(
                  'Latitude',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors().black),
                ),
                Text(
                  'Longitude',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors().black),
                ),
                Text(
                  'Connected Sector',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors().black),
                ),
                Text(
                  'Map',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors().black),
                ),
                Text(
                  'Options',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors().black),
                ),
              ])
            ],
          ),
          SizedBox(
            height: 25,
          ),
          StreamBuilder(
              stream: stream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'There is no data!',
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                        width: 35,
                        height: 35,
                        child: LoadingIndicator(
                            indicatorType: Indicator.ballGridBeat)),
                  );
                }
                if (snapshot.hasData) {
                  return searchbuttontapped
                      ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          var docid = snapshot.data!.docs[index]['DocumentID'];
                          var indexbyuser = snapshot.data!.docs[index]['Index'];
                          var lat = snapshot.data!.docs[index]['Latitude'];
                          var lon = snapshot.data!.docs[index]['Longitude'];
                          var conSector =
                              snapshot.data!.docs[index]['ConnectedSector'];
                          var data = snapshot.data?.docs[index].data()
                              as Map<String, dynamic>;

                          if (snapshot.data!.docs[index]['Index']
                              .toString()
                              .toLowerCase()
                              .startsWith(searchedName.toLowerCase())) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Table(
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
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
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: SelectableText(
                                                  '${snapshot.data!.docs[index]['Index']}',
                                                  style: TextStyle(
                                                      color: AppColors().black),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              SelectableText(
                                                lat.toString(),
                                                style: TextStyle(
                                                    color: AppColors().black),
                                                textAlign: TextAlign.center,
                                              ),
                                              SelectableText(
                                                lon.toString(),
                                                style: TextStyle(
                                                    color: AppColors().black),
                                                textAlign: TextAlign.center,
                                              ),
                                              SelectableText(
                                                '${snapshot.data!.docs[index]['ConnectedSector']}',
                                                style: TextStyle(
                                                    color: AppColors().black),
                                                textAlign: TextAlign.center,
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    if (expand == false) {
                                                      setState(() {
                                                        expand = true;
                                                        selectedIndex = index;
                                                      });
                                                    } else if (expand == true) {
                                                      setState(() {
                                                        expand = false;
                                                        longperssed = false;
                                                      });
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons
                                                        .expand_circle_down_sharp,
                                                    color:
                                                        AppColors().secondcolor,
                                                  )),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        updateCustomerInformation(
                                                            docid,
                                                            indexbyuser,
                                                            lat,
                                                            lon,
                                                            conSector);
                                                      },
                                                      icon: Icon(
                                                        Icons.edit,
                                                        color: AppColors()
                                                            .secondcolor,
                                                      )),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        deleteCustomerLocation(
                                                            docid);
                                                      },
                                                      icon: Icon(
                                                        Icons.delete_forever,
                                                        color: AppColors()
                                                            .maincolor,
                                                      ))
                                                ],
                                              )
                                            ]),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        selectedIndex == index ? expand : false,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                196,
                                        height: 500,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 2,
                                              color: AppColors().secondcolor,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 8,
                                                  offset: Offset(3, 4),
                                                  spreadRadius: 5,
                                                  color: AppColors()
                                                      .black
                                                      .withOpacity(0.08))
                                            ]),
                                        child: marker.FlutterMap(
                                          options: marker.MapOptions(
                                            onTap: ((tapPosition, point) {
                                              setState(() {
                                                longperssed = true;
                                                longpresslat = point.latitude;
                                                longpresslong = point.longitude;
                                              });
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: Container(
                                                        height: 150,
                                                        child: Column(
                                                          children: [
                                                            ListTile(
                                                              leading: Icon(Icons
                                                                  .location_on),
                                                              title: Text(
                                                                  'Latitude $longpresslat'
                                                                      .toString()),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            ListTile(
                                                              leading: Icon(Icons
                                                                  .location_on),
                                                              title: Text(
                                                                  'Longitude $longpresslong'
                                                                      .toString()),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      actions: [
                                                        Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: MaterialButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            minWidth: 300,
                                                            color: AppColors()
                                                                .secondcolor,
                                                            child: Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                  color: AppColors()
                                                                      .fifthcolor),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  });
                                            }),
                                            center: LatLng(
                                                snapshot.data!.docs[index]
                                                    ['Latitude'],
                                                snapshot.data!.docs[index]
                                                    ['Longitude']),
                                            zoom: 9.2,
                                          ),
                                          nonRotatedChildren: [
                                            marker.AttributionWidget
                                                .defaultWidget(
                                              source:
                                                  'OpenStreetMap contributors',
                                              onSourceTapped: null,
                                            ),
                                          ],
                                          children: [
                                            marker.TileLayer(
                                              urlTemplate:
                                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                              userAgentPackageName:
                                                  'com.example.app',
                                              backgroundColor:
                                                  AppColors().fifthcolor,
                                              maxZoom: 30,
                                            ),
                                            marker.MarkerLayer(
                                              markers: [
                                                marker.Marker(
                                                    point: LatLng(
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['Latitude'],
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['Longitude']),
                                                    builder: (context) {
                                                      return Container(
                                                        width: 45.0,
                                                        height: 45.0,
                                                        child: Icon(
                                                          Icons.location_pin,
                                                          size: 45.0,
                                                          color: AppColors()
                                                              .secondcolor,
                                                        ),
                                                      );
                                                    }),
                                                longperssed
                                                    ? marker.Marker(
                                                        point: LatLng(
                                                            longpresslat,
                                                            longpresslong),
                                                        builder: (context) {
                                                          return Container(
                                                            width: 45.0,
                                                            height: 45.0,
                                                            child: Icon(
                                                              Icons
                                                                  .location_searching_rounded,
                                                              size: 45.0,
                                                              color: AppColors()
                                                                  .maincolor,
                                                            ),
                                                          );
                                                        })
                                                    : marker.Marker(
                                                        point: LatLng(0, 0),
                                                        builder: (context) {
                                                          return SizedBox();
                                                        })
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                          return Container();
                        }))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                            var docid =
                                snapshot.data!.docs[index]['DocumentID'];
                            var indexbyuser =
                                snapshot.data!.docs[index]['Index'];
                            var lat = snapshot.data!.docs[index]['Latitude'];
                            var lon = snapshot.data!.docs[index]['Longitude'];
                            var conSector =
                                snapshot.data!.docs[index]['ConnectedSector'];
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Table(
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
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
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: SelectableText(
                                                  '${snapshot.data!.docs[index]['Index']}',
                                                  style: TextStyle(
                                                      color: AppColors().black),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              SelectableText(
                                                lat.toString(),
                                                style: TextStyle(
                                                    color: AppColors().black),
                                                textAlign: TextAlign.center,
                                              ),
                                              SelectableText(
                                                lon.toString(),
                                                style: TextStyle(
                                                    color: AppColors().black),
                                                textAlign: TextAlign.center,
                                              ),
                                              SelectableText(
                                                '${snapshot.data!.docs[index]['ConnectedSector']}',
                                                style: TextStyle(
                                                    color: AppColors().black),
                                                textAlign: TextAlign.center,
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    if (expand == false) {
                                                      setState(() {
                                                        expand = true;
                                                        selectedIndex = index;
                                                      });
                                                    } else if (expand == true) {
                                                      setState(() {
                                                        expand = false;
                                                        longperssed = false;
                                                      });
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons
                                                        .expand_circle_down_sharp,
                                                    color:
                                                        AppColors().secondcolor,
                                                  )),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        updateCustomerInformation(
                                                            docid,
                                                            indexbyuser,
                                                            lat,
                                                            lon,
                                                            conSector);
                                                      },
                                                      icon: Icon(
                                                        Icons.edit,
                                                        color: AppColors()
                                                            .secondcolor,
                                                      )),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        deleteCustomerLocation(
                                                            docid);
                                                      },
                                                      icon: Icon(
                                                        Icons.delete_forever,
                                                        color: AppColors()
                                                            .maincolor,
                                                      ))
                                                ],
                                              )
                                            ]),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        selectedIndex == index ? expand : false,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                196,
                                        height: 500,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 2,
                                              color: AppColors().secondcolor,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 8,
                                                  offset: Offset(3, 4),
                                                  spreadRadius: 5,
                                                  color: AppColors()
                                                      .black
                                                      .withOpacity(0.08))
                                            ]),
                                        child: marker.FlutterMap(
                                          options: marker.MapOptions(
                                            onTap: ((tapPosition, point) {
                                              setState(() {
                                                longperssed = true;
                                                longpresslat = point.latitude;
                                                longpresslong = point.longitude;
                                              });
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: Container(
                                                        height: 150,
                                                        child: Column(
                                                          children: [
                                                            ListTile(
                                                              leading: Icon(Icons
                                                                  .location_on),
                                                              title: Text(
                                                                  'Latitude $longpresslat'
                                                                      .toString()),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            ListTile(
                                                              leading: Icon(Icons
                                                                  .location_on),
                                                              title: Text(
                                                                  'Longitude $longpresslong'
                                                                      .toString()),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      actions: [
                                                        Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: MaterialButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            minWidth: 300,
                                                            color: AppColors()
                                                                .secondcolor,
                                                            child: Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                  color: AppColors()
                                                                      .fifthcolor),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  });
                                            }),
                                            center: LatLng(
                                                snapshot.data!.docs[index]
                                                    ['Latitude'],
                                                snapshot.data!.docs[index]
                                                    ['Longitude']),
                                            zoom: 9.2,
                                          ),
                                          nonRotatedChildren: [
                                            marker.AttributionWidget
                                                .defaultWidget(
                                              source:
                                                  'OpenStreetMap contributors',
                                              onSourceTapped: null,
                                            ),
                                          ],
                                          children: [
                                            marker.TileLayer(
                                              urlTemplate:
                                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                              userAgentPackageName:
                                                  'com.example.app',
                                              backgroundColor:
                                                  AppColors().fifthcolor,
                                              maxZoom: 30,
                                            ),
                                            marker.MarkerLayer(
                                              markers: [
                                                marker.Marker(
                                                    point: LatLng(
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['Latitude'],
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['Longitude']),
                                                    builder: (context) {
                                                      return Container(
                                                        width: 45.0,
                                                        height: 45.0,
                                                        child: Icon(
                                                          Icons.location_pin,
                                                          size: 45.0,
                                                          color: AppColors()
                                                              .secondcolor,
                                                        ),
                                                      );
                                                    }),
                                                longperssed
                                                    ? marker.Marker(
                                                        point: LatLng(
                                                            longpresslat,
                                                            longpresslong),
                                                        builder: (context) {
                                                          return Container(
                                                            width: 45.0,
                                                            height: 45.0,
                                                            child: Icon(
                                                              Icons
                                                                  .location_searching_rounded,
                                                              size: 45.0,
                                                              color: AppColors()
                                                                  .maincolor,
                                                            ),
                                                          );
                                                        })
                                                    : marker.Marker(
                                                        point: LatLng(0, 0),
                                                        builder: (context) {
                                                          return SizedBox();
                                                        })
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }));
                }
                return Container();
              }),
          addingCustomer == true
              ? Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(children: [
                      SiteTextfield(
                        controller: indexcontroller,
                        onchange: (value) {},
                      ),
                      SiteTextfield(
                        controller: latitudeController,
                        onchange: (value) {},
                      ),
                      SiteTextfield(
                        controller: longitudeController,
                        onchange: (value) {},
                      ),
                      SiteTextfield(
                        controller: connectedSectorController,
                        onchange: (value) {},
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                saveCustomerLocation();
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      AppColors().secondcolor)),
                              child: Text(
                                'Save',
                                style: TextStyle(color: AppColors().black),
                              )),
                          SizedBox(
                            width: 50,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  addingCustomer = false;
                                });
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      AppColors().greycolor)),
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: AppColors().black),
                              ))
                        ],
                      )
                    ])
                  ],
                )
              : SizedBox(),
          SizedBox(
            height: 10,
          ),
          Visibility(
            visible: searchbuttontapped == false ? true : false,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  addingCustomer = true;
                });
              },
              backgroundColor: AppColors().secondcolor,
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }

  void deleteCustomerLocation(documentId) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      desc: 'Do you really want to delete this Site?',
      btnOk: MaterialButton(
        color: AppColors().maincolor,
        onPressed: () {
          try {
            FirebaseFirestore.instance
                .collection('CustomerLocation')
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
            Navigator.of(context).pop();
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

  void updateCustomerInformation(
      documentId, indexbyuser, lat, lon, connSector) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppColors().fifthcolor,
            content: Container(
              width: MediaQuery.of(context).size.width - 196,
              color: AppColors().fifthcolor,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        Text(
                          'Index',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors().black),
                        ),
                        Text(
                          'Latitude',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors().black),
                        ),
                        Text(
                          'Longitude',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors().black),
                        ),
                        Text(
                          'Connected Sector',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors().black),
                        ),
                        Text(
                          'Decision',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors().black),
                        ),
                      ])
                    ],
                  ),
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        SiteTextfield(
                          hinText: indexbyuser,
                          controller: indexcontroller,
                          onchange: (value) {},
                        ),
                        SiteTextfield(
                          hinText: lat.toString(),
                          controller: latitudeController,
                          onchange: (value) {},
                        ),
                        SiteTextfield(
                          hinText: lon.toString(),
                          controller: longitudeController,
                          onchange: (value) {},
                        ),
                        SiteTextfield(
                          hinText: connSector,
                          controller: connectedSectorController,
                          onchange: (value) {},
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  try {
                                    FirebaseFirestore.instance
                                        .collection('CustomerLocation')
                                        .doc(documentId)
                                        .update({
                                      'Index': indexcontroller.text.isEmpty
                                          ? indexbyuser
                                          : indexcontroller.text,
                                      'Latitude':
                                          latitudeController.text.isEmpty
                                              ? lat
                                              : double.parse(
                                                  latitudeController.text),
                                      'Longitude':
                                          longitudeController.text.isEmpty
                                              ? lon
                                              : double.parse(
                                                  longitudeController.text),
                                      'ConnectedSector':
                                          connectedSectorController.text.isEmpty
                                              ? connSector
                                              : connectedSectorController.text,
                                    });
                                    Navigator.of(context).pop();
                                    indexcontroller.clear();
                                    latitudeController.clear();
                                    longitudeController.clear();
                                    connectedSectorController.clear();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor:
                                                AppColors().thirdcolor,
                                            content: Text(e.toString(),
                                                style: TextStyle(
                                                  color: AppColors().fifthcolor,
                                                ))));
                                    indexcontroller.clear();
                                    latitudeController.clear();
                                    longitudeController.clear();
                                    connectedSectorController.clear();
                                  }
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        AppColors().secondcolor)),
                                child: Text(
                                  'Save',
                                  style: TextStyle(color: AppColors().black),
                                )),
                            SizedBox(
                              width: 50,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        AppColors().greycolor)),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: AppColors().black),
                                ))
                          ],
                        )
                      ])
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void saveCustomerLocation() {
    if (indexcontroller.text.isNotEmpty &&
        latitudeController.text.isNotEmpty &&
        longitudeController.text.isNotEmpty &&
        connectedSectorController.text.isNotEmpty) {
      try {
        var docid =
            FirebaseFirestore.instance.collection('CustomerLocation').doc().id;
        FirebaseFirestore.instance
            .collection('CustomerLocation')
            .doc(docid)
            .set({
          'Index': indexcontroller.text,
          'Latitude': double.parse(latitudeController.text),
          'Longitude': double.parse(longitudeController.text),
          'ConnectedSector': connectedSectorController.text,
          'DocumentID': docid,
          'CreatedDate' : DateTime.now(),
        });
        addingCustomer = false;
        indexcontroller.clear();
        latitudeController.clear();
        longitudeController.clear();
        connectedSectorController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors().thirdcolor,
            content: Text(e.toString(),
                style: TextStyle(
                  color: AppColors().fifthcolor,
                ))));
        indexcontroller.clear();
        latitudeController.clear();
        longitudeController.clear();
        connectedSectorController.clear();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors().thirdcolor,
          content: Text("These fields can't be empty! please fill them.",
              style: TextStyle(
                color: AppColors().fifthcolor,
              ))));
    }
  }
}
