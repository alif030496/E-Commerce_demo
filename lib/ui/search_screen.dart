// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:e_commerce_demo/const/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  var inputtext;

  TextEditingController _searchController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Search",
          style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold),
        ),
      ),
      body:   Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55.h,
                    child: TextFormField(
                      onChanged: (val){
                        setState(() {
                        inputtext=val;
                        });
                      },
                      controller: _searchController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(40)),
                              borderSide: BorderSide(
                                color: Colors.deepOrange,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(40)),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              )),
                          hintText: "Search your products here",
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              height: 45.h,
                              width: 45.h,
                              decoration: BoxDecoration(
                                color: AppColors.deep_orange,
                                borderRadius:
                                BorderRadius.all(Radius.circular(100.0)),
                              ),
//
                              child: Center(
                                child: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Expanded(child: Container(
             child: StreamBuilder(
               stream: FirebaseFirestore.instance.collection("product-images").where("product-name",isEqualTo: inputtext).snapshots(),
               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                 if(snapshot.hasError){
                   return Center(child: Text("Something Wrong!!"),);
                 }
                 if(snapshot.connectionState==ConnectionState.waiting){
                   return Center(child: Text("Loading Search Results..."),);
                 }
                 return ListView(
                   children:
                     snapshot.data!.docs.map((DocumentSnapshot document){
                       Map<String,dynamic> data= document.data() as Map<String,dynamic>;
                       return Card(
                         elevation: 5,
                         child: ListTile(
                           title: Text( data['product-name']),
                           subtitle: Text("Price: "+data['price'].toString()+" \$"),
                           trailing: Image.network(data['img-path'][0]),
                         ),
                       );
                     }).toList(),

                 );
               }
             ),
            ))
          ],
        ),

      ),
    ));
  }
}
