import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/utils/Buttons.dart';
import 'package:url_launcher/url_launcher.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  TextEditingController controller = TextEditingController();
  bool searchbuttontapped = false;
  String searchedName = '';
  var rolevalue = false;
  var userolevalue = false;
  var roles = ['User', 'Admin'];
  var _groupValue = -1;
  var userbox = Hive.box('Role');
  final Uri _url = Uri.parse(
      'https://www.careerexplorer.com/careers/database-administrator/');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 196,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SearchBarAnimation(
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
              onPressButton: (isSearchBarOpens) {},
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
            Expanded(
              child: Stack(
                children: [
                  searchbuttontapped == false
                      ? SingleChildScrollView(
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              children: [
                                Table(
                                  children: [
                                    TableRow(children: [
                                      Text(
                                        'Full Name',
                                        textAlign: TextAlign.start,
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
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors().black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Options',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors().black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Divider(
                                  height: 2,
                                  color: AppColors().greycolor,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('Users')
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        return Expanded(
                                          child: ListView.builder(
                                              itemCount:
                                                  snapshot.data!.docs.length > 5
                                                      ? 5
                                                      : snapshot
                                                          .data!.docs.length,
                                              itemBuilder: (context, index) {
                                                var firstname = snapshot.data!
                                                    .docs[index]['First Name'];
                                                var secondname = snapshot.data!
                                                    .docs[index]['Last Name'];
                                                var roles = snapshot
                                                    .data!.docs[index]['role'];
                                                var emails = snapshot
                                                    .data!.docs[index]['Email'];
                                                var phonenumber = snapshot.data!
                                                    .docs[index]['PhoneNumber'];
                                                var isdisabled = snapshot.data!
                                                    .docs[index]['Isdisabled'];
                                                var userId = snapshot
                                                    .data!.docs[index]['uid'];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Table(
                                                    children: [
                                                      TableRow(children: [
                                                        SelectableText(
                                                          '$firstname'
                                                          ' $secondname',
                                                          autofocus: true,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: isdisabled ==
                                                                      true
                                                                  ? AppColors()
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5)
                                                                  : AppColors()
                                                                      .black),
                                                        ),
                                                        SelectableText(
                                                          '$roles',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: isdisabled ==
                                                                      true
                                                                  ? AppColors()
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5)
                                                                  : AppColors()
                                                                      .black),
                                                        ),
                                                        SelectableText(
                                                          '$emails',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: isdisabled ==
                                                                      true
                                                                  ? AppColors()
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5)
                                                                  : AppColors()
                                                                      .black),
                                                        ),
                                                        SelectableText(
                                                          '$phonenumber',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: isdisabled ==
                                                                      true
                                                                  ? AppColors()
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5)
                                                                  : AppColors()
                                                                      .black),
                                                        ),
                                                        roles == 'databaseAdmin'
                                                            ? IconButton(
                                                                onPressed: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return AlertDialog(
                                                                          backgroundColor:
                                                                              AppColors().fifthcolor,
                                                                          title:
                                                                               Text('Warning!',style: TextStyle(color: AppColors().black),),
                                                                          content:
                                                                              Text(
                                                                            'You are not able to delete or disable a database admin because a database admin is the core of the system!',
                                                                            style:
                                                                                TextStyle(color: AppColors().black),
                                                                          ),
                                                                          actions: [
                                                                          
                                                                            Container(
                                                                              width: 100,
                                                                              child: Buttons(
                                                                                  buttonColor: AppColors().secondcolor.withOpacity(0.6),
                                                                                  buttonText: 'cancel',
                                                                                  ontap: () {
                                                                                    Navigator.of(context).pop();
                                                                                  }),
                                                                            ),
                                                                                  Buttons(
                                                                                buttonColor: AppColors().maincolor,
                                                                                buttonText: 'Learn More',
                                                                                ontap: () {
                                                                                  launchUrl(_url);
                                                                                }),
                                                                          ],
                                                                        );
                                                                      });
                                                                },
                                                                icon: Icon(
                                                                  Icons.warning,
                                                                  color: Colors
                                                                      .red,
                                                                ))
                                                            : IconButton(
                                                                onPressed: () {
                                                                  showoptiondialog(
                                                                      index,
                                                                      snapshot,
                                                                      isdisabled,
                                                                      roles,
                                                                      userId);
                                                                },
                                                                icon: Icon(
                                                                  Icons
                                                                      .more_horiz,
                                                                  size: 40,
                                                                  color: AppColors()
                                                                      .secondcolor,
                                                                ))
                                                      ])
                                                    ],
                                                  ),
                                                );
                                              }),
                                        );
                                      }
                                      if (snapshot.hasError) {
                                        return Center(
                                          child:
                                              Text('There is something wrong!'),
                                        );
                                      }

                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    })
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                  searchbuttontapped == true
                      ? suggestionCard()
                      : Opacity(opacity: 0, child: SizedBox())
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget suggestionCard() {
    return Card(
        shape: RoundedRectangleBorder(),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Users').snapshots(),
            builder:
                ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (searchedName.isEmpty) {
                  return const Center(
                    child: Text('Please Search Users!'),
                  );
                }
                var suggestions = snapshot.data?.docs;
                return ListView.builder(
                    itemCount: suggestions!.length,
                    itemBuilder: ((context, index) {
                      var data = snapshot.data?.docs[index].data()
                          as Map<String, dynamic>;

                      if (data['First Name']
                          .toString()
                          .toLowerCase()
                          .startsWith(searchedName.toLowerCase())) {
                        var name1 = data['First Name'];
                        var name2 = data['Last Name'];
                        var role = data['role'];
                        var email = data['Email'];
                        var phonenumber = data['PhoneNumber'];
                        //var userId = data['uid'];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors().fifthcolor,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 4),
                                        blurRadius: 3,
                                        spreadRadius: 2,
                                        color:
                                            AppColors().black.withOpacity(0.1))
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${name1}' '${name2}'),
                                    Text(role),
                                    Text(email),
                                    Text(phonenumber)
                                  ],
                                ),
                              )),
                        );
                      }
                      return Container();
                    }));
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            })));
  }

  showoptiondialog(index, snapshot, isdisabled, role, userid) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                width: 180,
                height: 300,
                child: AlertDialog(
                  backgroundColor: AppColors().secondcolor,
                  actions: [
                    Align(
                      alignment: Alignment.center,
                      child: MaterialButton(
                        color: AppColors().maincolor,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'cancel',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors().fifthcolor),
                        ),
                      ),
                    )
                  ],
                  content: Container(
                    height: 260,
                    width: 100,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'This user Is ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: AppColors().fifthcolor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          role == 'user'
                                              ? 'Normal $role'
                                              : role,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                CheckboxListTile(
                                  activeColor: AppColors().maincolor,
                                  title: Text(
                                    "Admin",
                                    style: TextStyle(
                                        color: AppColors().fifthcolor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  value: rolevalue,
                                  onChanged: (val) {
                                    if (rolevalue == false) {
                                      try {
                                        FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(userid)
                                            .update({'role': 'admin'});
                                      } on Exception catch (e) {
                                        return;
                                      }
                                      setState(() {
                                        rolevalue = val!;
                                      });
                                      setState(() {
                                        userbox.put('UserRole', 'admin');
                                      });
                                    }
                                    if (rolevalue == true) {
                                      setState(() {
                                        rolevalue = val!;
                                      });
                                    }
                                    if (userolevalue == true) {
                                      try {
                                        FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(userid)
                                            .update({'role': 'user'});
                                      } on Exception catch (e) {
                                        return;
                                      }
                                      setState(() {
                                        rolevalue = false;
                                      });
                                      setState(() {
                                        userbox.put('UserRole', 'user');
                                      });
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                CheckboxListTile(
                                  title: Text("User"),
                                  value: userolevalue,
                                  onChanged: (val) {
                                    if (userolevalue == false) {
                                      try {
                                        FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(userid)
                                            .update({'role': 'user'});
                                      } on Exception catch (e) {
                                        return;
                                      }
                                      setState(() {
                                        userolevalue = val!;
                                      });
                                      setState(() {
                                        userbox.put('UserRole', role);
                                      });
                                    }
                                    if (userolevalue == true) {
                                      setState(() {
                                        userolevalue = val!;
                                      });
                                    }
                                    if (rolevalue == true) {
                                      try {
                                        FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(userid)
                                            .update({'role': 'admin'});
                                      } on Exception catch (e) {
                                        return;
                                      }
                                      setState(() {
                                        userolevalue = false;
                                      });
                                      setState(() {
                                        userbox.put('UserRole', role);
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      AppColors().greycolor)),
                              onPressed: () {
                                disableuser(index, snapshot, isdisabled);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 48, right: 48),
                                child: Text(
                                  isdisabled == true
                                      ? 'Enable User'
                                      : 'Disable User',
                                  style: TextStyle(color: AppColors().black),
                                ),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    AppColors().greycolor),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                deleteuser(index, snapshot);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 50, right: 50),
                                child: Text('Delete User',
                                    style: TextStyle(color: AppColors().black)),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  void deleteuser(index, snapshot) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      desc: 'Do you really want to delete this user?',
      btnOk: MaterialButton(
        color: AppColors().maincolor,
        onPressed: () {
          try {
            FirebaseFirestore.instance
                .collection('Users')
                .doc(snapshot.data!.docs[index]['uid'])
                .delete();
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
    )..show();
  }

  void disableuser(index, snapshot, isdisabled) {
    try {
      if (isdisabled == true) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(snapshot.data!.docs[index]['uid'])
            .update(({'Isdisabled': false}));
      } else {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(snapshot.data!.docs[index]['uid'])
            .update(({'Isdisabled': true}));
      }

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

  DropdownMenuItem<String> builddropdown(String item) {
    return DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
              color: AppColors().fifthcolor, fontWeight: FontWeight.bold),
        ));
  }
}
