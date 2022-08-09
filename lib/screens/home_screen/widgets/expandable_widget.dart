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
    return GestureDetector(
      onTap: () {
        routing();
      },
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
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(url),
                ),
              ),
            ),
            Container()
          ],
        ),
      ),
    );
  }
}
