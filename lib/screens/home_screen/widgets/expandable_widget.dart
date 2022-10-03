import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unitmma/constants/global_variables.dart';
import "package:http/http.dart" as http;

import '../../product_detail_screen/single_product_screen.dart';

class HomeCards extends StatefulWidget {
  final double width;
  final double height;
  final String title;

  final Function routing;

  HomeCards(
      {Key? key,
      required this.width,
      required this.height,
      required this.title,
      required this.routing})
      : super(key: key);

  @override
  State<HomeCards> createState() => _HomeCardsState();
}

class _HomeCardsState extends State<HomeCards> {
  var _cat = [];
  Map<String, String> headers = {"Content-Type": "application/json"};

  getCategorie() async {
    final res = await http.get(
        Uri.parse(
            "https://theunitmma.co.uk/wp-json/wc/v2/products?consumer_key=ck_dc42350e0d839a416bb73fdef9984544907a8fdb&consumer_secret=cs_023b27d43090a807fc43d77cda696a15cc87442e"),
        headers: headers);
    final result = jsonDecode(res.body);
    for (var info in result) {
      if (info["categories"].length != 0 &&
          info["categories"][0]["name"] == widget.title) {
        setState(() {
          _cat = [..._cat, info];
        });
      }
    }

    return "rithi";
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
    if (_cat.length != 0) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: GlobalVariables.baseColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.routing();
                    },
                    child: const Text(
                      "Sell All",
                      style: TextStyle(
                        color: GlobalVariables.baseColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: widget.height,
                width: widget.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _cat.length,
                  itemBuilder: ((context, index) {
                    if (_cat.length != 0) {
                      return Container(
                        padding: EdgeInsets.all(2),
                        margin: EdgeInsets.symmetric(
                            horizontal: widget.width * 0.005),
                        width: widget.width * 0.47,
                        height: widget.height,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: GlobalVariables.baseColor,
                                width: 2,
                                style: BorderStyle.solid)),
                        child: Column(
                          children: [
                            Container(
                              height: widget.height * 0.5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  width: double.infinity,
                                  height: widget.height * 0.6,
                                  fit: BoxFit.fill,
                                  imageUrl: _cat[index]["images"][0]["src"],
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  placeholder: ((context, url) => Container(
                                        child: Center(
                                          child: CircularProgressIndicator
                                              .adaptive(
                                            backgroundColor: Colors.pinkAccent,
                                            strokeWidth: 1,
                                            semanticsLabel: "rithi",
                                            semanticsValue: "rithi",
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                            ),
                            Divider(
                              color: GlobalVariables.baseColor,
                            ),
                            Container(
                              height: widget.height * 0.2,
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(
                                  horizontal: widget.height * 0.03),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    child: Text(
                                      _cat[index]["name"].toString(),
                                      style: TextStyle(
                                          fontSize: 12,
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
                                    elevation: MaterialStateProperty
                                        .resolveWith<double?>(
                                            (Set<MaterialState> states) {
                                      if (states.contains(
                                          MaterialState.pressed)) return 20;
                                      return null;
                                    }),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SingleProductScreen(
                                                id: _cat[index]["id"]),
                                      ),
                                    );
                                  },
                                  child: Text('Add to cart'),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        width: double.infinity,
                        height: widget.height * 0.6,
                        child: Center(
                          child: CircularProgressIndicator.adaptive(
                            backgroundColor: Colors.pinkAccent,
                            strokeWidth: 1,
                          ),
                        ),
                      );
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: widget.height * 0.6,
        child: Center(
          child: CircularProgressIndicator.adaptive(
            backgroundColor: Colors.pinkAccent,
            strokeWidth: 1,
          ),
        ),
      );
    }
  }
}
