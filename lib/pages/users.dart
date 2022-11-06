import 'package:cloud_firestore/cloud_firestore.dart';
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
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Table(
                                children: [
                                  TableRow(children: [
                                    SelectableText(
                                      '$firstname' + ' $secondname',
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
                                    
                                    IconButton(
                                        onPressed: () {},
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

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                })
          ],
        ),
      ),
    );
  }
}
