import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitmma/constants/global_variables.dart';
import 'package:unitmma/screens/Auth/signin/signin.dart';
import 'package:unitmma/screens/Auth/signup/signup.dart';
import 'package:unitmma/screens/product_detail_screen/single_product_screen.dart';

import '../../../constants/utils.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  var cartList = <dynamic>[];
  var _cat = [];
  Map<String, String> headers = {"Content-Type": "application/json"};

  getCategorie() async {
    final res = await http.get(
        Uri.parse(
            "https://theunitmma.co.uk/wp-json/wc/v2/products?consumer_key=ck_dc42350e0d839a416bb73fdef9984544907a8fdb&consumer_secret=cs_023b27d43090a807fc43d77cda696a15cc87442e"),
        headers: headers);
    final result = jsonDecode(res.body);
    for (var info in result) {
      print(info["categories"][0]["name"]);
      if (info["categories"].length != 0 &&
          info["categories"][0]["name"] == "Products") {
        setState(() {
          _cat = [..._cat, info];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCategorie();
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

    final height = scaffoldHeight * 0.4;
    final width = scaffoldWidth * 1;

    Map<String, String> headers = {"Content-Type": "application/json"};

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
          "variation_id": 0,
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
              cartList = cartDetail;
              if (cartDetail.any((item) => item["id"] == data["id"])) {
                var data1 = [...cartList];
                cartList = data1;
                showSnackBar(context, "${data["name"]}  already in the cart");
              } else {
                var data1 = [...cartList, data];
                cartList = data1;
                showSnackBar(context, "${data["name"]} add to cart");
              }
            });
            var newData = jsonEncode(cartList);
            await prefs.setString('cart', newData);
          } else {
            setState(() {
              if (cartDetail.any((item) => item["id"] == data["id"])) {
                var data1 = [...cartDetail];
                cartList = data1;
                showSnackBar(context, "${data["name"]}  already in the cart");
              } else {
                var data1 = [...cartDetail, data];
                cartList = data1;
                showSnackBar(context, "${data["name"]} add to cart");
              }
            });
            var newData = jsonEncode(cartList);
            await prefs.setString('cart', newData);
          }
        }
      }
    }

    if (_cat.isNotEmpty) {
      return GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 2 / 3,
          ),
          itemCount: _cat.length,
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
                          builder: (context) =>
                              SingleProductScreen(id: _cat[index]["id"]),
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
                                imageUrl: _cat[index]["images"][0]["src"],
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                placeholder: ((context, url) => Container(
                                      child: const Center(
                                        child:
                                            CircularProgressIndicator.adaptive(
                                          backgroundColor: Colors.pinkAccent,
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
                            height: height * 0.18,
                            width: double.infinity,
                            margin:
                                EdgeInsets.symmetric(horizontal: height * 0.03),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  child: Text(
                                    _cat[index]["name"].toString(),
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: GlobalVariables.baseColor,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                                Text(
                                  "Price: ${GlobalVariables.currency + _cat[index]["price"]}",
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
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return Colors.blue;
                                    }
                                    return GlobalVariables.baseColor;
                                  }),
                                  elevation: MaterialStateProperty.resolveWith<
                                      double?>((Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return 20;
                                    return null;
                                  }),
                                ),
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final String? user_mail =
                                      prefs.getString('action');
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
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Center(
                                                          child: Text(
                                                        "Login",
                                                        style: TextStyle(
                                                            color:
                                                                GlobalVariables
                                                                    .baseColor,
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                                FontWeight
                                                                    .bold)),
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
                                                              EdgeInsets.all(
                                                                  0.0),
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
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                "Login",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15),
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
                                                              EdgeInsets.all(
                                                                  0.0),
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
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                "Register",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15),
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
                                    getOrder(_cat[index]);
                                  }
                                },
                                child: _cat[index]["type"] == "simple"
                                    ? Text('Add to cart')
                                    : Text('View'),
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
    } else {
      return const SpinKitDoubleBounce(
        color: Color.fromARGB(255, 194, 109, 109),
        size: 50.0,
      );
    }

    // By default, show a loading spinner.
  }
}
