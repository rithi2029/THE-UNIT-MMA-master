// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitmma/constant_widgets/app_bar.dart';
import 'package:unitmma/scaffold/scaffold.dart';
import 'package:unitmma/screens/checkout_screen/check_out.dart';
import 'package:unitmma/screens/home_screen/home.dart';
import 'package:unitmma/screens/news_screen/widget/newa_list.dart';
import 'package:unitmma/screens/product_screen/product.dart';
import 'package:unitmma/screens/product_screen/widgets/card.dart';
import 'package:unitmma/screens/product_screen/widgets/grid_product_list.dart';

import '../../constants/global_variables.dart';
import '../shipping_screen/shipping_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List _cartList = [];
  var _data;
  int _total = 0;

  initialState() async {
    final prefs = await SharedPreferences.getInstance();

    final String? cartDetails = prefs.getString('cart');

    setState(() {
      _data = cartDetails;
    });

    List cartDetail = jsonDecode(cartDetails!);
    final String? data = prefs.getString("data");

    setState(() {
      _data = data.toString();
    });

    setState(() {
      _cartList = cartDetail;
    });
    print(data);
    for (var info in _cartList) {
      int price = int.parse(info["price"]);
      int qty = info["qty"];

      int total = price * qty;
      setState(() {
        _total = _total + total;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldWidth = MediaQuery.of(context).size.width;
    final scaffoldHeight = MediaQuery.of(context).size.height;

    void total() {
      setState(() {
        _total = 0;
      });

      for (var info in _cartList) {
        int price = int.parse(info["price"]);
        int qty = info["qty"];

        int total = price * qty;
        setState(() {
          _total = _total + total;
        });
      }
    }

    add(val) async {
      final prefs = await SharedPreferences.getInstance();
      if (val["variation_id"] == 0) {
        int objIndex =
            _cartList.indexWhere((element) => element["id"] == val["id"]);
        Map<String, dynamic> data = _cartList[objIndex];

        data.update('qty', (value) => data["qty"] + 1);

        setState(() {
          var data1 = _cartList[objIndex] = data;
        });

        var newData = jsonEncode(_cartList);
        await prefs.setString('cart', newData);
        total();
      } else {
        int objIndex = _cartList.indexWhere(
            (element) => element["variation_id"] == val["variation_id"]);
        Map<String, dynamic> data = _cartList[objIndex];

        data.update('qty', (value) => data["qty"] + 1);

        setState(() {
          var data1 = _cartList[objIndex] = data;
        });

        var newData = jsonEncode(_cartList);
        await prefs.setString('cart', newData);
        total();
      }
    }

    remove(val) async {
      final prefs = await SharedPreferences.getInstance();
      if (val["variation_id"] == 0) {
        int objIndex =
            _cartList.indexWhere((element) => element["id"] == val["id"]);
        Map<String, dynamic> data = _cartList[objIndex];
        data.update('qty', (value) => data["qty"] - 1);
        setState(() {
          var data1 = _cartList[objIndex] = data;
        });
        var newData = jsonEncode(_cartList);
        await prefs.setString('cart', newData);
        total();
      } else {
        int objIndex = _cartList.indexWhere(
            (element) => element["variation_id"] == val["variation_id"]);
        Map<String, dynamic> data = _cartList[objIndex];
        data.update('qty', (value) => data["qty"] - 1);
        setState(() {
          var data1 = _cartList[objIndex] = data;
        });
        var newData = jsonEncode(_cartList);
        await prefs.setString('cart', newData);
        total();
      }
    }

    delete(val) async {
      final prefs = await SharedPreferences.getInstance();

      if (val["variation_id"] == 0) {
        setState(() {
          _cartList.removeWhere((element) => element["id"] == val["id"]);
          print("deleted");
        });
        var newData = jsonEncode(_cartList);
        await prefs.setString('cart', newData);
        total();
      } else {
        setState(() {
          _cartList.removeWhere(
              (element) => element["variation_id"] == val["variation_id"]);
          print("deleted");
        });
        var newData = jsonEncode(_cartList);
        await prefs.setString('cart', newData);
        total();
      }
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: GlobalVariables.baseColor),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.search_rounded,
                        color: GlobalVariables.baseColor),
                  ),
                ],
              ),
            ),
          ),
        ],
        backgroundColor: GlobalVariables.white,
        title: const Text(
          "Cart",
          style: TextStyle(color: GlobalVariables.baseColor),
        ),
        centerTitle: true,
      ),

      // ignore: prefer_const_constructors
      body: _cartList.isEmpty
          ? Center(child: Text("Cart is empty"))
          : Column(
              children: [
                Container(
                  height: scaffoldHeight * 0.72,
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: _cartList.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: EdgeInsets.all(2),
                                height: scaffoldHeight * 0.17,
                                child: Card(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: scaffoldWidth * 0.2,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image(
                                              image: NetworkImage(
                                                  _cartList[index]["image"])),
                                        ),
                                      ),
                                      SizedBox(
                                        width: scaffoldWidth * 0.050,
                                      ),
                                      Container(
                                        width: scaffoldWidth * 0.4,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                _cartList[index]["name"]
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: GlobalVariables
                                                        .baseColor,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                _cartList[index]["price"]
                                                        .isEmpty
                                                    ? "0"
                                                    : "Price : £${(int.parse(_cartList[index]["price"])) * _cartList[index]["qty"]}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        GlobalVariables.black,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: scaffoldWidth * 0.1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // GestureDetector(
                                            //   onTap: () {
                                            //     add(_cartList[index]);
                                            //   },
                                            //   child: const Icon(Icons.add,
                                            //       color: GlobalVariables.black),
                                            // ),
                                            Container(
                                              height: scaffoldHeight * 0.03,
                                              child: FloatingActionButton(
                                                elevation: 0,
                                                onPressed: () {
                                                  add(_cartList[index]);
                                                },
                                                backgroundColor: Colors.blue,
                                                child: Icon(Icons.add,
                                                    size: scaffoldHeight * 0.03,
                                                    color: Colors.white),
                                              ),
                                            ),

                                            Text(
                                              _cartList[index]["qty"]
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color:
                                                      GlobalVariables.baseColor,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            Container(
                                              height: scaffoldHeight * 0.03,
                                              child: FloatingActionButton(
                                                elevation: 0,
                                                onPressed: () {
                                                  _cartList[index]["qty"] != 1
                                                      ? remove(_cartList[index])
                                                      : "";
                                                },
                                                backgroundColor: Colors.blue,
                                                child: Icon(Icons.remove,
                                                    size: scaffoldHeight * 0.03,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                          child: Center(
                                        child: IconButton(
                                          icon: const Icon(Icons.delete),
                                          color: Colors.red,
                                          onPressed: () {
                                            delete(_cartList[index]);
                                          },
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Products"),
                                      Text("X " + _cartList.length.toString())
                                    ],
                                  ),
                                  Row(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                Expanded(
                  child: Container(
                    color: Color.fromARGB(255, 249, 248, 248),
                    child: Column(
                      children: [
                        // Expanded(
                        //     child: Container(
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       const Flexible(
                        //         child: Center(
                        //           child: Text(
                        //             "Total Price :",
                        //             style: TextStyle(
                        //                 fontSize: 18,
                        //                 color: GlobalVariables.baseColor,
                        //                 fontWeight: FontWeight.w800),
                        //           ),
                        //         ),
                        //       ),
                        //       Flexible(
                        //         child: Text(
                        //           "${GlobalVariables.currency + _total.toString()}",
                        //           style: const TextStyle(
                        //               fontSize: 20,
                        //               color: GlobalVariables.black,
                        //               fontWeight: FontWeight.w400),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green),
                              child: Text("Check Out"),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ShippingScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: GlobalVariables.baseColor),
                              child: Text("Keep Shopping"),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ProductScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
