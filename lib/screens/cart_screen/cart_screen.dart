// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitmma/constant_widgets/app_bar.dart';
import 'package:unitmma/scaffold/scaffold.dart';
import 'package:unitmma/screens/home_screen/home.dart';
import 'package:unitmma/screens/news_screen/widget/newa_list.dart';
import 'package:unitmma/screens/product_screen/widgets/card.dart';
import 'package:unitmma/screens/product_screen/widgets/grid_product_list.dart';

import '../../constants/global_variables.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List _cartList = [];

  @override
  Widget build(BuildContext context) {
    final scaffoldWidth = MediaQuery.of(context).size.width;
    final scaffoldHeight = MediaQuery.of(context).size.height;

    demo() async {
      final prefs = await SharedPreferences.getInstance();
      final String? cartDetails = prefs.getString('cart');
      List cartDetail = jsonDecode(cartDetails!);
      setState(() {
        _cartList = cartDetail;
      });
    }

    add(val) async {
      final prefs = await SharedPreferences.getInstance();

      int objIndex =
          _cartList.indexWhere((element) => element["id"] == val["id"]);
      Map<String, dynamic> data = _cartList[objIndex];

      data.update('qty', (value) => data["qty"] + 1);

      setState(() {
        var data1 = _cartList[objIndex] = data;
      });

      var newData = jsonEncode(_cartList);
      await prefs.setString('cart', newData);
    }

    remove(val) async {
      final prefs = await SharedPreferences.getInstance();

      int objIndex =
          _cartList.indexWhere((element) => element["id"] == val["id"]);
      Map<String, dynamic> data = _cartList[objIndex];

      data.update('qty', (value) => data["qty"] - 1);

      setState(() {
        var data1 = _cartList[objIndex] = data;
      });

      var newData = jsonEncode(_cartList);
      await prefs.setString('cart', newData);
    }

    demo();

    return Scaffold(
      appBar: appBar,
      // ignore: prefer_const_constructors
      body: _cartList.isEmpty
          ? Center(child: Text("Cart is empty"))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _cartList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.all(10),
                  height: 130,
                  child: Card(
                    child: Row(
                      children: [
                        Container(
                          width: scaffoldWidth * 0.2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image(
                                image: NetworkImage(_cartList[index]["image"])),
                          ),
                        ),
                        SizedBox(
                          width: scaffoldWidth * 0.050,
                        ),
                        Flexible(
                          child: Container(
                            width: scaffoldWidth * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(_cartList[index]["name"]),
                                Text((_cartList[index]["price"] *
                                        _cartList[index]["qty"])
                                    .toString()),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: scaffoldWidth * 0.1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  add(_cartList[index]);
                                },
                                child: const Icon(Icons.add,
                                    color: GlobalVariables.baseColor),
                              ),
                              Text(_cartList[index]["qty"].toString()),
                              GestureDetector(
                                onTap: () {
                                  remove(_cartList[index]);
                                },
                                child: const Icon(Icons.remove,
                                    color: GlobalVariables.baseColor),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
