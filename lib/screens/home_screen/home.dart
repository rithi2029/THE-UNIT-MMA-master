// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:unitmma/screens/product_screen/product.dart';

import '../../constant_widgets/app_bar.dart';
import 'widgets/expandable_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final scaffoldWidth = MediaQuery.of(context).size.width;
    final scaffoldHeight = MediaQuery.of(context).size.height;

    List list = [
      "https://theunitmma.co.uk/wp-content/uploads/2022/02/IMG_0693-1.jpg",
      "https://theunitmma.co.uk/wp-content/uploads/2022/02/IMG_0005-2-scaled.jpg",
      "https://theunitmma.co.uk/wp-content/uploads/2022/02/Kids-Class-Pose-1-scaled.jpg",
    ];

    return Scaffold(
      appBar: appBar,
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
                    url:
                        "https://theunitmma.co.uk/wp-content/uploads/2022/02/IMG_0693-1.jpg",
                    height: scaffoldHeight * 0.25,
                    width: scaffoldWidth,
                    title: "Classes",
                    routing: () {},
                  ),
                  HomeCards(
                    url:
                        "https://theunitmma.co.uk/wp-content/uploads/2022/02/IMG_0005-2-scaled.jpg",
                    height: scaffoldHeight * 0.25,
                    width: scaffoldWidth,
                    title: "Membership",
                    routing: () {},
                  ),
                  HomeCards(
                    url:
                        "https://theunitmma.co.uk/wp-content/uploads/2022/02/Kids-Class-Pose-1-scaled.jpg",
                    height: scaffoldHeight * 0.25,
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
