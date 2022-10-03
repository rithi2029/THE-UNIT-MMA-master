import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitmma/screens/product_screen/product.dart';

import '../../constants/global_variables.dart';
import '../../constants/utils.dart';
import '../../scaffold/scaffold.dart';
import '../Auth/signin/signin.dart';
import '../Auth/signup/signup.dart';
import '../cart_screen/cart_screen.dart';
import '../product_screen/widgets/grid_product_list.dart';
import "package:http/http.dart" as http;

class SingleProductScreen extends StatefulWidget {
  final int id;
  const SingleProductScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<SingleProductScreen> createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  List<Map<String, dynamic>> variant = [];
  var cartList = <dynamic>[];
  Map<String, dynamic> data = {};

  late var variation_id;

  int _visibilty = 100;
  int badgeCount = 0;

  String sale_price = "--";
  initialState() async {
    final prefs = await SharedPreferences.getInstance();

    final String? cartDetails = prefs.getString('cart');

    List cartDetail = jsonDecode(cartDetails!);
    setState(() {
      badgeCount = cartDetail.length;
    });
    print(badgeCount);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialState();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldWidth = MediaQuery.of(context).size.width;
    final scaffoldHeight = MediaQuery.of(context).size.height;
    List _option = [];

    Map<String, String> headers = {"Content-Type": "application/json"};

    getOrder(val) async {
      print("checking");
      if (val["type"] == "variable") {
        setState(() {
          data = {
            "id": val["id"],
            "name": val["name"],
            "price": sale_price,
            "qty": 1,
            "variation_id": variation_id,
            "image": val["images"][0]["src"]
          };
        });
      } else {
        setState(() {
          data = {
            "id": val["id"],
            "name": val["name"],
            "price": val["price"],
            "qty": 1,
            "variation_id": 0,
            "image": val["images"][0]["src"]
          };
        });
      }
      final prefs = await SharedPreferences.getInstance();
      final String? cartDetails = prefs.getString('cart');

      if (cartDetails == null) {
        var data1 = [...cartList, data];
        cartList = data1;
        var newData = jsonEncode(cartList);
        await prefs.setString('cart', newData);
        showSnackBar(context, "${data["name"]}  added to cart");
      } else {
        List cartDetail = jsonDecode(cartDetails);

        if (cartDetail.isEmpty) {
          setState(() {
            if (cartDetail.any((item) => item["id"] == data["id"])) {
              var data1 = [...cartList];
              cartList = data1;
              showSnackBar(context, "${data["name"]}  already in the cart");
            } else {
              var data1 = [...cartList, data];
              cartList = data1;
              showSnackBar(context, "${data["name"]}  added to cart");
            }
          });
          var newData = jsonEncode(cartList);
          await prefs.setString('cart', newData);
        } else {
          setState(() {
            if (val["type"] == "variable") {
              if (cartDetail.any(
                  (item) => item["variation_id"] == data["variation_id"])) {
                var data1 = [...cartDetail];
                cartList = data1;
                showSnackBar(context, "${data["name"]}  already in the cart");
              } else {
                var data1 = [...cartDetail, data];
                cartList = data1;
                showSnackBar(context, "${data["name"]} added to cart");
              }
            } else {
              if (cartDetail.any((item) => item["id"] == data["id"])) {
                var data1 = [...cartDetail];
                cartList = data1;
                showSnackBar(context, "${data["name"]}  already in the cart");
              } else {
                var data1 = [...cartDetail, data];
                cartList = data1;
                showSnackBar(context, "${data["name"]}  added to cart");
              }
            }
          });
          var newData = jsonEncode(cartList);
          await prefs.setString('cart', newData);
        }
      }
    }

    getvarients() async {
      var varient1 = [];
      var varient2 = [];

      final res = await http.get(
          Uri.parse(
              "https://theunitmma.co.uk/wp-json/wc/v2/products/${widget.id}/variations?consumer_key=ck_dc42350e0d839a416bb73fdef9984544907a8fdb&consumer_secret=cs_023b27d43090a807fc43d77cda696a15cc87442e"),
          headers: headers);
      List result = jsonDecode(res.body);
      for (var info in variant) {
        varient1 = [...varient1, info["value"]];
        for (var info in result) {
          for (var val in info["attributes"]) {
            varient2 = [...varient2, val["option"]];

            if (listEquals(varient1, varient2)) {
              var objIndex =
                  result.indexWhere((element) => element["id"] == info["id"]);
              if (objIndex >= 0) {
                var info = result[objIndex];
                print(info["id"]);
                setState(() {
                  sale_price = info["sale_price"];
                  variation_id = info["id"];
                });
              }
              break;
            }
          }
          varient2 = [];
        }
      }
    }

    String varientName(val) {
      print(variant);
      late String data = "";
      if (variant.length == 0) {
        data = "Choose Value";
      } else {
        var objIndex = variant
            .indexWhere((element) => element["position"] == val["position"]);
        if (objIndex >= 0) {
          var info = variant[objIndex];
          info.isEmpty ? data = "Choose Value" : data = info["value"];
        }
        // var datas = variant[objIndex];
      }
      return data;

      // int objIndex =
      //     variant.indexWhere((element) => element["position"] == val);
      // Map data = variant[objIndex];
    }

    Future<dynamic> getSingleProduct() async {
      final res = await http.get(
          Uri.parse(
              "https://theunitmma.co.uk/wp-json/wc/v2/products/${widget.id}?consumer_key=ck_dc42350e0d839a416bb73fdef9984544907a8fdb&consumer_secret=cs_023b27d43090a807fc43d77cda696a15cc87442e"),
          headers: headers);
      final result = jsonDecode(res.body);
      return result;
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: GlobalVariables.baseColor),

        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.of(context).push(
        //       MaterialPageRoute(
        //         builder: (context) => ProductScreen(),
        //       ),
        //     );
        //   },
        //   icon: const Icon(
        //     Icons.arrow_back_rounded,
        //     color: GlobalVariables.baseColor,
        //   ),
        // ),
        actions: [
          Container(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {},
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
        title: const Text(
          "Product",
          style: TextStyle(color: GlobalVariables.baseColor),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<dynamic>(
          future: getSingleProduct(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 60,
                        color: Colors.amber[50],
                        child: Center(
                          child: Text(
                            snapshot.data["name"],
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: scaffoldHeight * 0.4,
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            fit: BoxFit.contain,
                            imageUrl: snapshot.data["images"][0]["src"],
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            placeholder: ((context, url) => Container(
                                  child: Center(
                                    child: CircularProgressIndicator.adaptive(
                                      backgroundColor: Colors.pinkAccent,
                                      strokeWidth: 1,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ),
                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "DESCRIPTION :",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Html(data: snapshot.data["description"], style: {
                            "div": Style(
                                backgroundColor:
                                    Color.fromARGB(0, 255, 255, 255)),
                            "body": Style(
                              backgroundColor:
                                  Color.fromARGB(255, 245, 240, 240),
                              padding: EdgeInsets.all(5),
                            )
                          }),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: snapshot.data["type"] == "simple"
                                ? Text("£  ${snapshot.data["price"]}")
                                : Text("£  ${sale_price}"),
                            // : Html(
                            //     data: snapshot.data["price_html"],
                            //     style: {}),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: snapshot.data["attributes"].length != 0,
                        child: Column(children: [
                          for (var item in snapshot.data["attributes"])
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: scaffoldWidth * 0.3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: Text(item["name"] + ":")),
                                    ),
                                  ),
                                  Container(
                                    width: scaffoldWidth * 0.4,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: (() {
                                            if (_visibilty ==
                                                item["position"]) {
                                              setState(() {
                                                _visibilty = 1000;
                                              });
                                            } else {
                                              setState(() {
                                                _visibilty = item["position"];
                                              });
                                            }
                                          }),
                                          child: Container(
                                              width: scaffoldWidth * 0.3,
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        GlobalVariables.black,
                                                    width: 1,
                                                    style: BorderStyle.solid),
                                              ),
                                              child: Center(
                                                child: Text(varientName(item)),
                                              )),
                                        ),
                                        for (var info in item["options"])
                                          Column(
                                            children: [
                                              Visibility(
                                                visible: item["position"] ==
                                                    _visibilty,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    getvarients();
                                                    setState(() {
                                                      _visibilty = 1000;
                                                    });
                                                    if (variant.isEmpty) {
                                                      setState(() {
                                                        variant = [
                                                          ...variant,
                                                          {
                                                            "id": item["id"],
                                                            "position": item[
                                                                "position"],
                                                            "name":
                                                                item["name"],
                                                            "value": info
                                                          }
                                                        ];
                                                      });
                                                    } else {
                                                      var contain = variant
                                                          .where((element) =>
                                                              element[
                                                                  "position"] ==
                                                              item["position"]);
                                                      if (contain.isEmpty) {
                                                        setState(() {
                                                          variant = [
                                                            ...variant,
                                                            {
                                                              "id": item["id"],
                                                              "position": item[
                                                                  "position"],
                                                              "name":
                                                                  item["name"],
                                                              "value": info
                                                            }
                                                          ];
                                                        });
                                                      } else {
                                                        getvarients();
                                                        setState(() {
                                                          variant.removeWhere(
                                                              (element) =>
                                                                  element[
                                                                      "position"] ==
                                                                  item[
                                                                      "position"]);

                                                          variant = [
                                                            ...variant,
                                                            {
                                                              "id": item["id"],
                                                              "position": item[
                                                                  "position"],
                                                              "name":
                                                                  item["name"],
                                                              "value": info
                                                            }
                                                          ];
                                                        });
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                      width:
                                                          scaffoldWidth * 0.3,
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: 1,
                                                              style: BorderStyle
                                                                  .solid)),
                                                      child: Center(
                                                        child: Text(
                                                            info.toString()),
                                                      )),
                                                ),
                                              ),
                                            ],
                                          )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  primary: GlobalVariables.baseColor,
                                  onPrimary: GlobalVariables.white),
                              child: const Text("Buy Now"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                final String? user_mail =
                                    prefs.getString('action');
                                print(user_mail.toString());
                                if (user_mail == "" || user_mail == null) {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      actions: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  ListTile(
                                                    trailing: IconButton(
                                                      icon: new Icon(
                                                        Icons.close,
                                                        size: 20.0,
                                                        color: Colors.black,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                  ListTile(
                                                    title: Center(
                                                        child: Text(
                                                      "Login",
                                                      style: TextStyle(
                                                          color: GlobalVariables
                                                              .baseColor,
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Container(
                                                    height: 100.0,
                                                    width: 300.0,
                                                    child: Image(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(
                                                          "https://theunitmma.co.uk/wp-content/uploads/2021/09/cropped-the-unit-mixed-martial-arts.jpg",
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: 20.0,
                                                  ),
                                                  Text(
                                                      "You need to login or register to book the event",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(
                                                    height: 20.0,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Container(
                                                      width: 300.0,
                                                      height: 50.0,
                                                      child: RaisedButton(
                                                        color: GlobalVariables
                                                            .baseColor,
                                                        //   color:  Color(0xff88be4c),
                                                        onPressed: () {
                                                          Navigator
                                                              .pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        SignInScreen()),
                                                          );
                                                        },

                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                        padding:
                                                            EdgeInsets.all(0.0),
                                                        child: Ink(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0)),
                                                          child: Container(
                                                            width: 200.0,
                                                            constraints:
                                                                BoxConstraints(
                                                                    maxWidth:
                                                                        250.0,
                                                                    minHeight:
                                                                        50.0),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "Login",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Container(
                                                      width: 300.0,
                                                      height: 50.0,
                                                      child: RaisedButton(
                                                        color: GlobalVariables
                                                            .baseColor,
                                                        //   color:  Color(0xff88be4c),
                                                        onPressed: () {
                                                          Navigator
                                                              .pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        SignUpScreen()),
                                                          );
                                                        },

                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                        padding:
                                                            EdgeInsets.all(0.0),
                                                        child: Ink(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0)),
                                                          child: Container(
                                                            width: 200.0,
                                                            constraints:
                                                                BoxConstraints(
                                                                    maxWidth:
                                                                        250.0,
                                                                    minHeight:
                                                                        50.0),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "Register",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                } else {
                                  getOrder(snapshot.data);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: GlobalVariables.baseColor,
                                  onPrimary: GlobalVariables.white),
                              child: snapshot.data["categories"][0]["name"] ==
                                      "Memberships"
                                  ? Text("subscripe")
                                  : Text("Add to cart"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const SpinKitDoubleBounce(
              color: Color.fromARGB(255, 245, 232, 232),
              size: 30.0,
            );
          }),
    );
  }
}
