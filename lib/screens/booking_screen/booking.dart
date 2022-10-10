// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:unitmma/constant_widgets/app_bar.dart';
import 'package:unitmma/scaffold/scaffold.dart';
import 'package:unitmma/screens/cart_screen/cart_screen.dart';
import 'package:unitmma/screens/home_screen/home.dart';
import 'package:unitmma/screens/product_screen/widgets/card.dart';
import 'package:unitmma/screens/product_screen/widgets/grid_product_list.dart';

import '../../constants/global_variables.dart';
import '../search_screen/search_screen.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldWidth = MediaQuery.of(context).size.width;
    final scaffoldHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: GlobalVariables.baseColor),
        actions: [
          Container(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(),
                      ),
                    );
                  },
                  child: const Icon(Icons.search_rounded,
                      color: GlobalVariables.baseColor),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CartScreen(),
                      ),
                    );
                  },
                  child: const Icon(Icons.shopping_cart_checkout_outlined,
                      color: GlobalVariables.baseColor),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: GlobalVariables.white,
        title: Text(
          "Booking",
          style: TextStyle(color: GlobalVariables.baseColor),
        ),
        centerTitle: true,
      ),
      // ignore: prefer_const_constructors
      body: Column(
        children: [
          Container(
            width: scaffoldWidth,
            height: scaffoldHeight * 0.1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      child: IconButton(
                        iconSize: 35,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.calendar_month,
                        ),
                      ),
                    ),
                    const Text("Booking")
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      iconSize: 35,
                      onPressed: () {},
                      icon: const Icon(Icons.timer_off),
                    ),
                    const Text("Past")
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
