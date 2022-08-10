// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:unitmma/constant_widgets/app_bar.dart';
import 'package:unitmma/scaffold/scaffold.dart';
import 'package:unitmma/screens/home_screen/home.dart';
import 'package:unitmma/screens/product_screen/widgets/card.dart';
import 'package:unitmma/screens/product_screen/widgets/grid_product_list.dart';

import '../../constants/global_variables.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldWidth = MediaQuery.of(context).size.width;
    final scaffoldHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: appBar,
      // ignore: prefer_const_constructors
      body: Column(
        children: [
          Container(
            color: GlobalVariables.baseColor,
            width: scaffoldWidth,
            height: scaffoldHeight * 0.06,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ScaffoldScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: GlobalVariables.white,
                    ),
                  ),
                  const Text(
                    "Booking",
                    style: TextStyle(
                        color: GlobalVariables.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
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
