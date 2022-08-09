import 'package:flutter/material.dart';
import 'package:unitmma/constants/global_variables.dart';
import 'package:unitmma/screens/home_screen/home.dart';
import 'package:unitmma/screens/membership_screen/membership.dart';
import 'package:unitmma/screens/news_screen/news.dart';
import 'package:unitmma/screens/shop_screen/shop.dart';

import '../../constant_widgets/app_bar.dart';
import '../screens/booking_screen/booking.dart';

class ScaffoldScreen extends StatefulWidget {
  @override
  State<ScaffoldScreen> createState() => _ScaffoldScreenState();
}

class _ScaffoldScreenState extends State<ScaffoldScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    BookingScreen(),
    NewsScreen(),
    MemberShipScreen(),
    ShopScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: GlobalVariables.baseColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Booking',
            backgroundColor: GlobalVariables.baseColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
            backgroundColor: GlobalVariables.baseColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership_rounded),
            label: 'Membership',
            backgroundColor: GlobalVariables.baseColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
            backgroundColor: GlobalVariables.baseColor,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: GlobalVariables.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
