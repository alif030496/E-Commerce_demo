// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:e_commerce_demo/ui/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_demo/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

 @override
  void initState() {
    Timer(Duration(seconds: 3),()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen())));
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deep_orange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("E-Commerce",style: TextStyle(fontSize: 44.sp,fontWeight: FontWeight.bold,color: Colors.white),),
            SizedBox(height: 20.h,),
            CircularProgressIndicator(color: Colors.white,),

          ],
        ),
      ),
    );
  }
}
