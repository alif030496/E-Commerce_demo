// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:e_commerce_demo/const/AppColors.dart';

import 'package:flutter/material.dart';

import 'ui/nav_bar_pages/cart.dart';
import 'ui/nav_bar_pages/favourites.dart';
import 'ui/nav_bar_pages/home.dart';
import 'ui/nav_bar_pages/profile.dart';

class HomeNavBar extends StatefulWidget {
  @override
  _HomeNavBarState createState() => _HomeNavBarState();
}

class _HomeNavBarState extends State<HomeNavBar> {
  final pages=[Home(),Favs(),Cart(),Profile()];
  var _currentindex=0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(

      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        selectedItemColor: AppColors.deep_orange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        currentIndex: _currentindex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,

              ),
              label: "Home"),

          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_border,

              ),
              label: "Favourites"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,

              ),
              label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,

              ),
              label: "Profile"),
        ],
        onTap: (index){
          setState(() {
            _currentindex=index;
          });

        },
      ),
      body: pages[_currentindex],
    ));
  }
}

