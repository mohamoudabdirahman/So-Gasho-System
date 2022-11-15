import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:somcable_web_app/colors/Colors.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Container(
        width: 1300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Table(
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
                stream:
                    FirebaseFirestore.instance.collection('Users').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    print('I have data');
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length > 5
                              ? 5
                              : snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var firstname =
                                snapshot.data!.docs[index]['First Name'];
                            var secondname =
                                snapshot.data!.docs[index]['Last Name'];
                            var roles = snapshot.data!.docs[index]['role'];
                            var emails = snapshot.data!.docs[index]['Email'];
                            var phonenumber =
                                snapshot.data!.docs[index]['PhoneNumber'];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Table(
                                children: [
                                  TableRow(children: [
                                    SelectableText(
                                      '$firstname' ' $secondname',
                                      autofocus: true,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors().black),
                                    ),
                                    SelectableText(
                                      '$roles',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors().black),
                                    ),
                                    SelectableText(
                                      '$emails',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors().black),
                                    ),
                                    SelectableText(
                                      '$phonenumber',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors().black),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          showoptiondialog(index, snapshot);
                                        },
                                        icon: Icon(
                                          Icons.more_horiz,
                                          size: 40,
                                          color: AppColors().secondcolor,
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
                      child: Text('There is something wrong!'),
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                })
          ],
        ),
      ),
    );
  }

  showoptiondialog(index, snapshot) {
    showDialog(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
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
                height: 80,
                width: 100,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors().greycolor)),
                          onPressed: () {
                            disableuser(index, snapshot);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 48, right: 48),
                            child: Text(
                              'Disable User',
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
                            deleteuser(index, snapshot);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 50, right: 50),
                            child: Text('Delete User',
                                style: TextStyle(color: AppColors().black)),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void deleteuser(index, snapshot) {
    try {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot.data!.docs[index]['uid'])
          .delete();
    } catch (e) {
      print(e);
    }
  }

  void disableuser(index, snapshot) {
    try {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot.data!.docs[index]['uid'])
          .update(({'Isdisabled': true}));
    } catch (e) {
      print(e);
    }
  }
}
