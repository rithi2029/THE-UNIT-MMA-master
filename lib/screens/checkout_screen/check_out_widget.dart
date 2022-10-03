import 'package:flutter/material.dart';

class CheckOutWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String errorText;
  const CheckOutWidget(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return errorText;
            }
            return null;
          }, // decoration: InputDecoration(labelText: 'City'),
          decoration: InputDecoration(
            labelText: hintText,
            border: InputBorder.none,
            filled: true,

            // fillColor: Colors.grey,
            //    contentPadding: const EdgeInsets.only(  left: 14.0, bottom: 6.0, top: 8.0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 54, 177, 244)),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}
