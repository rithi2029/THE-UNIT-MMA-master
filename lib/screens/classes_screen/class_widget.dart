import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import "package:http/http.dart" as http;

class ClassWidget extends StatefulWidget {
  const ClassWidget({Key? key}) : super(key: key);

  @override
  State<ClassWidget> createState() => _ClassWidgetState();
}

class _ClassWidgetState extends State<ClassWidget> {
  List _classes = [];
  @override
  Widget build(BuildContext context) {
    print("object");
    Map<String, String> headers = {"Content-Type": "application/json"};

    getClasses() async {
      final res = await http.get(
          Uri.parse(
              "https://theunitmma.co.uk/wp-json/wc/v2/products?consumer_key=ck_dc42350e0d839a416bb73fdef9984544907a8fdb&consumer_secret=cs_023b27d43090a807fc43d77cda696a15cc87442e"),
          headers: headers);
      final result = jsonDecode(res.body);
      setState(() {
        _classes = result;
      });
    }

    getClasses();

    print(_classes);
    return Container(
      child: Text(""),
    );
  }
}
