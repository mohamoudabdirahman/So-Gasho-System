import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? uid;
  String? firstname;
  String? lastname;
  String? email;
  String? phonenumber;
  String? password;
  String? role;
  bool? isdisabled = false;
  FirebaseAuth user = FirebaseAuth.instance;

  UserModel(
      {this.uid,
      this.firstname,
      this.lastname,
      this.email,
      this.phonenumber,
      this.password,
      this.role,
      this.isdisabled});

  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map[FirebaseAuth.instance.currentUser!.uid],
        firstname: map['First Name'],
        lastname: map['Last Name'],
        email: map['Email'],
        phonenumber: map['PhoneNumber'],
        password: map['password'],
        role: map['role'],
        isdisabled: map ['Isdisabled']);
  }

  Map<String, dynamic> tomap() {
    return {
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'First Name': firstname,
      'Last Name': lastname,
      'Email': email,
      'PhoneNumber': phonenumber,
      'password': password,
      'role': role,
      'Isdisabled': isdisabled
    };
  }
}

//Message Model

class Messages {
  String? message;
  String? sender;
  DateTime? time;
  bool? sentbyme;

  Messages({this.message, this.sender, this.time, this.sentbyme});

  factory Messages.fromMap(map) {
    return Messages(
        message: map['Message'],
        sender: map['Sender'],
        time: map['DateTime'],
        sentbyme: map['SentByMe']);
  }

  Map<String, dynamic> tomap() {
    return {
      'Message': message,
      'Sender': sender,
      'DateTime': time,
      'SentByMe': sentbyme
    };
  }
}
