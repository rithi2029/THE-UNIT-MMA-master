import 'dart:convert';
import 'dart:math';

import 'package:unitmma/model/product_model.dart';
import 'package:woocommerce_api/woocommerce_api.dart';
import "package:http/http.dart" as http;

class APICall {
  //getting product details
  getProducts() async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    try {
      final res = await http.get(
          Uri.parse(
              "https://theunitmma.co.uk/wp-json/wc/v2/products?consumer_key=ck_dc42350e0d839a416bb73fdef9984544907a8fdb&consumer_secret=cs_023b27d43090a807fc43d77cda696a15cc87442e"),
          headers: headers);

      if (res.statusCode == 200) {
        final result = jsonDecode(res.body);

        return result;
      } else {
        print("error");
      }
    } catch (e) {
      print(e);
    }
  }
}
