// ignore_for_file: unused_import, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce_demo/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_demo/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,

              title: Text(
                "Cart",
                style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("cart-items")
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
                          Text("Loading Cart Items..."),
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
                      child: Text("Your cart is empty!!",style: TextStyle(color: AppColors.deep_orange,fontSize: 25,fontWeight: FontWeight.w600),),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text("Loading Cart Items..."),
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
                                Icons.delete,
                                color: Colors.deepOrange,
                              ),
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection("cart-items")
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
      ),
    );
  }
}
