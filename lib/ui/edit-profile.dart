// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_demo/widgets/customButton.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../const/AppColors.dart';
import 'nav_bar_pages/profile.dart';

class editProfile extends StatefulWidget {
  @override
  _editProfileState createState() => _editProfileState();
}


class _editProfileState extends State<editProfile> {
  bool updatedob=false;
  bool updategender=false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _updatedobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _updategenderController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(DateTime.now().year - 100),
    lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
    _updatedobController.text = "${picked.day}-${picked.month}-${picked.year}";
    });
    }
  }

  setDatatoTextField(data) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            SizedBox(height: 20.h,),
            Text("Edit Information",style: TextStyle(color: AppColors.deep_orange,fontSize: 25,fontWeight: FontWeight.bold),),
            SizedBox(height: 20.h,),
            TextFormField(
              validator: (_nameController) {
                if (_nameController!.isEmpty) {
                  return 'Please input your Full Name.';
                }
                return null;
              },
              decoration: InputDecoration(
                  hintText: "Full Name",
                  hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black38),
                  labelText: "Full Name",
                  labelStyle: TextStyle(
                      color:
                      AppColors.deep_orange,
                      fontSize: 15.sp)),
              controller: _nameController=TextEditingController(text: data["name"]),
            ),
            TextFormField(
              validator: (_phoneController) {
                if (_phoneController!.isEmpty) {
                  return 'Please input your phone number.';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              inputFormatters:[FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),],
              decoration: InputDecoration(
                  hintText: "Phone Number",
                  hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black38),
                  labelText: "Phone",
                  labelStyle: TextStyle(
                      color:
                      AppColors.deep_orange,
                      fontSize: 15.sp)),
              controller: _phoneController=TextEditingController(text: data["phone"]),
            ),
            TextFormField(
              validator: (_updatedobController) {
                if (_updatedobController!.isEmpty) {
                  return 'Please select your date of birth.';
                }
                return null;
              },
              keyboardType: TextInputType.none,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      color: AppColors.deep_orange,
                    ),
                    onPressed: () {
                      updatedob=!updatedob;
                      _selectDateFromPicker(context);

                    },
                  ),
                  hintText: "Select date from calendar",
                  hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black38),
                  labelText: "Date of Birth",
                  labelStyle: TextStyle(
                      color:
                      AppColors.deep_orange,
                      fontSize: 15.sp)),
              controller: updatedob==false?_dobController=TextEditingController(text: data['dob']):_updatedobController,
            ),
            TextFormField(
              validator: (_updategenderController) {
                if (_updategenderController!.isEmpty) {
                  return 'Please select your gender.';
                }
                return null;
              },
              keyboardType: TextInputType.none,
              decoration: InputDecoration(
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
                          updategender=!updategender;
                          _updategenderController.text = e;
                        });
                      },
                    ))
                        .toList(),
                    onChanged: (context) {},
                  ),
                  hintText: "Select Gender",
                  hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black38),
                  labelText: "Gender",
                  labelStyle: TextStyle(
                      color:
                      AppColors.deep_orange,
                      fontSize: 15.sp)),
              controller: updategender==false?_genderController=TextEditingController(text: data["gender"]):_updategenderController,
            ),
            TextFormField(
              validator: (_ageController) {
                if (_ageController!.isEmpty) {
                  return 'Please input your age.';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              inputFormatters:[FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),],
              decoration: InputDecoration(
                  hintText: "Age",
                  hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black38),
                  labelText: "Age",
                  labelStyle: TextStyle(
                      color:
                      AppColors.deep_orange,
                      fontSize: 15.sp)),
              controller: _ageController=TextEditingController(text: data["age"]),
            ),
            SizedBox(height: 250.h,),
            customButton("Update", () {
              if (_formkey.currentState!.validate()) {

              updateData();
              Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => Profile()));
              }
            }),
          ],
        ),
      ),
    );
  }

  updateData() {
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("user-information");
    return _collectionRef
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({
      "name": _nameController.text,
      "phone": _phoneController.text,
      "dob": updatedob==false?_dobController.text:_updatedobController.text,
      "gender": updategender==false?_genderController.text:_updategenderController.text,
      "age": _ageController.text,
    })
        .then((value) => Fluttertoast.showToast(msg:"User data updates successfully."))
        .catchError((error) => Fluttertoast.showToast(msg:"Something wrong"));
  }
  List<String> gender = ["Male", "Female", "Other"];
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("user-information")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var data = snapshot.data;
            if(data==null){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return setDatatoTextField(data);
          },
        ),
      ),
    ));
  }
}
