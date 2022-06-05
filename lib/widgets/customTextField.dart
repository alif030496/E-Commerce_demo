import 'package:flutter/material.dart';
import 'package:e_commerce_demo/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customButton(String buttonText, onPressed) {
  return SizedBox(
    width: 1.sw,
    height: 55,

    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: AppColors.deep_orange,
        elevation: 3
      ),
      child: Text(
        buttonText,
        style: TextStyle(
            fontSize: 20.sp, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
