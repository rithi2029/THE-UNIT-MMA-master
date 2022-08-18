import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:unitmma/constants/global_variables.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool hideText;
  const CustomTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.hideText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            border: Border.all(
              color: Color.fromARGB(255, 218, 133, 133),
            ),
            borderRadius: BorderRadius.circular(30)),
        child: TextFormField(
          obscureText: hideText,
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
          ),
          validator: (val) {
            if (val == null || val.isEmpty) {
              return hintText;
            }
            return null;
          },
        ),
      ),
    );
  }
}
