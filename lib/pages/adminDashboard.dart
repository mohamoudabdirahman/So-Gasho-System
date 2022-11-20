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
import 'package:somcable_web_app/pages/requests.dart';
import 'package:somcable_web_app/pages/settings.dart';
import 'package:somcable_web_app/pages/sites.dart';
import 'package:somcable_web_app/pages/users.dart';
import 'package:somcable_web_app/userDatabase/userModel.dart';
import 'package:somcable_web_app/utils/Navigation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:weather/weather.dart';

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

  //var icon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (darkmode.get('darkmode') == null) {
      setState(() {
        darkmode.put('darkmode', false);
      });
    }
    countdownTimer();
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
                width: MediaQuery.of(context).size.width / 6,
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
                            height: 150,
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
                            navigationtitle: 'Dashboard',
                          ),
                          userrole.get('UserRole') == 'user' ? SizedBox():
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
                            navigationIcon: Icons.request_quote,
                            navigationtitle: 'Requests',
                          ),
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
                            navigationtitle: 'Sites',
                          ),
                          NavigationButtons(
                            backcolor: currentWindow == 'messenger'
                                ? AppColors().secondcolor
                                : Colors.transparent,
                            onpressed: () {
                              widget.iswidgetvisible = true;
                              setState(() {
                                currentWindow = 'messenger';
                              });
                            },
                            navigationIcon: Icons.message,
                            navigationtitle: 'Messages',
                          ),
                          userrole.get('UserRole') == 'user'?SizedBox():
                          NavigationButtons(
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
                            navigationtitle: 'Users',
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
                            navigationtitle: 'Settings',
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
                                      ? Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  320 / 1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
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
                                                        const EdgeInsets.only(
                                                            right: 60),
                                                    child: Image.asset(
                                                      'lib/images/so logo.png',
                                                      height: 100,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              875,
                                                      height: 368,
                                                      decoration: BoxDecoration(
                                                          color: AppColors()
                                                              .darkwhite,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(42),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset: Offset(
                                                                    0, 3),
                                                                blurRadius: 10,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5))
                                                          ]),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(30.0),
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
                                                                  usersName.get('UsersName') ==
                                                                              null ||
                                                                          usersName.get('UsersName') ==
                                                                              ''
                                                                      ? StreamBuilder(
                                                                          stream: FirebaseFirestore
                                                                              .instance
                                                                              .collection('Users')
                                                                              .doc(user!.uid)
                                                                              .snapshots(),
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
                                                                              print('there is an error');
                                                                            }
                                                                            if (snapshot.connectionState ==
                                                                                ConnectionState.waiting) {
                                                                              print('loading');
                                                                            }
                                                                            return const CircularProgressIndicator();
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
                                                                    height: 40,
                                                                  ),
                                                                  Container(
                                                                      width:
                                                                          200,
                                                                      height:
                                                                          60,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              28),
                                                                          color: AppColors()
                                                                              .secondcolor,
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                                offset: Offset(0, 3),
                                                                                blurRadius: 10,
                                                                                color: Colors.black.withOpacity(0.5))
                                                                          ]),
                                                                      child:
                                                                          Center(
                                                                        child: TimerBuilder
                                                                            .periodic(
                                                                          Duration(
                                                                              seconds: 1),
                                                                          builder:
                                                                              ((context) {
                                                                            return Text(
                                                                              TimeOfDay.now().format(context).toString(),
                                                                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors().fifthcolor),
                                                                            );
                                                                          }),
                                                                        ),
                                                                      )),
                                                                  SizedBox(
                                                                    height: 15,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        'Hargeisa',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                AppColors().black.withOpacity(0.5)),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            80,
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .sunny,
                                                                        color: AppColors()
                                                                            .black
                                                                            .withOpacity(0.5),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  temp.get('Tempereture') ==
                                                                              null ||
                                                                          temp.get('Tempereture') ==
                                                                              ''
                                                                      ? FutureBuilder(
                                                                          future: wf.currentWeatherByCityName(
                                                                              'Hargeisa'),
                                                                          builder:
                                                                              (context, snapshot) {
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
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            400),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          offset: Offset(0,
                                                                              3),
                                                                          blurRadius:
                                                                              10,
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.5))
                                                                    ]),
                                                                child:
                                                                    Container(
                                                                  height: 400,
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
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      width: 1064,
                                                      height: 432,
                                                      decoration: BoxDecoration(
                                                          color: AppColors()
                                                              .fifthcolor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(42),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset: Offset(
                                                                    0, 3),
                                                                blurRadius: 10,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5))
                                                          ]),
                                                      child: 
                                                      userrole.get('UserRole') == 'user'? Text('You cannot see this'):
                                                      Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(46.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  'Registered Users',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          21,
                                                                      color: AppColors()
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              17),
                                                                  child:
                                                                      MaterialButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        currentWindow =
                                                                            'users';
                                                                      });
                                                                    },
                                                                    color: AppColors()
                                                                        .secondcolor,
                                                                    minWidth:
                                                                        130,
                                                                    child: Text(
                                                                      'View All',
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors().fifthcolor),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Divider(
                                                            height: 2,
                                                            color: AppColors()
                                                                .greycolor,
                                                          ),
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 46,
                                                                      top: 20,
                                                                      right: 46,
                                                                      bottom:
                                                                          20),
                                                              child: Table(
                                                                children: [
                                                                  TableRow(
                                                                      children: [
                                                                        Text(
                                                                          'Full Name',
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              color: AppColors().black,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        Text(
                                                                          'Role',
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              color: AppColors().black,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        Text(
                                                                          'Email',
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              color: AppColors().black,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        Text(
                                                                          'Phone Number',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              color: AppColors().black,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ])
                                                                ],
                                                              )),
                                                          Divider(
                                                            height: 2,
                                                            color: AppColors()
                                                                .greycolor,
                                                          ),
                                                          StreamBuilder(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Users')
                                                                  .snapshots(),
                                                              builder: (BuildContext
                                                                      context,
                                                                  AsyncSnapshot<
                                                                          QuerySnapshot>
                                                                      snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  print(
                                                                      'I have data');
                                                                  return Expanded(
                                                                    child: ListView
                                                                        .builder(
                                                                            itemCount: snapshot.data!.docs.length > 5
                                                                                ? 5
                                                                                : snapshot.data!.docs.length,
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
                                                                if (snapshot
                                                                    .hasError) {
                                                                  return Center(
                                                                    child: Text(
                                                                        'There is something wrong!'),
                                                                  );
                                                                }

                                                                return Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                );
                                                              })
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                        width: 468,
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
                                                                          0, 3),
                                                                  blurRadius:
                                                                      10,
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5))
                                                            ]),
                                                        child: TableCalendar(
                                                          focusedDay:
                                                              DateTime.now(),
                                                          firstDay:
                                                              DateTime(2000),
                                                          lastDay:
                                                              DateTime(3000),
                                                          pageJumpingEnabled:
                                                              true,
                                                          weekNumbersVisible:
                                                              false,
                                                          calendarStyle: CalendarStyle(
                                                              weekendTextStyle:
                                                                  TextStyle(
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
                                                      width: 468,
                                                      height: 206,
                                                      decoration: BoxDecoration(
                                                          color: AppColors()
                                                              .greycolor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(35),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset: Offset(
                                                                    0, 3),
                                                                blurRadius: 10,
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
                                                                      .all(8.0),
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
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 40,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'Full Name',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  usersName.get('UsersName') ==
                                                                              null ||
                                                                          usersName.get('UsersName') ==
                                                                              ''
                                                                      ? StreamBuilder(
                                                                          stream: FirebaseFirestore
                                                                              .instance
                                                                              .collection('Users')
                                                                              .doc(user!.uid)
                                                                              .snapshots(),
                                                                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                                                            if (snapshot.hasData) {
                                                                              return Text(
                                                                                snapshot.data!.get('First Name'),
                                                                                style: TextStyle(
                                                                                  fontSize: 17,
                                                                                ),
                                                                              );
                                                                            }
                                                                            return CircularProgressIndicator();
                                                                          })
                                                                      : Text(
                                                                          usersName
                                                                              .get('UsersName'),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                17,
                                                                          ),
                                                                        ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'Role',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  userrole.get('UserRole') ==
                                                                              null ||
                                                                          userrole.get('UserRole') ==
                                                                              ''
                                                                      ? StreamBuilder(
                                                                          stream: FirebaseFirestore
                                                                              .instance
                                                                              .collection('Users')
                                                                              .doc(user!.uid)
                                                                              .snapshots(),
                                                                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                                                            if (snapshot.hasData) {
                                                                              return Text(
                                                                                snapshot.data!.get('role'),
                                                                                style: TextStyle(
                                                                                  fontSize: 17,
                                                                                ),
                                                                              );
                                                                            }
                                                                            return CircularProgressIndicator();
                                                                          })
                                                                      : Text(
                                                                          userrole
                                                                              .get('UserRole'),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                17,
                                                                          ),
                                                                        ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
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
