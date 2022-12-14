import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/userDatabase/userModel.dart';
import 'package:somcable_web_app/utils/Buttons.dart';

class Messenger extends StatefulWidget {
  const Messenger({Key? key}) : super(key: key);

  @override
  State<Messenger> createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
  TextEditingController messageController = TextEditingController();
  var namebox = Hive.box('UsersName');
  var userrole = Hive.box('Role');
  var timer;
  var timers;
  var istimeout = false;
  var streamMessages;
  List randomizedColors = [
    AppColors().maincolor,
    AppColors().secondcolor,
    AppColors().thirdcolor,
    AppColors().greycolor,
    Colors.blue,
    Colors.purple,
    Colors.deepOrange,
    Colors.greenAccent
  ];
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }

  @override
  void initState() {
    streamMessages =
        FirebaseFirestore.instance.collection('Messages').snapshots();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 117,
            height: 100,
            decoration: BoxDecoration(
                color: AppColors().fifthcolor,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.5))
                ]),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Image.asset('lib/images/so logo.png')),
                      SizedBox(
                        width: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rank Team',
                              style: TextStyle(
                                  fontSize: 40,
                                  color: AppColors().maincolor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Messenger Group Chat',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors().greycolor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Visibility(
                      visible: userrole.get('UserRole') == 'databaseAdmin'
                          ? true
                          : false,
                      child: Container(
                        width: 120,
                        child: Buttons(
                          buttonColor: AppColors().maincolor,
                            buttonText: 'Delete Chat',
                            ontap: () {
                              try {
                    FirebaseFirestore.instance
                          .collection('Messages')
                          .get()
                          .then((value) {
                        for (DocumentSnapshot ds in value.docs) {
                          ds.reference.delete();
                        }
                    });
                    } on Exception catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: AppColors().thirdcolor,
                              content: Text(e.toString(),
                                  style: TextStyle(
                                    color: AppColors().fifthcolor,
                                  ))));
                    }
                            }),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width - 117,
            child: StreamBuilder(
                stream: streamMessages,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '????',
                          style: TextStyle(fontSize: 25),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Send a message to say Hi',
                          style: TextStyle(
                              fontSize: 25, color: AppColors().maincolor),
                        ),
                      ],
                    );
                  }

                  if (snapshot.hasData) {
                    return GroupedListView(
                      reverse: true,
                      order: GroupedListOrder.DESC,
                      elements: snapshot.data!.docs,
                      groupBy: ((element) => element['DateTime']),
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: index.get('sentBy') ==
                                  namebox.get('UsersName')
                              ? MainAxisAlignment.end
                              : index.get('sentBy') != namebox.get('UsersName')
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.center,
                          children: [
                            index.get('sentBy') != namebox.get('UsersName')
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: randomizedColors[Random()
                                            .nextInt(randomizedColors.length)],
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.person,
                                        size: 40,
                                        color: AppColors().fifthcolor,
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: index.get('sentBy') ==
                                        namebox.get('UsersName')
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      index.get('sentBy'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors().black),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: index.get('sentBy') ==
                                              namebox.get('UsersName')
                                          ? AppColors().maincolor
                                          : AppColors().greycolor,
                                      borderRadius: index.get('sentBy') ==
                                              namebox.get('UsersName')
                                          ? const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                              topRight: Radius.circular(0))
                                          : const BorderRadius.only(
                                              topLeft: Radius.circular(0),
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 3),
                                            blurRadius: 6,
                                            color:
                                                Colors.black.withOpacity(0.5))
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: SelectableText(
                                        '${index.get('Message')}',
                                        style: TextStyle(
                                            color: index.get('sentBy') ==
                                                    namebox.get('UsersName')
                                                ? AppColors().fifthcolor
                                                : AppColors().black,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            index.get('sentBy') == namebox.get('UsersName')
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: randomizedColors[Random()
                                            .nextInt(randomizedColors.length)],
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.person,
                                        size: 40,
                                        color: AppColors().fifthcolor,
                                      ),
                                    ),
                                  )
                                : SizedBox()
                          ],
                        );
                      },
                      groupHeaderBuilder: (element) => SizedBox(),
                      groupSeparatorBuilder: (value) => SizedBox(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'There is something went wrong!',
                        style: TextStyle(
                            fontSize: 35, color: AppColors().maincolor),
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 230,
                  child: TextField(
                    style: TextStyle(color: AppColors().secondcolor),
                    controller: messageController,
                    decoration: InputDecoration(
                        filled: false,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(
                              width: 2,
                              color: AppColors().maincolor,
                            )),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(
                              width: 2,
                              color: AppColors().maincolor,
                            )),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(
                              width: 2,
                              color: AppColors().maincolor,
                            ))),
                    onSubmitted: (value) {
                      setState(() {
                        sendingmessage();
                        messageController.clear();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: IconButton(
                      onPressed: () {
                        sendingmessage();
                        messageController.clear();
                      },
                      icon: Icon(
                        Icons.send,
                        size: 50,
                        color: AppColors().maincolor,
                      )),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  sendingmessage() async {
    try {
      if (messageController.text.isNotEmpty) {
        String? docid =
            FirebaseFirestore.instance.collection('Messages').doc().id;
        FirebaseFirestore.instance.collection('Messages').doc(docid).set({
          'SentByMe': FirebaseAuth.instance.currentUser!.uid ==
                  FirebaseAuth.instance.currentUser!.uid
              ? true
              : false,
          'Sender': FirebaseAuth.instance.currentUser!.uid,
          'Message': messageController.text,
          'DateTime': DateTime.now(),
          'sentBy': namebox.get('UsersName'),
          'TimerToDelete': DateTime.now().add(Duration(hours: 24)),
          'doc': docid
        });
      }
    } on Exception catch (e) {
      // TODO
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors().thirdcolor,
          content: Text(e.toString(),
              style: TextStyle(
                color: AppColors().fifthcolor,
              ))));
    }
  }
}
