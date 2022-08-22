import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:unitmma/screens/product_screen/product.dart';

import '../../constants/global_variables.dart';
import '../../scaffold/scaffold.dart';
import '../product_screen/widgets/grid_product_list.dart';
import "package:http/http.dart" as http;

class SingleProductScreen extends StatelessWidget {
  final int id;
  const SingleProductScreen({Key? key, required this.id}) : super(key: key);

  get scaffoldWidth => null;

  @override
  Widget build(BuildContext context) {
    final scaffoldWidth = MediaQuery.of(context).size.width;
    final scaffoldHeight = MediaQuery.of(context).size.height;

    Map<String, String> headers = {"Content-Type": "application/json"};

    Future<dynamic> getSingleProduct() async {
      final res = await http.get(
          Uri.parse(
              "https://theunitmma.co.uk/wp-json/wc/v2/products/$id?consumer_key=ck_dc42350e0d839a416bb73fdef9984544907a8fdb&consumer_secret=cs_023b27d43090a807fc43d77cda696a15cc87442e"),
          headers: headers);
      final result = jsonDecode(res.body);
      return result;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: GlobalVariables.baseColor,
          ),
        ),
        actions: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.search_rounded,
                      color: GlobalVariables.baseColor),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.shopping_cart_checkout_outlined,
                      color: GlobalVariables.baseColor),
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
//hence

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
                      height: 250,
                      child: ClipRRect(
                        child: Image(
                          fit: BoxFit.fill,
                          image:
                              NetworkImage(snapshot.data["images"][0]["src"]),
                        ),
                      ),
                    ),
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "DESCRIPTION",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Html(data: snapshot.data["description"], style: {
                          "div": Style(
                              backgroundColor:
                                  Color.fromARGB(0, 255, 255, 255)),
                          "body": Style(
                            backgroundColor: Color.fromARGB(255, 245, 240, 240),
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
                          child: Text("£  ${snapshot.data["price"]}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 18)),
                        ),
                      ],
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
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                primary: GlobalVariables.baseColor,
                                onPrimary: GlobalVariables.white),
                            child: const Text("Add to cart"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
