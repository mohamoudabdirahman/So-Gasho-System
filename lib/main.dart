import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:somcable_web_app/pages/adminDashboard.dart';
import 'package:somcable_web_app/pages/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:somcable_web_app/pages/splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox('CheckingLoggedInUser');
  await Hive.openBox('UsersName');
  await Hive.openBox('Role');

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyB2jwa7XHvRVGB00olD5ePzZ7t0J5ROh0Y",
            appId: "1:434262526780:web:246ae40324667d57ff6c39",
            messagingSenderId: "434262526780",
            projectId: "somcabledatabase"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
