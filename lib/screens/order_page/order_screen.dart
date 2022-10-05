import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitmma/scaffold/scaffold.dart';
import 'package:unitmma/screens/cart_screen/cart_screen.dart';
import 'package:unitmma/screens/order_page/widgets/order_list.dart';
import 'package:unitmma/screens/product_screen/widgets/grid_product_list.dart';

import '../../constants/global_variables.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int badgeCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("object");
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
        backgroundColor: GlobalVariables.white,
        title: Text(
          "Order History",
          style: TextStyle(color: GlobalVariables.baseColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: const Padding(
          padding: const EdgeInsets.all(8.0),
          child: OrderList(),
        ),
      ),
    );
  }
}
