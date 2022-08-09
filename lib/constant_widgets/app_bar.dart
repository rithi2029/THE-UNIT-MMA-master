import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unitmma/constants/global_variables.dart';

var appBar = AppBar(
  leading: const Icon(
    Icons.menu,
    color: GlobalVariables.baseColor,
  ),
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
            onTap: () {},
            child: const Icon(Icons.shopping_cart_checkout_outlined,
                color: GlobalVariables.baseColor),
          ),
        ],
      ),
    ),
  ],
  backgroundColor: GlobalVariables.white,
  title: const Image(
    width: 200,
    height: 50,
    image: NetworkImage(
        "https://theunitmma.co.uk/wp-content/uploads/2021/09/cropped-the-unit-mixed-martial-arts.jpg",
        scale: 0.5),
  ),
  centerTitle: true,
);
