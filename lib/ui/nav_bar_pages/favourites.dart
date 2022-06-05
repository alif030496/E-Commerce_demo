// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/AppColors.dart';

class Favs extends StatefulWidget {
  @override
  _FavsState createState() => _FavsState();
}

class _FavsState extends State<Favs> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:  Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0,

            title: Text(
              "Favourites",
              style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("favourite-items")
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .collection("items")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                var data = snapshot.data;
                if(data==null){
                  return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          CircularProgressIndicator(),
                          SizedBox(height: 20.h,),
                          Text("Loading Favourite Items..."),
                        ]
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Something Wrong!!"),
                  );
                }
                if (snapshot.data!.docs.length==0) {
                  return Center(
                    child: Text("No Favourite Items!!",style: TextStyle(color: AppColors.deep_orange,fontSize: 25,fontWeight: FontWeight.w600),),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Text("Loading Favourite Items..."),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (_, index) {
                    DocumentSnapshot _documentSnapshot =
                        snapshot.data!.docs[index];

                    return Card(
                    elevation: 5,
                    child: ListTile(
                    title: Text(
                    _documentSnapshot["name"],
                    style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    trailing: Text(
                    _documentSnapshot["price"].toString(),
                    style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
                    ),
                    leading: IconButton(
                    icon: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    ),
                    onPressed: () {
                    FirebaseFirestore.instance
                        .collection("favourite-items")
                        .doc(FirebaseAuth
                        .instance.currentUser!.email)
                        .collection("items")
                        .doc(_documentSnapshot.id)
                        .delete();
                    },
                    ),
                    ));
                  },
                );
              })),
    );
  }
}
