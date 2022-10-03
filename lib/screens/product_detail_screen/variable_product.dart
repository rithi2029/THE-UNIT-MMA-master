import 'package:flutter/material.dart';

class VariableProduct extends StatelessWidget {
  const VariableProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 2,
        itemBuilder: ((context, index) {
          return Text("rithi");
        }),
      ),
    );
  }
}
