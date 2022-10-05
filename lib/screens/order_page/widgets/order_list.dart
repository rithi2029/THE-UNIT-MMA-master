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

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<Map<String, dynamic>> _orders = [];
  @override
  Widget build(BuildContext context) {
    final scaffoldWidth = MediaQuery.of(context).size.width;
    final scaffoldHeight = MediaQuery.of(context).size.height;

    final height = scaffoldHeight * 0.4;
    final width = scaffoldWidth * 1;

    Map<String, String> headers = {"Content-Type": "application/json"};

    Future getOrders() async {
      final res = await http.get(
          Uri.parse(
              "https://theunitmma.co.uk/wp-json/wc/v2/Orders?consumer_key=ck_dc42350e0d839a416bb73fdef9984544907a8fdb&consumer_secret=cs_023b27d43090a807fc43d77cda696a15cc87442e"),
          headers: headers);
      final result = jsonDecode(res.body);
      setState() {
        _orders = result;
      }

      return _orders;
    }

    return FutureBuilder<dynamic>(
        future: getOrders(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            print(snapshot);
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return ListTile(
                  title: Card(
                    elevation: 3,
                    shadowColor: GlobalVariables.baseColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      width: scaffoldWidth,
                      height: scaffoldHeight * 0.15,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Order Id : ",
                                  style: TextStyle(
                                    color: GlobalVariables.baseColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  "# " + snapshot.data[i]['id'].toString(),
                                  style: TextStyle(
                                    color: GlobalVariables.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Ordered Date : ",
                                  style: TextStyle(
                                    color: GlobalVariables.baseColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  snapshot.data[i]['date_created'].toString(),
                                  style: TextStyle(
                                    color: GlobalVariables.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Status : ",
                                  style: TextStyle(
                                    color: GlobalVariables.baseColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  snapshot.data[i]['status'].toString(),
                                  style: TextStyle(
                                    color: GlobalVariables.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Total : ",
                                  style: TextStyle(
                                    color: GlobalVariables.baseColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  GlobalVariables.currency +
                                      snapshot.data[i]['total'].toString(),
                                  style: TextStyle(
                                    color: GlobalVariables.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
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
