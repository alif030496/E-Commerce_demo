// ignore_for_file: prefer_const_constructors

import 'package:e_commerce_demo/home_nav_bar_controller.dart';
import 'package:e_commerce_demo/ui/nav_bar_pages/home.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_demo/ui/splashscreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:e_commerce_demo/ui/user_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAi5cM0jzduanmbynRJJD1D1TYjje8qpVk",
          appId: "1:879301143567:android:307040589cd0ff35f1477a",
          messagingSenderId: "879301143567",
          projectId: "e-commerce-e7ec8"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(375, 812),
        builder: () {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'E-Commerce Demo',
            theme: ThemeData(
              primarySwatch: Colors.deepOrange,
            ),
            home: SplashScreen(),
          );
        });
  }
}
