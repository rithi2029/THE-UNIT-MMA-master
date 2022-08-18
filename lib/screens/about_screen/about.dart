import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unitmma/scaffold/scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/global_variables.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

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
          "About",
          style: TextStyle(color: GlobalVariables.baseColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              width: scaffoldWidth * 0.9,
              height: scaffoldHeight * 0.25,
              child: const Image(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    "https://theunitmma.co.uk/wp-content/uploads/2021/09/cropped-the-unit-mixed-martial-arts.jpg",
                  )),
            ),
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                      backgroundColor: GlobalVariables.baseColor,
                      child: Icon(FontAwesomeIcons.mobile,
                          color: GlobalVariables.white)),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("+44 7949 280356",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                      backgroundColor: GlobalVariables.baseColor,
                      child: Icon(FontAwesomeIcons.envelope,
                          color: GlobalVariables.white)),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("demo@gmail.com",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: GlobalVariables.baseColor,
                    child: Icon(FontAwesomeIcons.globe,
                        color: GlobalVariables.white),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("www.theunitmma.co.uk",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      // ignore: prefer_const_constructors
                      child: Icon(
                        FontAwesomeIcons.facebookSquare,
                        size: 60.0,
                        color: const Color(0xff4867aa),
                      ),
                      onTap: () {},
                    )),
                // ignore: prefer_const_constructors
                SizedBox(
                  width: 5.0,
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: const Icon(
                        FontAwesomeIcons.youtube,
                        size: 60.0,
                        color: Color(0xffcc0000),
                      ),
                      onTap: () {},
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
