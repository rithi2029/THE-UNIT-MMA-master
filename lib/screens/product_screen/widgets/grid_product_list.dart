import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitmma/constants/global_variables.dart';
import 'package:unitmma/screens/product_detail_screen/single_product_screen.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  var cartList = <dynamic>[];

  @override
  Widget build(BuildContext context) {
    Map<String, String> headers = {"Content-Type": "application/json"};

    Future getProducts() async {
      final res = await http.get(
          Uri.parse(
              "https://theunitmma.co.uk/wp-json/wc/v2/products?consumer_key=ck_dc42350e0d839a416bb73fdef9984544907a8fdb&consumer_secret=cs_023b27d43090a807fc43d77cda696a15cc87442e"),
          headers: headers);
      final result = jsonDecode(res.body);
      return result;
    }

    getOrder(val) async {
      Map<String, dynamic> data = {
        "id": val["id"],
        "name": val["name"],
        "price": val["price"],
        "qty": 1,
        "image": val["images"][0]["src"]
      };
      final prefs = await SharedPreferences.getInstance();
      final String? cartDetails = prefs.getString('cart');
      List cartDetail = jsonDecode(cartDetails!);

      if (cartDetail.length == 0) {
        setState(() {
          if (cartDetail.any((item) => item["id"] == data["id"])) {
            var data1 = [...cartList];
            cartList = data1;
          } else {
            var data1 = [...cartList, data];
            cartList = data1;
          }
        });
        var newData = jsonEncode(cartList);
        await prefs.setString('cart', newData);
      } else {
        setState(() {
          if (cartDetail.any((item) => item["id"] == data["id"])) {
            var data1 = [...cartDetail];
            cartList = data1;
          } else {
            var data1 = [...cartDetail, data];
            cartList = data1;
          }
        });
        var newData = jsonEncode(cartList);
        await prefs.setString('cart', newData);
      }

      print(cartDetail.length);
    }

    return FutureBuilder<dynamic>(
        future: getProducts(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
//hence here snapshot has some data and you can use .lenght on it
            if (snapshot.data.length > 1) {}
          } else {
            print("not working");
          }

          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext ctx, index) {
                return Container(
                  alignment: Alignment.center,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: LayoutBuilder(builder: ((context, constraints) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 246, 243, 243),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(3, 3),
                            spreadRadius: -2,
                            blurRadius: 2,
                            color: Color.fromARGB(255, 139, 138, 138),
                          ),
                        ],
                      ),
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SingleProductScreen(
                                      id: snapshot.data[index]["id"]),
                                ),
                              );
                            },
                            child: Container(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight * 0.7,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image(
                                  image: NetworkImage(
                                      snapshot.data[index]["images"][0]["src"]),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                    snapshot.data[index]["name"].toString(),
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800)),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("£ ${snapshot.data[index]["price"]}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                ElevatedButton(
                                  onPressed: () {
                                    getOrder(snapshot.data[index]);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: GlobalVariables.baseColor,
                                      onPrimary: GlobalVariables.white),
                                  child: const Text("Add to cart"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
                );
              });
        });
  }
}
