// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitmma/constant_widgets/app_bar.dart';
import 'package:unitmma/scaffold/scaffold.dart';
import 'package:unitmma/screens/cart_screen/cart_screen.dart';
import 'package:unitmma/screens/home_screen/home.dart';
import 'package:unitmma/screens/product_screen/widgets/card.dart';
import 'package:unitmma/screens/product_screen/widgets/grid_product_list.dart';
import "package:http/http.dart" as http;

import '../../constants/global_variables.dart';
import '../checkout_screen/check_out.dart';

enum SingingCharacter { freeShipping }

class ShippingScreen extends StatefulWidget {
  final int total;
  const ShippingScreen({Key? key, required this.total}) : super(key: key);

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  var value = "";
  int amount = 0;
  var id = "";

  Map<String, String> headers = {"Content-Type": "application/json"};

  getCategorie() async {
    final res = await http.get(
        Uri.parse(
            "https://theunitmma.co.uk/wp-json/wc/v2/shipping/zones/1/methods?consumer_key=ck_dc42350e0d839a416bb73fdef9984544907a8fdb&consumer_secret=cs_023b27d43090a807fc43d77cda696a15cc87442e"),
        headers: headers);
    final result = jsonDecode(res.body);

    if (int.parse(result[0]["settings"]["min_amount"]["value"]) <=
        widget.total) {
      setState(() {
        value = result[0]["title"];
        amount = 0;
        id = result[0]["method_id"];
      });
    } else {
      setState(() {
        value = result[1]["title"];
        amount = int.parse(result[1]["settings"]["cost"]["value"]);
        id = result[1]["method_id"];
      });
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('value', value);
    await prefs.setInt('amount', amount);
    await prefs.setString('id', id);
    final String? value1 = prefs.getString('value');
    final int? amount1 = prefs.getInt('amount');

    final String? id1 = prefs.getString('id');

    print("ciwbdciwbvciywbvc" + value1!);
    print("ciwbdciwbvciywbvc" + amount1!.toString());
    print("ciwbdciwbvciywbvc" + id1!);
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

  SingingCharacter? _character = SingingCharacter.freeShipping;

  @override
  Widget build(BuildContext context) {
    final scaffoldWidth = MediaQuery.of(context).size.width;
    final scaffoldHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: GlobalVariables.baseColor),
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
                  child: const Icon(Icons.shopping_cart_checkout_outlined,
                      color: GlobalVariables.baseColor),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: GlobalVariables.white,
        title: Text(
          "Shipping",
          style: TextStyle(color: GlobalVariables.baseColor),
        ),
        centerTitle: true,
      ),
      // ignore: prefer_const_constructors
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                width: scaffoldWidth,
                height: scaffoldHeight * 0.15,
                color: Color.fromARGB(255, 244, 240, 240),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                          value.toString() +
                              " " +
                              GlobalVariables.currency +
                              amount.toString(),
                          style: TextStyle(color: GlobalVariables.baseColor)),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.freeShipping,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                          " Total :  ${GlobalVariables.currency}${widget.total + amount}",
                          style: TextStyle(
                              color: Color.fromARGB(255, 18, 7, 7),
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CheckOutScreen(),
                  ),
                );
              },
              child: Text("Check Out"),
            ),
          ],
        ),
      ),
    );
  }
}
