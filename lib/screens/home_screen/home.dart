// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitmma/constants/global_variables.dart';
import 'package:unitmma/screens/Auth/signin/signin.dart';
import 'package:unitmma/screens/about_screen/about.dart';
import 'package:unitmma/screens/cart_screen/cart_screen.dart';
import 'package:unitmma/screens/classes_screen/class.dart';
import 'package:unitmma/screens/membership_screen/membership.dart';
import 'package:unitmma/screens/product_screen/product.dart';

import '../../constant_widgets/app_bar.dart';
import '../order_page/order_screen.dart';
import '../search_screen/search_screen.dart';
import 'widgets/expandable_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class AppImage {
  String? image;
  String? path;
  String? active;
  String? inactive;

// added '?'

  AppImage({this.image, this.path, this.active, this.inactive});
  // can also add 'required' keyword
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isVisible = true;

  int badgeCount = 0;

  String sale_price = "--";

  @override
  Widget build(BuildContext context) {
    final scaffoldWidth = MediaQuery.of(context).size.width;
    final scaffoldHeight = MediaQuery.of(context).size.height;
    initialState() async {
      final prefs = await SharedPreferences.getInstance();

      final String? cartDetails = prefs.getString('cart');

      List cartDetail = jsonDecode(cartDetails!);
      setState(() {
        badgeCount = cartDetail.length;
      });
    }

    initialState();

    List list = [
      "https://theunitmma.co.uk/wp-content/uploads/2022/02/IMG_0693-1.jpg",
      "https://theunitmma.co.uk/wp-content/uploads/2022/02/IMG_0005-2-scaled.jpg",
      "https://theunitmma.co.uk/wp-content/uploads/2022/02/Kids-Class-Pose-1-scaled.jpg",
    ];
    List<Map<String, dynamic>> images = [
      {"name": "rithi"}
    ];
    images.add({"mahesh": "rithi"});
    images.removeWhere((item) => item["mahesh"] == 'rithi');

    visibilityController() async {
      if (_isVisible) {
        final prefs = await SharedPreferences.getInstance();
        final success = await prefs.remove('action');
        await prefs.remove("user_id");
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignInScreen(),
          ),
        );
      }
    }

    getInfo() async {
      final prefs = await SharedPreferences.getInstance();
      final String? action = prefs.getString('action');

      setState(() {
        action != null ? _isVisible = true : _isVisible = false;
      });
    }

    getInfo();

    redirect() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CartScreen(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: GlobalVariables.baseColor),
        // leading: const Icon(
        //   Icons.menu,
        //   color: GlobalVariables.baseColor,
        // ),
        actions: [
          Container(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(),
                      ),
                    );
                  },
                  child: const Icon(Icons.search_rounded,
                      color: GlobalVariables.baseColor),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CartScreen(),
                      ),
                    );
                  },
                  child: Badge(
                    elevation: 0,
                    badgeContent: Text("$badgeCount",
                        style: TextStyle(color: GlobalVariables.white)),
                    badgeColor: GlobalVariables.baseColor,
                    child: const Icon(Icons.shopping_cart_outlined),
                  ),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: GlobalVariables.white,
        title: GestureDetector(
          child: const Image(
            width: 200,
            height: 50,
            image: NetworkImage(
                "https://theunitmma.co.uk/wp-content/uploads/2021/09/cropped-the-unit-mixed-martial-arts.jpg",
                scale: 0.5),
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              margin: EdgeInsets.all(0),
              decoration: BoxDecoration(),
              child: ClipRRect(
                child: Image(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                      "https://theunitmma.co.uk/wp-content/uploads/2021/09/cropped-the-unit-mixed-martial-arts.jpg",
                    )),
              ),
            ),
            ListTile(
              iconColor: GlobalVariables.baseColor,
              leading: Icon(Icons.home),
              title: Text('Home'),
            ),
            ListTile(
              iconColor: GlobalVariables.baseColor,
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AboutScreen(),
                  ),
                );
              },
            ),
            Visibility(
                visible: _isVisible,
                child: Column(
                  children: [
                    ListTile(
                      iconColor: GlobalVariables.baseColor,
                      leading: Icon(Icons.history),
                      title: Text('Order History'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OrderScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      iconColor: GlobalVariables.baseColor,
                      leading: Icon(Icons.star_border),
                      title: Text('Subscription Details'),
                    ),
                    ListTile(
                      iconColor: GlobalVariables.baseColor,
                      leading: Icon(Icons.cancel_outlined),
                      title: Text('Remove Account'),
                    ),
                  ],
                )),
            ListTile(
              iconColor: GlobalVariables.baseColor,
              leading: Icon(Icons.logout_outlined),
              title: Text(_isVisible ? "Logout" : "Login"),
              onTap: visibilityController,
            ),
            ExpansionTile(
              title: Text('By Category'),
              controlAffinity: ListTileControlAffinity.trailing,
              children: <Widget>[
                ListTile(
                  iconColor: GlobalVariables.baseColor,
                  leading: Icon(Icons.class_),
                  title: Text('Classes'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ClassScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  iconColor: GlobalVariables.baseColor,
                  leading: Icon(Icons.card_membership),
                  title: Text('Membership'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MembershipScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  iconColor: GlobalVariables.baseColor,
                  leading: Icon(Icons.production_quantity_limits_outlined),
                  title: Text('Product'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        width: scaffoldWidth,
        height: scaffoldHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 0.8,
                      aspectRatio: 16 / 9,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 600),
                      autoPlayCurve: Curves.slowMiddle,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: list.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: scaffoldWidth,
                            height: scaffoldHeight * 0.5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(i),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  HomeCards(
                    height: scaffoldHeight * 0.30,
                    width: scaffoldWidth,
                    title: "Products",
                    routing: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductScreen(),
                        ),
                      );
                    },
                  ),
                  HomeCards(
                    height: scaffoldHeight * 0.30,
                    width: scaffoldWidth,
                    title: "Memberships",
                    routing: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MembershipScreen(),
                        ),
                      );
                    },
                  ),
                  HomeCards(
                    height: scaffoldHeight * 0.30,
                    width: scaffoldWidth,
                    title: "Classes",
                    routing: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ClassScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
