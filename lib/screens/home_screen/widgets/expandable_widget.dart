import 'package:flutter/material.dart';
import 'package:unitmma/constants/global_variables.dart';

class HomeCards extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final String title;

  final Function routing;

  const HomeCards(
      {Key? key,
      required this.url,
      required this.width,
      required this.height,
      required this.title,
      required this.routing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: GlobalVariables.baseColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    routing();
                  },
                  child: const Text(
                    "Sell All",
                    style: TextStyle(
                      color: GlobalVariables.baseColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            Container(
                height: height,
                width: width,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: ((context, index) {
                      return Container(
                        margin: EdgeInsets.only(
                            top: width * 0.01, left: width * 0.01),
                        width: width * 0.47,
                        padding: EdgeInsets.all(width * 0.02),
                        height: height,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Color.fromARGB(255, 219, 212, 212),
                                width: 1,
                                style: BorderStyle.solid)),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image(
                                width: double.infinity,
                                height: height * 0.5,
                                fit: BoxFit.fill,
                                image: NetworkImage(url),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.symmetric(vertical: height * 0.04),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "AdultKick Boxing",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: GlobalVariables.baseColor,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Price:20",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: GlobalVariables.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }))),
            Container()
          ],
        ),
      ),
    );
  }
}
