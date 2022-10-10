import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unitmma/constants/global_variables.dart';
import 'package:unitmma/scaffold/scaffold.dart';
import 'package:unitmma/screens/classes_screen/class.dart';
import 'package:unitmma/screens/classes_screen/class_widget.dart';
import 'package:unitmma/screens/membership_screen/widget/member_ship_widget.dart';

class ClassDetail extends StatefulWidget {
  final Map<String, dynamic> data;
  const ClassDetail({Key? key, required this.data}) : super(key: key);

  @override
  State<ClassDetail> createState() => _ClassDetailState();
}

class _ClassDetailState extends State<ClassDetail> {
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
                builder: (context) => ClassScreen(),
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
          "Classes",
          style: TextStyle(color: GlobalVariables.baseColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: scaffoldWidth,
        height: scaffoldHeight,
        child: Column(
          children: [
            Container(
              height: scaffoldHeight * 0.3,
              color: Colors.pink,
            ),
            Container(
              height: scaffoldHeight * 0.4,
              color: Color.fromARGB(255, 57, 51, 53),
            ),
            Expanded(
              child: Container(child: Text(widget.data.toString())),
            )
          ],
        ),
      ),
    );
  }
}
