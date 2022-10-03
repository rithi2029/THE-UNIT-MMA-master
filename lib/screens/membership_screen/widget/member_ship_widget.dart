import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitmma/constants/global_variables.dart';
import 'package:unitmma/screens/product_detail_screen/single_product_screen.dart';

import '../../../constants/utils.dart';

class MemberShipWigdet extends StatefulWidget {
  const MemberShipWigdet({Key? key}) : super(key: key);

  @override
  State<MemberShipWigdet> createState() => _MemberShipWigdetState();
}

class _MemberShipWigdetState extends State<MemberShipWigdet> {
  var cartList = <dynamic>[];

  @override
  Widget build(BuildContext context) {
    final scaffoldWidth = MediaQuery.of(context).size.width;
    final scaffoldHeight = MediaQuery.of(context).size.height;

    final height = scaffoldHeight * 0.4;
    final width = scaffoldWidth * 1;

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
      if (val["type"] == "variable") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleProductScreen(id: val["id"]),
          ),
        );
      } else {
        Map<String, dynamic> data = {
          "id": val["id"],
          "name": val["name"],
          "price": val["price"],
          "qty": 1,
          "variation_id": "",
          "image": val["images"][0]["src"]
        };
        final prefs = await SharedPreferences.getInstance();
        final String? cartDetails = prefs.getString('cart');

        if (cartDetails == null) {
          var data1 = [...cartList, data];
          cartList = data1;
          var newData = jsonEncode(cartList);
          await prefs.setString('cart', newData);
        } else {
          List cartDetail = jsonDecode(cartDetails);

          if (cartDetail.length == 0) {
            setState(() {
              if (cartDetail.any((item) => item["id"] == data["id"])) {
                var data1 = [...cartList];
                cartList = data1;
                showSnackBar(context, "Item already in the cart");
              } else {
                var data1 = [...cartList, data];
                cartList = data1;
                showSnackBar(context, "Item add to cart");
              }
            });
            var newData = jsonEncode(cartList);
            await prefs.setString('cart', newData);
          } else {
            setState(() {
              if (cartDetail.any((item) => item["id"] == data["id"])) {
                var data1 = [...cartDetail];
                cartList = data1;
                showSnackBar(context, "Item already in the cart");
              } else {
                var data1 = [...cartDetail, data];
                cartList = data1;
                showSnackBar(context, "Item add to cart");
              }
            });
            var newData = jsonEncode(cartList);
            await prefs.setString('cart', newData);
          }
        }
      }
    }

    return FutureBuilder<dynamic>(
        future: getProducts(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Container(
                    alignment: Alignment.center,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: LayoutBuilder(
                      builder: ((context, constraints) {
                        return GestureDetector(
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
                            padding: EdgeInsets.all(2),
                            margin: EdgeInsets.all(width * 0.005),
                            width: width * 0.47,
                            height: height,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: GlobalVariables.baseColor,
                                    width: 2,
                                    style: BorderStyle.solid)),
                            child: Column(
                              children: [
                                Container(
                                  height: height * 0.5,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      width: double.infinity,
                                      height: height * 0.6,
                                      fit: BoxFit.fill,
                                      imageUrl: snapshot.data[index]["images"]
                                          [0]["src"],
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      placeholder: ((context, url) => Container(
                                            child: Center(
                                              child: CircularProgressIndicator
                                                  .adaptive(
                                                backgroundColor:
                                                    Colors.pinkAccent,
                                                strokeWidth: 1,
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 5,
                                  color: GlobalVariables.baseColor,
                                ),
                                Container(
                                  height: height * 0.2,
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: height * 0.03),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          snapshot.data[index]["name"]
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: GlobalVariables.baseColor,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      Text(
                                        "Price: ${GlobalVariables.currency + snapshot.data[index]["price"]}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: GlobalVariables.black,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 3,
                                  color: GlobalVariables.baseColor,
                                ),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.resolveWith(
                                                (states) {
                                          // If the button is pressed, return green, otherwise blue
                                          if (states.contains(
                                              MaterialState.pressed)) {
                                            return Colors.blue;
                                          }
                                          return GlobalVariables.baseColor;
                                        }),
                                        elevation: MaterialStateProperty
                                            .resolveWith<double?>(
                                                (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.pressed)) return 20;
                                          return null;
                                        }),
                                      ),
                                      onPressed: () {
                                        getOrder(snapshot.data[index]);
                                      },
                                      child: Text('Subscripe'),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const SpinKitDoubleBounce(
            color: Color.fromARGB(255, 194, 109, 109),
            size: 50.0,
          );
        });
  }
}
