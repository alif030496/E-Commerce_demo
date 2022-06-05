// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields, prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, unused_import

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../const/AppColors.dart';
import '../widgets/customButton.dart';

class ProductDetails extends StatefulWidget {
  var _product;
  ProductDetails(this._product);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Future addtoCart() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentuser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("cart-items");
    return _collectionRef
        .doc(currentuser!.email)
        .collection("items")
        .doc()
        .set({
      "name": widget._product["product-name"],
      "price": widget._product["product-price"],
      "image": widget._product["product-image"],
    });
//        .then((value) => Fluttertoast.showToast(msg: "Added to Cart"))
//        .catchError((error) => Fluttertoast.showToast(msg: "Something wrong"));
  }

  Future addtoFavourite() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentuser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("favourite-items");
    return _collectionRef
        .doc(currentuser!.email)
        .collection("items")
        .doc()
        .set({
          "name": widget._product["product-name"],
          "price": widget._product["product-price"],
          "image": widget._product["product-image"],
        })
        .then((value) => Fluttertoast.showToast(msg: "Added to Favourites"))
        .catchError((error) => Fluttertoast.showToast(msg: "Something wrong"));
  }


  var dotposition = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: EdgeInsets.all(5.0),
          child: Center(
            child: CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.deep_orange,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
                iconSize: 30,
              ),
            ),
          ),
        ),
        actions: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("favourite-items")
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .collection("items")
                  .where("name", isEqualTo: widget._product["product-name"])
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.data==null){
                  return CircularProgressIndicator(color: Colors.transparent,);

                }
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.transparent,
                    child: IconButton(
                      onPressed: () => snapshot.data.docs.length == 0
                          ? addtoFavourite()
                          : Fluttertoast.showToast(msg: "Already added!!"),
                      icon: snapshot.data.docs.length == 0
                          ? Icon(Icons.favorite_border)
                          : Icon(Icons.favorite),
                      color: Colors.red,
                      iconSize: 30,
                    ),
                  ),
                );
              }),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 12.0),
          child: Column(
            children: [
//              Container(
//                height: 60,
//                width: 1.sw,
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: [
//                    Padding(
//                      padding: EdgeInsets.all(2.0),
//                      child: CircleAvatar(
//                        radius: 25,
//                        backgroundColor: AppColors.deep_orange,
//                        child: IconButton(
//                          onPressed: () => Navigator.pop(context),
//                          icon: Icon(Icons.arrow_back),
//                          color: Colors.white,
//                          iconSize: 30,
//                        ),
//                      ),
//                    ),
//                    StreamBuilder(
//                      stream: FirebaseFirestore.instance.collection("favourite-items").doc(FirebaseAuth.instance.currentUser!.email).collection("items").where("name",isEqualTo: widget._product["product-name"]).snapshots(),
//                      builder: (BuildContext context, AsyncSnapshot snapshot){
//                        return Padding(
//                          padding: EdgeInsets.all(2.0),
//                          child: CircleAvatar(
//                            radius: 25,
//                            backgroundColor: Colors.transparent,
//                            child: IconButton(
//                              onPressed: () => snapshot.data!.docs.length==0?addtoFavourite():Fluttertoast.showToast(msg: "Already in favourites!!"),
//                              icon:snapshot.data!.docs.length==0? Icon(Icons.favorite_border):Icon(Icons.favorite),
//                              color: Colors.red,
//                              iconSize: 30,
//                            ),
//                          ),
//                        );
//                      }
//                    ),
//                  ],
//                ),
//              ),
              SizedBox(
                height: 10.h,
              ),
              AspectRatio(
                aspectRatio: 2.0,
                child: CarouselSlider(
                    items: widget._product['product-image']
                        .map<Widget>((item) => Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.r)),
                                  image: DecorationImage(
                                      image: NetworkImage(item),
                                      fit: BoxFit.scaleDown),
                                ),
                              ),
                            ))
                        .toList(),
                    options: CarouselOptions(
                        height: 400,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        viewportFraction: 0.8,
                        enlargeStrategy: CenterPageEnlargeStrategy.scale,
                        onPageChanged: (val, carouselPagechangedReason) {
                          setState(() {
                            dotposition = val;
                          });
                        })),
              ),
              SizedBox(
                height: 10.h,
              ),
              DotsIndicator(
                dotsCount: widget._product["product-image"].length == 0
                    ? 1
                    : widget._product["product-image"].length,
                position: dotposition.toDouble(),
                decorator: DotsDecorator(
                  activeColor: AppColors.deep_orange,
                  size: Size(10.0, 10.0),
                  activeSize: Size(18.0, 10.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: AppColors.deep_orange.withOpacity(0.5),
                ),
              ),
              SizedBox(
                height: 35.h,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Container(
                  height: 350,
                  width: 1.sw,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget._product['product-name'],
                        style: TextStyle(
                          fontSize: 35,
                          color: AppColors.deep_orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "\$ ",
                            style: TextStyle(
                                color: AppColors.deep_orange,
                                fontSize: 30,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            widget._product['product-price'].toString(),
                            style: TextStyle(
                                color: AppColors.deep_orange,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(widget._product['product-description']),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              customButton(
                "Add to Cart",
                () {
                  addtoCart();
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
