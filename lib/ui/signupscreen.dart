// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:e_commerce_demo/ui/user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_commerce_demo/widgets/customButton.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_commerce_demo/const/AppColors.dart';
import 'package:e_commerce_demo/ui/loginscreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _obscureText = true;

  signUp() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      var authCredential = userCredential.user;
      if (authCredential!.uid.isNotEmpty) {
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => UserForm()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: 'The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.deep_orange,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 120.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontFamily: 'Product Sans',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Expanded(
                  child: Container(
                width: ScreenUtil().screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.r),
                      topLeft: Radius.circular(30.r)),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              'Welcome!',
                              style: TextStyle(
                                fontFamily: 'Product Sans',
                                fontSize: 22.sp,
                                color: const Color(0xFFFF6B6B),
                                letterSpacing: 0.88,
                                height: 0.82,
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              'Glad to see you my buddy.',
                              style: TextStyle(
                                fontFamily: 'Product Sans',
                                fontSize: 14.0.sp,
                                color: const Color(0xFFBBBBBB),
                                letterSpacing: 0.56,
                                height: 1.0,
                              ),
                            ),
                            SizedBox(
                              height: 70.h,
                            ),
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 60.h,
                                          width: 50.w,
                                          decoration: BoxDecoration(
                                              color: AppColors.deep_orange,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.r))),
                                          child: Icon(
                                            Icons.email_outlined,
                                            size: 35.w,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: _emailController,
                                            decoration: InputDecoration(
                                                hintText: "example@mail.com",
                                                hintStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black38),
                                                labelText: "Email",
                                                labelStyle: TextStyle(
                                                    color:
                                                        AppColors.deep_orange,
                                                    fontSize: 15.sp)),
                                            validator: (_emailController) {
                                              if (_emailController!.isEmpty) {
                                                return 'Please input your e-mail.';
                                              }
                                              return null;
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30.h,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 60.h,
                                          width: 50.w,
                                          decoration: BoxDecoration(
                                              color: AppColors.deep_orange,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.r))),
                                          child: Icon(
                                            Icons.lock_outline,
                                            size: 35.w,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            obscureText: _obscureText,
                                            controller: _passwordController,
                                            decoration: InputDecoration(
                                              hintText: "password",
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black38),
                                              labelText: "Set Password",
                                              labelStyle: TextStyle(
                                                  color: AppColors.deep_orange,
                                                  fontSize: 15.sp),
                                              suffixIcon: _obscureText == true
                                                  ? IconButton(
                                                      icon: Icon(
                                                          Icons.visibility_off),
                                                      onPressed: () {
                                                        setState(() {
                                                          _obscureText =
                                                              !_obscureText;
                                                        });
                                                      },
                                                    )
                                                  : IconButton(
                                                      icon: Icon(
                                                          Icons.visibility),
                                                      onPressed: () {
                                                        setState(() {
                                                          _obscureText =
                                                              !_obscureText;
                                                        });
                                                      },
                                                    ),
                                            ),
                                            validator: (_passwordController) {
                                              if (_passwordController!
                                                  .isEmpty) {
                                                return 'Please input your password.';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 60.h,
                            ),
                            customButton(
                              "Continue",
                              () {
                                if (_formKey.currentState!.validate()) {
                                  signUp();
                                }
                              },
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Center(
                              child: Wrap(
                                children: [
                                  Text("Do you have an account?",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black38,
                                      )),
                                  GestureDetector(
                                    child: Text(" Sign In",
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.deep_orange,
                                        )),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                    },
                                  ),
                                ],
                              ),
                            )
                          ])),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
