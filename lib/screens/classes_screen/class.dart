import 'package:flutter/material.dart';
import 'package:unitmma/constants/global_variables.dart';
import 'package:unitmma/scaffold/scaffold.dart';
import 'package:unitmma/screens/classes_screen/class_widget.dart';
import 'package:unitmma/screens/membership_screen/widget/member_ship_widget.dart';

class ClassScreen extends StatelessWidget {
  const ClassScreen({Key? key}) : super(key: key);

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: scaffoldWidth,
                height: scaffoldHeight * 1,
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: ClassWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
