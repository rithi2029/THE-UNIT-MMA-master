import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitmma/constants/global_variables.dart';
import 'package:http/http.dart' as http;

import '../../constants/utils.dart';
import '../product_screen/product.dart';

enum SingingCharacter { netBanking, card, payondelivery }

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const PaymentScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  SingingCharacter? _character = SingingCharacter.netBanking;

  List<Map<String, dynamic>> _orders = [];
  @override
  Widget build(BuildContext context) {
    getDatas() async {
      final prefs = await SharedPreferences.getInstance();
      final String? cartDetails = prefs.getString('cart');
      final int? user_id = prefs.getInt('user_id');

      List cartDetail = jsonDecode(cartDetails!);
      for (var info in cartDetail) {
        Map<String, dynamic> newData = {
          "product_id": info["id"],
          "quantity": info["qty"],
          "variation_id": info["variation_id"],
        };

        setState(() {
          _orders = [..._orders, newData];
        });
      }
      Map<String, dynamic> object = widget.data;
      final response = await http.put(
        Uri.parse(
            "https://theunitmma.co.uk/wp-json/wc/v2/customers/$user_id?consumer_key=ck_dc42350e0d839a416bb73fdef9984544907a8fdb&consumer_secret=cs_023b27d43090a807fc43d77cda696a15cc87442e"),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(object),
        // body: {"first_name":"Divyalakshmy10","billing":{"first_name":"Divyalakshmy0","address_1":"4/462,Kapparngr0,Kongalapuram0","address_2":"sithurajapuram post0","city":"svks0","postcode":"626190"}}
      );
      if (response.statusCode == 200) {
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }

      Map<String, dynamic> orderpayload = {
        'customer_id': user_id.toString(),
        'payment_method': "bacs",
        'payment_method_title': "Direct Bank Transfer",
        'set_paid': true,
        'billing': widget.data["billing"],
        'shipping': widget.data["shipping"],
        "line_items": _orders,
      };
      String body = jsonEncode(orderpayload);
      final orderesponse = await http.post(
          Uri.parse(
              "https://theunitmma.co.uk/wp-json/wc/v2/orders?consumer_key=ck_dc42350e0d839a416bb73fdef9984544907a8fdb&consumer_secret=cs_023b27d43090a807fc43d77cda696a15cc87442e"),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: body);
      print(orderesponse.statusCode);

      if (orderesponse.statusCode == 201) {
        prefs.setString('cart', "[]");
        setState(() {
          showSnackBar(context, "Order Placed");
        });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductScreen(),
            ));
      } else {
        // If tha              showSnackBar(context, "${data["name"]}  already in the cart");
        throw Exception('Failed to load post');
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
          "Payment",
          style: TextStyle(color: GlobalVariables.baseColor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Net Banking'),
              leading: Radio<SingingCharacter>(
                value: SingingCharacter.netBanking,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              selectedTileColor: Colors.orange[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              title: const Text('Add Debit/Credit/ATM Cart'),
              leading: Radio<SingingCharacter>(
                value: SingingCharacter.card,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Pay on Delivery'),
              leading: Radio<SingingCharacter>(
                value: SingingCharacter.payondelivery,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      // If the button is pressed, return green, otherwise blue
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blue;
                      }
                      return GlobalVariables.baseColor;
                    }),
                    elevation: MaterialStateProperty.resolveWith<double?>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) return 20;
                      return null;
                    }),
                  ),
                  onPressed: () {
                    getDatas();
                  },
                  child: Text('Place My Order'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
