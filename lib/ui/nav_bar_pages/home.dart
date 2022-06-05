// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_final_fields, non_constant_identifier_names, prefer_is_empty, prefer_const_literals_to_create_immutables

import 'package:e_commerce_demo/const/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_demo/ui/detailpage.dart';
import 'package:e_commerce_demo/ui/search_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // ignore: prefer_final_fields
  var dotposition = 0;
  // ignore: prefer_final_fields
  List<String> _carousel_images = [];
  List _products = [];
  var _firestoreInstance = FirebaseFirestore.instance;
    fetchProducts() async {
    QuerySnapshot qn =
        await _firestoreInstance.collection("product-images").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _products.add(

         {
           "product-name": qn.docs[i]["product-name"],
           "product-description": qn.docs[i]["description"],
           "product-price": qn.docs[i]["price"],
           "product-image": qn.docs[i]["img-path"],
         }

        );
      }
    });
    return qn.docs;
  }

  fetchCarouselImages() async {
    QuerySnapshot qn =
        await _firestoreInstance.collection("carousel-slider").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carousel_images.add(qn.docs[i]["img-path"]);
      }
    });
    return qn.docs;
  }

  @override
  void initState() {
    fetchCarouselImages();
    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text(
                "E-Commerce",
                style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold),
              ),
            ),
            body: Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.h, right: 20.h),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55.h,
                    child: TextFormField(
                      enabled: true,
                      readOnly: true,
                      onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (_)=>SearchScreen())),
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
          ),
          SizedBox(
            height: 10.h,
          ),
          AspectRatio(
            aspectRatio: 2.0,
            child: CarouselSlider(
                items: _carousel_images
                    .map((item) => Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r)),
                              image: DecorationImage(
                                  image: NetworkImage(item),
                                  fit: BoxFit.fitWidth),
                            ),
                          ),
                        ))
                    .toList(),
                options: CarouselOptions(
                    height: 400,
                    autoPlay: true,
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
            dotsCount:_carousel_images.length == 0 ? 1 : _carousel_images.length,
            position: dotposition.toDouble(),
            decorator: DotsDecorator(
              activeColor: AppColors.deep_orange,
              size:  Size(10.0,10.0),
              activeSize:  Size(18.0, 10.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: AppColors.deep_orange.withOpacity(0.5),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Top Products",style: TextStyle(color: AppColors.deep_orange,fontSize: 22,fontWeight: FontWeight.bold),),
                  Text("View All>>",style: TextStyle(color: AppColors.deep_orange,fontSize: 15,fontWeight: FontWeight.bold),),

                ],
              ),
            ),
          Expanded(child: GridView.builder(
          scrollDirection: Axis.horizontal,
            itemCount: _products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,childAspectRatio: 1.0),
            itemBuilder: (_,index){
              return GestureDetector(
                onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(_products[index]))),
                child: Card(
                  elevation: 3,
                  child: Column(
                    children: [
                     Container(
                       height:90,
                         width:90,

                         child: Image.network(_products[index]["product-image"][0],fit: BoxFit.scaleDown,)),
                    Text("${_products[index]["product-name"]}"),
                      Text("\$ ${_products[index]["product-price"]}"),
                    ],
                  ),
                ),
              );
            }),),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Accessories",style: TextStyle(color: AppColors.deep_orange,fontSize: 22,fontWeight: FontWeight.bold),),
                Text("View All>>",style: TextStyle(color: AppColors.deep_orange,fontSize: 15,fontWeight: FontWeight.bold),),

              ],
            ),
          ),
          Expanded(child: GridView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,childAspectRatio: 1.0),
              itemBuilder: (_,index){
                return GestureDetector(
                onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(_products[index]))),
                  child: Card(
                    elevation: 3,
                    child: Column(
                      children: [
                        Container(
                          height: 90,
                            width: 90,
                            child: Image.network(_products[index]["product-image"][0],fit: BoxFit.scaleDown,)),
                        Text("${_products[index]["product-name"]}"),
                        Text("\$ ${_products[index]["product-price"]}"),
                      ],
                    ),
                  ),
                );
              }),),
        ],
      ),
    )));
  }
}
