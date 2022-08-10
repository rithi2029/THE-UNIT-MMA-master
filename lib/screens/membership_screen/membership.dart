import 'package:flutter/material.dart';
import 'package:unitmma/scaffold/scaffold.dart';
import 'package:unitmma/screens/home_screen/home.dart';
import 'package:unitmma/screens/product_screen/widgets/card.dart';
import 'package:unitmma/screens/product_screen/widgets/grid_product_list.dart';

import '../../constants/global_variables.dart';

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldWidth = MediaQuery.of(context).size.width;
    final scaffoldHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ScaffoldScreen(),
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
        title: const Text(
          "Membership",
          style: TextStyle(color: GlobalVariables.baseColor),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: scaffoldWidth,
        height: scaffoldHeight,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: scaffoldWidth,
                height: scaffoldHeight * 0.3,
                child: const Cards(
                  url:
                      "https://theunitmma.co.uk/wp-content/uploads/2022/02/IMG_9633-scaled.jpg",
                ),
              ),
              SizedBox(
                width: scaffoldWidth,
                height: scaffoldHeight * 10,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: MyWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
