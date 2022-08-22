// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:unitmma/constant_widgets/app_bar.dart';
import 'package:unitmma/scaffold/scaffold.dart';
import 'package:unitmma/screens/home_screen/home.dart';
import 'package:unitmma/screens/news_screen/widget/newa_list.dart';
import 'package:unitmma/screens/product_screen/widgets/card.dart';
import 'package:unitmma/screens/product_screen/widgets/grid_product_list.dart';

import '../../constants/global_variables.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldWidth = MediaQuery.of(context).size.width;
    final scaffoldHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: appBar,
      // ignore: prefer_const_constructors
      body: Column(
        children: [
          Container(
            color: GlobalVariables.baseColor,
            width: scaffoldWidth,
            height: scaffoldHeight * 0.06,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ScaffoldScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: GlobalVariables.white,
                    ),
                  ),
                  const Text(
                    "News",
                    style: TextStyle(
                        color: GlobalVariables.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          NewsList(),
        ],
      ),
    );
  }
}
