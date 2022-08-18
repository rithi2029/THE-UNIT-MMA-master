import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:unitmma/api/api_call.dart';
import 'package:unitmma/model/product_model.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late Product product;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future getProducts() async {
      // Initialize the API
      WooCommerceAPI wooCommerceAPI = WooCommerceAPI(
          url: "https://theunitmma.co.uk/",
          consumerKey: "ck_dc42350e0d839a416bb73fdef9984544907a8fdb",
          consumerSecret: "cs_023b27d43090a807fc43d77cda696a15cc87442e");

      // Get data using the "products" endpoint
      final products = await wooCommerceAPI.getAsync("products");
      return (products);
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
              itemCount: 2,
              itemBuilder: (BuildContext ctx, index) {
                return Container(
                  alignment: Alignment.center,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: LayoutBuilder(builder: ((context, constraints) {
                      return Container(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: Column(
                          children: [
                            // Image(),
                            Text(snapshot.data[index]["name"].toString()),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(snapshot.data[index]["price"]),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    })),
                  ),
                );
              });
        });
  }
}
