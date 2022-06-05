// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:e_commerce_demo/widgets/customButton.dart';
import 'package:e_commerce_demo/ui/loginscreen.dart';
import 'package:e_commerce_demo/const/AppColors.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_commerce_demo/home_nav_bar_controller.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
    );
    if (picked != null)
      setState(() {
        _dobController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
  }



  sendUserDatatoFirestore() async {

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("user-information");
    return _collectionRef
        .doc(FirebaseAuth.instance.currentUser!.email)
        .set({
          "name": _nameController.text,
          "phone": _phoneController.text,
          "dob": _dobController.text,
          "gender": _genderController.text,
          "age": _ageController.text,
        })
        .then((value) => Fluttertoast.showToast(msg:"User data successfully added."))
        .catchError((error) => Fluttertoast.showToast(msg:"Something went wrong"));

  }

  List<String> gender = ["Male", "Female", "Other"];
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Fill this form to complete Sign Up",
                    style: TextStyle(
                        fontSize: 22.sp, color: AppColors.deep_orange),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'We will not share your information with anyone.',
                    style: TextStyle(
                      fontFamily: 'Product Sans',
                      fontSize: 14.0,
                      color: const Color(0xFFBBBBBB),
                      letterSpacing: 0.56,
                      height: 1.0,
                    ),
                  ),
                  SizedBox(
                    height: 55,
                  ),
                  TextFormField(
                      controller: _nameController,
                      validator: (_nameController) {
                        if (_nameController!.isEmpty) {
                          return 'Please input your Full Name.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Full Name",
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                      validator: (_phoneController) {
                        if (_phoneController!.isEmpty) {
                          return 'Please input your phone number.';
                        }
                        return null;
                      },
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      inputFormatters:[FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),],
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                      validator: (_dobController) {
                        if (_dobController!.isEmpty) {
                          return 'Please select your date of birth.';
                        }
                        return null;
                      },
                      controller: _dobController,
                      decoration: InputDecoration(
                          hintText: "Date of Birth",
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.calendar_today,
                              color: AppColors.deep_orange,
                            ),
                            onPressed: () {
                              _selectDateFromPicker(context);
                            },
                          ))),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                      validator: (_genderController) {
                        if (_genderController!.isEmpty) {
                          return 'Please select your gender.';
                        }
                        return null;
                      },
                      controller: _genderController,
                      decoration: InputDecoration(
                          hintText: "Gender",
                          suffixIcon: DropdownButton(
                            elevation: 0,
                            underline: Container(
                              color: Colors.white,
                            ),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.deep_orange,
                              size: 40,
                            ),
                            items: gender
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                      onTap: () {
                                        setState(() {
                                          _genderController.text = e;
                                        });
                                      },
                                    ))
                                .toList(),
                            onChanged: (context) {},
                          ))),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                      validator: (_ageController) {
                        if (_ageController!.isEmpty) {
                          return 'Please input your age.';
                        }
                        return null;
                      },
                      controller: _ageController,
                      decoration: InputDecoration(
                        hintText: "Age",
                      )),
                  SizedBox(
                    height: 220.h,
                  ),
                  customButton("Submit", () {
                    if (_formkey.currentState!.validate()) {
                      sendUserDatatoFirestore();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeNavBar()));
                    }
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
