import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class ListTileSelectExample extends StatefulWidget {
  final int id;

  const ListTileSelectExample({Key? key, required this.id}) : super(key: key);

  @override
  ListTileSelectExampleState createState() => ListTileSelectExampleState();
}

class ListTileSelectExampleState extends State<ListTileSelectExample> {
  String dropdownValue = 'One';
  Map<String, dynamic> json = {};

  @override
  Widget build(BuildContext context) {
    Map<String, String> headers = {"Content-Type": "application/json"};

    getData() async {
      final res = await http.get(
          Uri.parse(
              "https://theunitmma.co.uk/wp-json/wc/v2/products/${widget.id}?consumer_key=ck_dc42350e0d839a416bb73fdef9984544907a8fdb&consumer_secret=cs_023b27d43090a807fc43d77cda696a15cc87442e"),
          headers: headers);
      final result = jsonDecode(res.body);
      setState(() {
        json = result;
      });
      print(json);
    }

    getData();
    return Scaffold(
      body: ListView.builder(
          itemCount: json["attributes"].length,
          itemBuilder: (_, int index) {
            return Container(
                child: Row(
              children: [
                Text(json["attributes"][index]["name"]),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: ['One', 'Two', 'Free', 'Four']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            ));
          }),
    );
  }
}
