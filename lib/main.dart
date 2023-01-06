import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:somcable_web_app/colors/Colors.dart';
import 'package:somcable_web_app/pages/adminDashboard.dart';
import 'package:somcable_web_app/pages/emailVerification.dart';
import 'package:somcable_web_app/pages/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:somcable_web_app/pages/responsiveness/mobilebody.dart';
import 'package:somcable_web_app/pages/responsiveness/responsive.dart';
import 'package:somcable_web_app/pages/splashscreen.dart';
import 'package:firebase_performance/firebase_performance.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox('CheckingLoggedInUser');
  await Hive.openBox('UsersName');
  await Hive.openBox('Role');
  await Hive.openBox('Darkmode');
  await Hive.openBox('Tempereture');

  if (kIsWeb) {
    var app = await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyB2jwa7XHvRVGB00olD5ePzZ7t0J5ROh0Y",
            appId: "1:434262526780:web:246ae40324667d57ff6c39",
            messagingSenderId: "434262526780",
            projectId: "somcabledatabase"));

    var perfomance = FirebasePerformance.instanceFor(app: app);

    perfomance.setPerformanceCollectionEnabled(true);
    
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
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      builder: (context, widget) => ResponsiveWrapper.builder(
        ClampingScrollWrapper(child: widget!),
        breakpoints: [
          ResponsiveBreakpoint.resize(350, name: 'mobileView'),
          ResponsiveBreakpoint.autoScale(600, name: 'Tablet'),
          ResponsiveBreakpoint.resize(800, name: 'Desktop'),
          ResponsiveBreakpoint.autoScaleDown(1920, name: 'XL')
        ],
      ),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
