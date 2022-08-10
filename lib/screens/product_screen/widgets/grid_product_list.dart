import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

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
              itemCount: 10,
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
                            Container(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight * 0.7,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: Image(
                                  image: NetworkImage(
                                      snapshot.data[index]["images"][0]["src"]),
                                ),
                              ),
                            ),
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
