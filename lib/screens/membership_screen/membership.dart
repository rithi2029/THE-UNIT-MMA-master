import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitmma/scaffold/scaffold.dart';
import 'package:unitmma/screens/cart_screen/cart_screen.dart';
import 'package:unitmma/screens/membership_screen/widget/member_ship_widget.dart';
import 'package:unitmma/screens/product_screen/widgets/grid_product_list.dart';

import '../../constants/global_variables.dart';
import '../search_screen/search_screen.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({Key? key}) : super(key: key);

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  int badgeCount = 0;

  String sale_price = "--";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldWidth = MediaQuery.of(context).size.width;
    final scaffoldHeight = MediaQuery.of(context).size.height;

    initialState() async {
      final prefs = await SharedPreferences.getInstance();

      final String? cartDetails = prefs.getString('cart');

      List cartDetail = jsonDecode(cartDetails!);
      setState(() {
        badgeCount = cartDetail.length;
      });
    }

    initialState();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: GlobalVariables.baseColor),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ScaffoldScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: GlobalVariables.baseColor,
          ),
        ),
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
                  child: Badge(
                    elevation: 0,
                    badgeContent: Text("$badgeCount",
                        style: TextStyle(color: GlobalVariables.white)),
                    badgeColor: GlobalVariables.baseColor,
                    child: const Icon(Icons.shopping_cart_outlined),
                  ),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: GlobalVariables.white,
        title: Text(
          "Membership",
          style: TextStyle(color: GlobalVariables.baseColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: const Padding(
          padding: const EdgeInsets.all(8.0),
          child: MemberShipWigdet(),
        ),
      ),
    );
  }
}
