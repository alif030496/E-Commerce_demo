// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_demo/widgets/customButton.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/AppColors.dart';
import '../edit-profile.dart';
import 'dart:async';
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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

  setDatatoTextField(data) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text("User Information",style: TextStyle(color: AppColors.deep_orange,fontSize: 25,fontWeight: FontWeight.bold),),
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: ((context) => editProfile())));
              }, icon: Icon(Icons.edit),color: Colors.deepOrange,iconSize: 35,)
            ],
          ),
          SizedBox(height: 20.h,),
          Text('Full Name : '+data['name'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,),),
          Text('Phone : '+data['phone'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black),),
          Text('Date of Birth : '+data['dob'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black),),
          Text('Gender : '+data['gender'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black),),
          Text('Age : '+data['age'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black),),
//          TextFormField(
//            decoration: InputDecoration(
//                hintText: "example@mail.com",
//                hintStyle: TextStyle(
//                    fontSize: 14,
//                    color: Colors.black38),
//                labelText: "Full Name",
//                labelStyle: TextStyle(
//                    color:
//                    AppColors.deep_orange,
//                    fontSize: 15.sp)),
//            controller: _nameController=TextEditingController(text: data["name"]),
//          ),
//          TextFormField(
//            decoration: InputDecoration(
//                hintText: "example@mail.com",
//                hintStyle: TextStyle(
//                    fontSize: 14,
//                    color: Colors.black38),
//                labelText: "Phone",
//                labelStyle: TextStyle(
//                    color:
//                    AppColors.deep_orange,
//                    fontSize: 15.sp)),
//            controller: _phoneController=TextEditingController(text: data["phone"]),
//          ),
//          TextFormField(
//            decoration: InputDecoration(
//
//                hintText: "example@mail.com",
//                hintStyle: TextStyle(
//                    fontSize: 14,
//                    color: Colors.black38),
//                labelText: "Date of Birth",
//                labelStyle: TextStyle(
//                    color:
//                    AppColors.deep_orange,
//                    fontSize: 15.sp)),
//            controller: _dobController=TextEditingController(text: data["dob"]),
//          ),
//          TextFormField(
//            decoration: InputDecoration(
//                hintText: "example@mail.com",
//                hintStyle: TextStyle(
//                    fontSize: 14,
//                    color: Colors.black38),
//                labelText: "Gender",
//                labelStyle: TextStyle(
//                    color:
//                    AppColors.deep_orange,
//                    fontSize: 15.sp)),
//            controller: _genderController=TextEditingController(text: data["gender"]),
//          ),
//          TextFormField(
//            decoration: InputDecoration(
//                hintText: "example@mail.com",
//                hintStyle: TextStyle(
//                    fontSize: 14,
//                    color: Colors.black38),
//                labelText: "Age",
//                labelStyle: TextStyle(
//                    color:
//                    AppColors.deep_orange,
//                    fontSize: 15.sp)),
//            controller: _ageController=TextEditingController(text: data["age"]),
//          ),
          SizedBox(height: 150.h,),
          customButton("Log out", () {
           Logout();
            }
          ),
        ],
      ),
    );
  }

  Logout() {
FirebaseAuth.instance.signOut();
Navigator.pop(context);
}


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
                child:  CircularProgressIndicator(),//CircularProgressIndicator(),
              );
            }

            return setDatatoTextField(data);
          },
        ),
      ),
    ));
  }
}
