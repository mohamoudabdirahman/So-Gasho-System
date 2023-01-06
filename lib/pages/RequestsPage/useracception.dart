import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:somcable_web_app/colors/Colors.dart';

class UserAcceptance extends StatefulWidget {
  const UserAcceptance({Key? key}) : super(key: key);

  @override
  State<UserAcceptance> createState() => _UserAcceptanceState();
}

class _UserAcceptanceState extends State<UserAcceptance> {
  var userStream;

  @override
  void initState() {
    userStream = FirebaseFirestore.instance.collection('Users').snapshots();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 30,
          ),
          child: Table(
            children: [
              TableRow(children: [
                Text(
                  'Full Name',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColors().black,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Role',
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColors().secondcolor,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Email',
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColors().black,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
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
          height: 5,
        ),
        Divider(),
        SizedBox(
          height: 15,
        ),
        StreamBuilder(
            stream: userStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'No user registration request yet!',
                    style: TextStyle(color: AppColors().black),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                  'Something went wrong!',
                  style: TextStyle(color: AppColors().black),
                ));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: SizedBox(
                        width: 35,
                        height: 35,
                        child: LoadingIndicator(
                            indicatorType: Indicator.ballPulse)));
              }
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      var isverified = snapshot.data!.docs[index]['IsVerified'];
                      if (snapshot.data!.docs[index]['IsApproved'] ==
                          'requested') {
                        var userid = snapshot.data!.docs[index]['uid'];
                        return Table(
                          children: [
                            TableRow(children: [
                              SelectableText(
                                '${snapshot.data!.docs[index]['First Name']} ${snapshot.data!.docs[index]['Last Name']}',
                                style: TextStyle(color: AppColors().black),
                                textAlign: TextAlign.center,
                              ),
                              SelectableText(
                                snapshot.data!.docs[index]['role'],
                                style:
                                    TextStyle(color: AppColors().secondcolor),
                                textAlign: TextAlign.center,
                              ),
                              SelectableText(
                                snapshot.data!.docs[index]['Email'],
                                style: TextStyle(color: AppColors().black),
                                textAlign: TextAlign.center,
                              ),
                              SelectableText(
                                snapshot.data!.docs[index]['PhoneNumber'],
                                style: TextStyle(color: AppColors().black),
                                textAlign: TextAlign.center,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        acceptUser(userid,isverified);
                                      },
                                      icon: Icon(Icons.check_box,
                                          color: Colors.green)),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        rejectUser(userid);
                                      },
                                      icon:
                                          Icon(Icons.cancel, color: Colors.red))
                                ],
                              )
                            ])
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }));
              }
              return Container();
            })
      ],
    );
  }

  void acceptUser(userID, isverified) {
    if (isverified == true) {
      try {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(userID)
            .update({'IsApproved': 'accepted'});
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
          content: Text(
              "This User has not verified his Email Yet! Please wait until this user's is verified",
              style: TextStyle(
                color: AppColors().fifthcolor,
              ))));
    }
  }

  void rejectUser(userID) {
    try {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(userID)
          .update({'IsApproved': 'Rejected'});
          
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors().thirdcolor,
          content: Text(e.toString(),
              style: TextStyle(
                color: AppColors().fifthcolor,
              ))));
    }
  }
}
