import 'package:flutter/material.dart';
import 'package:unitmma/constants/global_variables.dart';

class Cards extends StatelessWidget {
  final String url;

  const Cards({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      return Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: NetworkImage(url),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }));
  }
}
