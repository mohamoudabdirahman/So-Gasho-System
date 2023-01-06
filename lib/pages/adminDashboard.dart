import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/main.dart';
import 'package:somcable_web_app/pages/loginpage.dart';
import 'package:somcable_web_app/pages/messenger.dart';
import 'package:somcable_web_app/pages/RequestsPage/requests.dart';
import 'package:somcable_web_app/pages/settingstabs/settings.dart';
import 'package:somcable_web_app/pages/sites/sites.dart';
import 'package:somcable_web_app/pages/users.dart';
import 'package:somcable_web_app/userDatabase/userModel.dart';
import 'package:somcable_web_app/utils/Buttons.dart';
import 'package:somcable_web_app/utils/Navigation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:weather/weather.dart';
import 'package:audioplayers/audioplayers.dart';

class AdminDashboard extends StatefulWidget {
  bool? iswidgetvisible;
  AdminDashboard({Key? key, this.iswidgetvisible}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  DateTime? _selectedDay;
  DateTime? _focusedDay;
  bool? morning;
  bool? afternoon;
  bool? evening;
  String? currentWindow = 'Dashboard';
  String? fname;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  UserModel loggedInUser = UserModel();
  User? user = FirebaseAuth.instance.currentUser;
  var obtaniedemail = Hive.box('CheckingLoggedInUser');
  var usersName = Hive.box('UsersName');
  var userrole = Hive.box('Role');
  var darkmode = Hive.box('darkmode');
  var temp = Hive.box('Tempereture');
  WeatherFactory wf = WeatherFactory("bd7bca6fc9b62b9aed2a51d263dfdfae");
  var celcius;
  var minutes = 120;
  var timer;
  var streamMessages;
  var newUser = false;
  var newmessage = false;
  var streamRequests;
  var streamNewUserRequest;
  var newRequest = false;
  var showNotificationDialog = false;
  var newSector = false;
  var streamPtmp;
  var newPtmp = false;
  var streamP2p;
  var streamLte;
  var newlte = false;
  var newp2p = false;
  var noAudio = false;
  AudioPlayer audioPlayer = AudioPlayer();

  //var icon;

  @override
  void initState() {
    if (userrole.get('UserRole') == 'user') {
      streamMessages = FirebaseFirestore.instance
          .collection('Messages')
          .orderBy('DateTime', descending: true)
          .limit(1)
          .snapshots();

      showNotification();
    } else {
      streamLte = FirebaseFirestore.instance.collection('LTE').snapshots();

      streamPtmp =
          FirebaseFirestore.instance.collection('SiteData').snapshots();

      streamP2p = FirebaseFirestore.instance.collection('P2P').snapshots();

      streamRequests = FirebaseFirestore.instance
          .collectionGroup('Sectors')
          .orderBy('CreatedDate', descending: true)
          .limit(1)
          .snapshots();
      streamNewUserRequest = FirebaseFirestore.instance
          .collection('Users')
          .orderBy('CreatedDate', descending: true)
          .limit(1)
          .snapshots();
      streamMessages = FirebaseFirestore.instance
          .collection('Messages')
          .orderBy('DateTime', descending: true)
          .limit(1)
          .snapshots();
      ptmpNotification();
      p2pNotification();
      lteNotification();
      showNotification();
      siteNotifcations();
      userNotification();
    }

    // TODO: implement initState
    super.initState();
    if (darkmode.get('darkmode') == null) {
      setState(() {
        darkmode.put('darkmode', false);
      });
    }
    countdownTimer();
  }

  void playAudio() async {
    if (noAudio == true) {
      return;
    } else {
      await audioPlayer.play(
          UrlSource('https://soundbible.com/grab.php?id=2154&type=wav'),
          volume: 0.2,
          position: const Duration(milliseconds: 300));
    }
  }

  lteNotification() {
    try {
      streamLte.listen((event) {
        for (var element in event.docs) {
          if (element.get('Isapproved') == 'Pending') {
            setState(() {
              newlte = true;
            });

            playAudio();
            break;
          } else {
            setState(() {
              newlte = false;
            });
          }
         
        }
      });
    } catch (e) {}
  }

  p2pNotification() {
    try {
      streamP2p.listen((event) {
        for (var element in event.docs) {
          if (element.get('Isapproved') == 'Pending') {
            setState(() {
              newp2p = true;
            });

            playAudio();
            break;
          } else {
            setState(() {
              newp2p = false;
            });
          }
         
        }
      });
    } catch (e) {}
  }

  ptmpNotification() {
    try {
      streamPtmp.listen((event) {
        for (var element in event.docs) {
          if (element.get('Isapproved') == 'Pending') {
            setState(() {
              newPtmp = true;
            });

            playAudio();
            break;
          } else {
            setState(() {
              newPtmp = false;
            });
          }
         
        }
      });
    } catch (e) {}
  }

  siteNotifcations() {
    try {
      streamRequests.listen((event) {
        if (event.docs.first.get('IsectorApproved') == 'Pending') {
          setState(() {
            newSector = true;
          });
          playAudio();
        } else {
          setState(() {
            newSector = false;
          });
        }
       
      });
    } catch (e) {}
  }

  userNotification() {
    try {
      streamNewUserRequest.listen((event) {
        if (event.docs.first.get('IsApproved') == 'requested') {
          setState(() {
            newUser = true;
          });
          playAudio();
        } else {
          setState(() {
            newUser = false;
          });
        }
       
      });
    } catch (e) {}
  }

  showNotification() {
    try {
      streamMessages.listen((event) {
        if (event.docs.first.get('Sender') ==
            FirebaseAuth.instance.currentUser!.uid) {
          return;
        }
        if (event.docs.isEmpty) {
          return;
        }
        setState(() {
          if (currentWindow == 'messenger') {
            newmessage = false;
          } else {
            newmessage = true;
          }
        });
       
        newmessage ? playAudio() : null;
        
      }
      
      );
      
    } on Exception catch (e) {
      // TODO
      return;
    }
  }

  void countdownTimer() {
    timer = Timer.periodic(const Duration(seconds: 7200), (_) {
      setState(() {
        temp.put('Tempereture', '');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: AppColors().fifthcolor,
          body: Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width / 20,
                decoration: BoxDecoration(
                  color: AppColors().maincolor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'lib/images/so logo.png',
                            color: AppColors().fifthcolor,
                            height: 85,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          NavigationButtons(
                            backcolor: currentWindow == 'Dashboard'
                                ? AppColors().secondcolor
                                : Colors.transparent,
                            navigationIcon: Icons.dashboard,
                            onpressed: () {
                              setState(() {
                                widget.iswidgetvisible = true;

                                setState(() {
                                  currentWindow = 'Dashboard';
                                });
                              });
                            },
                          ),
                          userrole.get('UserRole') == 'user'
                              ? SizedBox()
                              : Stack(children: [
                                  NavigationButtons(
                                      backcolor: currentWindow == 'Requests'
                                          ? AppColors().secondcolor
                                          : Colors.transparent,
                                      onpressed: () {
                                        widget.iswidgetvisible = true;
                                        setState(() {
                                          currentWindow = 'Requests';
                                        });
                                      },
                                      navigationIcon: Icons.checklist),
                                  Visibility(
                                    visible: currentWindow == 'Requests'
                                        ? false
                                        : newUser,
                                    child: Positioned(
                                      top: 5,
                                      left: 4,
                                      child: Container(
                                        width: 15,
                                        height: 15,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: AppColors().fifthcolor),
                                            shape: BoxShape.circle,
                                            color: AppColors().maincolor),
                                      ),
                                    ),
                                  )
                                ]),
                          NavigationButtons(
                            backcolor: currentWindow == 'Sites'
                                ? AppColors().secondcolor
                                : Colors.transparent,
                            onpressed: () {
                              widget.iswidgetvisible = true;
                              setState(() {
                                currentWindow = 'Sites';
                              });
                            },
                            navigationIcon: Icons.cell_tower,
                          ),
                          Stack(
                            children: [
                              NavigationButtons(
                                backcolor: currentWindow == 'messenger'
                                    ? AppColors().secondcolor
                                    : Colors.transparent,
                                onpressed: () {
                                  widget.iswidgetvisible = true;
                                  setState(() {
                                    currentWindow = 'messenger';
                                    newmessage = false;
                                  });
                                },
                                navigationIcon: Icons.message,
                              ),
                              Visibility(
                                visible: currentWindow == 'messenger'
                                    ? false
                                    : newmessage,
                                child: Positioned(
                                  top: 5,
                                  left: 4,
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: AppColors().fifthcolor),
                                        shape: BoxShape.circle,
                                        color: AppColors().maincolor),
                                  ),
                                ),
                              )
                            ],
                          ),
                          userrole.get('UserRole') == 'user'
                              ? SizedBox()
                              : NavigationButtons(
                                  backcolor: currentWindow == 'users'
                                      ? AppColors().secondcolor
                                      : Colors.transparent,
                                  onpressed: () {
                                    widget.iswidgetvisible = true;
                                    setState(() {
                                      currentWindow = 'users';
                                    });
                                  },
                                  navigationIcon: Icons.person_search,
                                ),
                          NavigationButtons(
                            backcolor: currentWindow == 'Settings'
                                ? AppColors().secondcolor
                                : Colors.transparent,
                            onpressed: () {
                              widget.iswidgetvisible = true;
                              setState(() {
                                currentWindow = 'Settings';
                              });
                            },
                            navigationIcon: Icons.settings,
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                          obtaniedemail.put('Email', '');
                          usersName.put('UsersName', '');
                          userrole.put('UserRole', '');
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: 120,
                            decoration: BoxDecoration(
                                color: AppColors().maincolor,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 3),
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.5))
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.logout,
                                size: 50,
                                color: AppColors().fifthcolor,
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
              currentWindow == 'users'
                  ? UserData()
                  : currentWindow == 'messenger'
                      ? Messenger()
                      : currentWindow == 'Sites'
                          ? Sites()
                          : currentWindow == 'Requests'
                              ? Requests()
                              : currentWindow == 'Settings'
                                  ? SettingsPage()
                                  : currentWindow == 'Dashboard'
                                      ? Container(
                                          //height: 1000,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      96,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Visibility(
                                                        visible: userrole.get(
                                                                    'UserRole') ==
                                                                'user'
                                                            ? false
                                                            : true,
                                                        child: Stack(
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    if (showNotificationDialog ==
                                                                        false) {
                                                                      showNotificationDialog =
                                                                          true;
                                                                    } else {
                                                                      showNotificationDialog =
                                                                          false;
                                                                    }
                                                                  });
                                                                },
                                                                icon: Icon(
                                                                  Icons
                                                                      .notifications,
                                                                  color: AppColors()
                                                                      .maincolor,
                                                                  size: 30,
                                                                )),
                                                            Visibility(
                                                              visible: currentWindow ==
                                                                      'Requests'
                                                                  ? false
                                                                  : newUser ||
                                                                      newSector ||
                                                                      newPtmp ||
                                                                      newp2p ||
                                                                      newlte,
                                                              child: Positioned(
                                                                top: 5,
                                                                left: 4,
                                                                child:
                                                                    Container(
                                                                  width: 15,
                                                                  height: 15,
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          width:
                                                                              1,
                                                                          color: AppColors()
                                                                              .fifthcolor),
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: AppColors()
                                                                          .secondcolor),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 25),
                                                      IconButton(
                                                          onPressed: () {
                                                            if (darkmode.get(
                                                                    'darkmode') ==
                                                                false) {
                                                              setState(() {
                                                                darkmode.put(
                                                                    'darkmode',
                                                                    true);
                                                              });
                                                            } else if (darkmode.get(
                                                                    'darkmode') ==
                                                                true) {
                                                              setState(() {
                                                                darkmode.put(
                                                                    'darkmode',
                                                                    false);
                                                              });
                                                            }
                                                          },
                                                          icon: Icon(
                                                            darkmode.get(
                                                                        'darkmode') ==
                                                                    true
                                                                ? Icons
                                                                    .light_mode_rounded
                                                                : Icons
                                                                    .dark_mode_rounded,
                                                            color: AppColors()
                                                                .secondcolor,
                                                            size: 30,
                                                          )),
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 60),
                                                        child: Image.asset(
                                                          'lib/images/so logo.png',
                                                          height: 100,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Stack(children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                875,
                                                            // height: userrole.get(
                                                            //             'UserRole') ==
                                                            //         'user'
                                                            //     ? 700
                                                            //     : 350,
                                                            decoration: BoxDecoration(
                                                                color: AppColors()
                                                                    .darkwhite,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            42),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              3),
                                                                      blurRadius:
                                                                          10,
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.5))
                                                                ]),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      30.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        gettime(),
                                                                        usersName.get('UsersName') == null ||
                                                                                usersName.get('UsersName') == ''
                                                                            ? StreamBuilder(
                                                                                stream: FirebaseFirestore.instance.collection('Users').doc(user!.uid).snapshots(),
                                                                                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                                                                  if (snapshot.hasData) {
                                                                                    fname = snapshot.data!.get('First Name');
                                                                                    usersName.put('UsersName', fname);
                                                                                    userrole.put('UserRole', snapshot.data!.get('role'));
                                                                                    return Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          'Welcome Back',
                                                                                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: AppColors().secondcolor),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: 10,
                                                                                        ),
                                                                                        Text(
                                                                                          '$fname',
                                                                                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: AppColors().black),
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  }
                                                                                  if (snapshot.hasError) {
                                                                                    return const Center(child: Text('there is Something wrong!'));
                                                                                  }
                                                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                    return const CircularProgressIndicator();
                                                                                  }
                                                                                  return Container();
                                                                                })
                                                                            : Row(
                                                                                children: [
                                                                                  Text(
                                                                                    'Welcome Back',
                                                                                    softWrap: true,
                                                                                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: AppColors().secondcolor),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Text(
                                                                                    usersName.get('UsersName'),
                                                                                    softWrap: true,
                                                                                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: AppColors().black),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                        SizedBox(
                                                                          height:
                                                                              40,
                                                                        ),
                                                                        Container(
                                                                            width:
                                                                                200,
                                                                            height:
                                                                                60,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(28), color: AppColors().secondcolor, boxShadow: [
                                                                              BoxShadow(offset: Offset(0, 3), blurRadius: 10, color: Colors.black.withOpacity(0.5))
                                                                            ]),
                                                                            child: Center(
                                                                              child: TimerBuilder.periodic(
                                                                                Duration(seconds: 1),
                                                                                builder: ((context) {
                                                                                  return Text(
                                                                                    TimeOfDay.now().format(context).toString(),
                                                                                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors().fifthcolor),
                                                                                  );
                                                                                }),
                                                                              ),
                                                                            )),
                                                                        SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              'Hargeisa',
                                                                              style: TextStyle(fontSize: 20, color: AppColors().black.withOpacity(0.5)),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 80,
                                                                            ),
                                                                            Icon(
                                                                              Icons.sunny,
                                                                              color: AppColors().black.withOpacity(0.5),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        temp.get('Tempereture') == null ||
                                                                                temp.get('Tempereture') == ''
                                                                            ? FutureBuilder(
                                                                                future: wf.currentWeatherByCityName('Hargeisa'),
                                                                                builder: (context, snapshot) {
                                                                                  if (snapshot.hasData) {
                                                                                    var tempereture = snapshot.data!.temperature.toString();
                                                                                    temp.put('Tempereture', tempereture);
                                                                                    return Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          tempereture,
                                                                                          softWrap: true,
                                                                                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors().secondcolor),
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  }
                                                                                  if (!snapshot.hasData) {
                                                                                    return Text('something went wrong!');
                                                                                  }
                                                                                  return CircularProgressIndicator();
                                                                                })
                                                                            : Row(
                                                                                children: [
                                                                                  Text(
                                                                                    temp.get('Tempereture'),
                                                                                    softWrap: true,
                                                                                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors().secondcolor),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                      ]),
                                                                  Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              400),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                                offset: Offset(0, 3),
                                                                                blurRadius: 10,
                                                                                color: Colors.black.withOpacity(0.5))
                                                                          ]),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            350,
                                                                        child: ClipRRect(
                                                                            borderRadius: BorderRadius.circular(400),
                                                                            child: Lottie.network(
                                                                              morning!
                                                                                  ? 'https://assets3.lottiefiles.com/packages/lf20_Gpt6Y2.json'
                                                                                  : afternoon!
                                                                                      ? 'https://assets1.lottiefiles.com/packages/lf20_jIuMBG.json'
                                                                                      : evening!
                                                                                          ? 'https://assets7.lottiefiles.com/packages/lf20_jtgztoga.json'
                                                                                          : '',
                                                                            )),
                                                                      ))
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 30,
                                                          ),
                                                          Visibility(
                                                            visible: userrole.get(
                                                                        'UserRole') ==
                                                                    'user'
                                                                ? false
                                                                : true,
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  856,
                                                              height: 432,
                                                              decoration: BoxDecoration(
                                                                  color: AppColors()
                                                                      .fifthcolor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              42),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        offset: Offset(
                                                                            0,
                                                                            3),
                                                                        blurRadius:
                                                                            10,
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.5))
                                                                  ]),
                                                              child: userrole.get(
                                                                          'UserRole') ==
                                                                      'user'
                                                                  ? Text(
                                                                      'You cannot see this')
                                                                  : Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(46.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                'Registered Users',
                                                                                style: TextStyle(fontSize: 21, color: AppColors().black, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              ClipRRect(
                                                                                borderRadius: BorderRadius.circular(17),
                                                                                child: MaterialButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      currentWindow = 'users';
                                                                                    });
                                                                                  },
                                                                                  color: AppColors().secondcolor,
                                                                                  minWidth: 130,
                                                                                  child: Text(
                                                                                    'View All',
                                                                                    style: TextStyle(color: AppColors().fifthcolor),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Divider(
                                                                          height:
                                                                              2,
                                                                          color:
                                                                              AppColors().greycolor,
                                                                        ),
                                                                        Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 46,
                                                                                top: 20,
                                                                                right: 46,
                                                                                bottom: 20),
                                                                            child: Table(
                                                                              children: [
                                                                                TableRow(children: [
                                                                                  Text(
                                                                                    'Full Name',
                                                                                    style: TextStyle(fontSize: 16, color: AppColors().black, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Text(
                                                                                    'Role',
                                                                                    style: TextStyle(fontSize: 16, color: AppColors().black, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Text(
                                                                                    'Email',
                                                                                    style: TextStyle(fontSize: 16, color: AppColors().black, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Text(
                                                                                    'Phone Number',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(fontSize: 16, color: AppColors().black, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ])
                                                                              ],
                                                                            )),
                                                                        Divider(
                                                                          height:
                                                                              2,
                                                                          color:
                                                                              AppColors().greycolor,
                                                                        ),
                                                                        FutureBuilder(
                                                                            future:
                                                                                FirebaseFirestore.instance.collection('Users').get(),
                                                                            builder: (context, snapshot) {
                                                                              if (snapshot.hasData) {
                                                                                return Expanded(
                                                                                  child: ListView.builder(
                                                                                      itemCount: snapshot.data!.docs.length > 5 ? 5 : snapshot.data!.docs.length,
                                                                                      itemBuilder: (context, index) {
                                                                                        var fullname = snapshot.data!.docs[index]['First Name'];
                                                                                        var roles = snapshot.data!.docs[index]['role'];
                                                                                        var emails = snapshot.data!.docs[index]['Email'];
                                                                                        var phonenumber = snapshot.data!.docs[index]['PhoneNumber'];
                                                                                        return Padding(
                                                                                          padding: const EdgeInsets.only(left: 46, top: 10, right: 46, bottom: 5),
                                                                                          child: Table(
                                                                                            children: [
                                                                                              TableRow(children: [
                                                                                                Text(
                                                                                                  '$fullname',
                                                                                                  textAlign: TextAlign.start,
                                                                                                  style: TextStyle(fontSize: 16, color: AppColors().black),
                                                                                                ),
                                                                                                Text(
                                                                                                  '$roles',
                                                                                                  textAlign: TextAlign.start,
                                                                                                  style: TextStyle(fontSize: 16, color: AppColors().black),
                                                                                                ),
                                                                                                Text(
                                                                                                  '$emails',
                                                                                                  textAlign: TextAlign.start,
                                                                                                  style: TextStyle(fontSize: 16, color: AppColors().black),
                                                                                                ),
                                                                                                Text(
                                                                                                  '$phonenumber',
                                                                                                  textAlign: TextAlign.center,
                                                                                                  style: TextStyle(fontSize: 16, color: AppColors().black),
                                                                                                ),
                                                                                              ])
                                                                                            ],
                                                                                          ),
                                                                                        );
                                                                                      }),
                                                                                );
                                                                              }
                                                                              if (snapshot.hasError) {
                                                                                return Center(
                                                                                  child: Text('There is something wrong!'),
                                                                                );
                                                                              }

                                                                              return Center(
                                                                                child: CircularProgressIndicator(),
                                                                              );
                                                                            })
                                                                      ],
                                                                    ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 139,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                1452,
                                                            height: 483,
                                                            decoration: BoxDecoration(
                                                                color: AppColors()
                                                                    .greycolor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            42),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              3),
                                                                      blurRadius:
                                                                          10,
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.5))
                                                                ]),
                                                            child:
                                                                TableCalendar(
                                                              focusedDay:
                                                                  DateTime
                                                                      .now(),
                                                              firstDay:
                                                                  DateTime(
                                                                      2000),
                                                              lastDay: DateTime(
                                                                  3000),
                                                              pageJumpingEnabled:
                                                                  true,
                                                              weekNumbersVisible:
                                                                  false,
                                                              calendarStyle: CalendarStyle(
                                                                  weekendTextStyle: TextStyle(
                                                                      color: AppColors()
                                                                          .maincolor),
                                                                  todayDecoration: BoxDecoration(
                                                                      color: AppColors()
                                                                          .secondcolor,
                                                                      shape: BoxShape
                                                                          .circle)),
                                                              selectedDayPredicate:
                                                                  (day) {
                                                                return isSameDay(
                                                                    _selectedDay,
                                                                    day);
                                                              },
                                                              onDaySelected:
                                                                  (selectedDay,
                                                                      focusedDay) {
                                                                setState(() {
                                                                  _selectedDay =
                                                                      selectedDay;
                                                                  _focusedDay =
                                                                      focusedDay; // update `_focusedDay` here as well
                                                                });
                                                              },
                                                              calendarFormat:
                                                                  _calendarFormat,
                                                              onFormatChanged:
                                                                  (format) {
                                                                setState(() {
                                                                  _calendarFormat =
                                                                      format;
                                                                });
                                                              },
                                                              onPageChanged:
                                                                  (focusedDay) {
                                                                _focusedDay =
                                                                    focusedDay;
                                                              },
                                                            )),
                                                        SizedBox(
                                                          height: 120,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              1452,
                                                          height: 206,
                                                          decoration: BoxDecoration(
                                                              color: AppColors()
                                                                  .greycolor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          35),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            3),
                                                                    blurRadius:
                                                                        10,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.5))
                                                              ]),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Text(
                                                                    'Personal Information',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            21,
                                                                        color: AppColors()
                                                                            .black
                                                                            .withOpacity(
                                                                                0.5),
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 40,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      const Text(
                                                                        'Full Name',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      usersName.get('UsersName') == null ||
                                                                              usersName.get('UsersName') == ''
                                                                          ? StreamBuilder(
                                                                              stream: FirebaseFirestore.instance.collection('Users').doc(user!.uid).snapshots(),
                                                                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                                                                if (snapshot.hasData) {
                                                                                  return Text(
                                                                                    snapshot.data!.get('First Name'),
                                                                                    style: const TextStyle(
                                                                                      fontSize: 17,
                                                                                    ),
                                                                                  );
                                                                                }
                                                                                return CircularProgressIndicator();
                                                                              })
                                                                          : Text(
                                                                              usersName.get('UsersName'),
                                                                              style: const TextStyle(
                                                                                fontSize: 17,
                                                                              ),
                                                                            ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      const Text(
                                                                        'Role',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      userrole.get('UserRole') == null ||
                                                                              userrole.get('UserRole') == ''
                                                                          ? StreamBuilder(
                                                                              stream: FirebaseFirestore.instance.collection('Users').doc(user!.uid).snapshots(),
                                                                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                                                                if (snapshot.hasData) {
                                                                                  return Text(
                                                                                    snapshot.data!.get('role'),
                                                                                    style: const TextStyle(
                                                                                      fontSize: 17,
                                                                                    ),
                                                                                  );
                                                                                }
                                                                                return CircularProgressIndicator();
                                                                              })
                                                                          : Text(
                                                                              userrole.get('UserRole'),
                                                                              style: const TextStyle(
                                                                                fontSize: 17,
                                                                              ),
                                                                            ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Visibility(
                                                  visible:
                                                      showNotificationDialog,
                                                  child: Positioned(
                                                    right: 25,
                                                    child: Container(
                                                      height: 300,
                                                      width: 350,
                                                      decoration: BoxDecoration(
                                                          color: AppColors()
                                                              .darkwhite,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ListView(
                                                          children: [
                                                            Visibility(
                                                                visible: newUser == false &&
                                                                        newSector ==
                                                                            false &&
                                                                        newPtmp ==
                                                                            false &&
                                                                        newp2p ==
                                                                            false &&
                                                                        newlte ==
                                                                            false
                                                                    ? true
                                                                    : false,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                  child: Center(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: const [
                                                                        Text(
                                                                            'There is no new notifications!'),
                                                                        SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        Icon(Icons
                                                                            .check_box)
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )),
                                                            Visibility(
                                                              visible: newUser,
                                                              child: ListTile(
                                                                  leading: Icon(
                                                                    Icons
                                                                        .supervised_user_circle,
                                                                    color: AppColors()
                                                                        .secondcolor,
                                                                  ),
                                                                  title:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                      'There is a new user registration request!',
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
                                                                    ),
                                                                  ),
                                                                  subtitle: Buttons(
                                                                      buttonColor: AppColors().secondcolor,
                                                                      buttonText: 'Go to Request',
                                                                      ontap: () {
                                                                        setState(
                                                                            () {
                                                                          if (newUser ==
                                                                              true) {
                                                                            newUser =
                                                                                false;
                                                                            showNotificationDialog =
                                                                                false;
                                                                          }
                                                                          currentWindow =
                                                                              'Requests';
                                                                        });
                                                                      })),
                                                            ),
                                                            Visibility(
                                                              visible:
                                                                  newSector,
                                                              child: ListTile(
                                                                  leading: Icon(
                                                                    Icons
                                                                        .cell_tower,
                                                                    color: AppColors()
                                                                        .secondcolor,
                                                                  ),
                                                                  title:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                      'There is a new Sector Deletion request!',
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
                                                                    ),
                                                                  ),
                                                                  subtitle: Buttons(
                                                                      buttonColor: AppColors().secondcolor,
                                                                      buttonText: 'Go to Request',
                                                                      ontap: () {
                                                                        setState(
                                                                            () {
                                                                          if (newSector ==
                                                                              true) {
                                                                            newSector =
                                                                                false;
                                                                            showNotificationDialog =
                                                                                false;
                                                                          }
                                                                          currentWindow =
                                                                              'Requests';
                                                                        });
                                                                      })),
                                                            ),
                                                            Visibility(
                                                              visible: newPtmp ==
                                                                          true ||
                                                                      newlte ==
                                                                          true ||
                                                                      newp2p ==
                                                                          true
                                                                  ? true
                                                                  : false,
                                                              child: ListTile(
                                                                  leading: Icon(
                                                                    Icons
                                                                        .cell_tower,
                                                                    color: AppColors()
                                                                        .secondcolor,
                                                                  ),
                                                                  title:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                      'There is a new Site Deletion request!',
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().black),
                                                                    ),
                                                                  ),
                                                                  subtitle: Buttons(
                                                                      buttonColor: AppColors().secondcolor,
                                                                      buttonText: 'Go to Request',
                                                                      ontap: () {
                                                                        setState(
                                                                            () {
                                                                          if (newPtmp == true ||
                                                                              newp2p == true ||
                                                                              newlte == true) {
                                                                            newPtmp =
                                                                                false;
                                                                            newp2p =
                                                                                false;
                                                                            newlte =
                                                                                false;
                                                                            showNotificationDialog =
                                                                                false;
                                                                          }
                                                                          currentWindow =
                                                                              'Requests';
                                                                        });
                                                                      })),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ])
                                            ],
                                          ),
                                        )
                                      : SizedBox()
            ],
          )),
    );
  }

  gettime() {
    var hour = TimeOfDay.now().hour;

    if (hour < 12) {
      morning = true;
      return Row(
        children: [
          Text(
            'Good Morning!',
            style: TextStyle(
                fontSize: 49,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: AppColors().black),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      );
    } else if (hour < 18) {
      afternoon = true;
      morning = false;
      return Row(
        children: [
          Text(
            'Good Afternoon!',
            style: TextStyle(
                fontSize: 49,
                fontWeight: FontWeight.bold,
                color: AppColors().black),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      );
    } else {
      evening = true;
      morning = false;
      afternoon = false;
      return Row(
        children: [
          Text(
            'Good Evening!',
            style: TextStyle(
                fontSize: 49,
                fontWeight: FontWeight.bold,
                color: AppColors().black),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      );
    }
  }

  Future<void> moreoptions(var uid) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Dialog(
                    child: Column(
                      children: [
                        TextButton(
                            onPressed: () {}, child: Text('Disable User')),
                        //TextButton(onPressed: () {}, child: Text('Delete User'))
                      ],
                    ),
                  )));
        });
  }
}
