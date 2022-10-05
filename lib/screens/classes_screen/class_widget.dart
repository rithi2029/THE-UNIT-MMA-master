import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import "package:http/http.dart" as http;
import 'package:intl/intl.dart';
import 'package:unitmma/constants/global_variables.dart';

class ClassWidget extends StatefulWidget {
  final DateTime date;
  const ClassWidget({Key? key, required this.date}) : super(key: key);

  @override
  State<ClassWidget> createState() => _ClassWidgetState();
}

class _ClassWidgetState extends State<ClassWidget> {
  List _classes = [];
  @override
  Widget build(BuildContext context) {
    final scaffoldWidth = MediaQuery.of(context).size.width;
    final scaffoldHeight = MediaQuery.of(context).size.height;
    Map<String, String> headers = {"Content-Type": "application/json"};

    Future getProducts() async {
      final res = await http.get(
          Uri.parse(
              "https://theunitmma.co.uk/wp-json/foo-event-api/getallevents?consumer_key=ck_dc42350e0d839a416bb73fdef9984544907a8fdb&consumer_secret=cs_023b27d43090a807fc43d77cda696a15cc87442e"),
          headers: headers);
      final result = jsonDecode(res.body);

      return result;
    }

    return FutureBuilder<dynamic>(
        future: getProducts(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            print(snapshot);
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.length,
              itemBuilder: ((context, index) {
                print(snapshot.data[index]["unformated_date"]);
                print(DateFormat('MMMM dd, ' 'yyyy').format(widget.date));
                if (snapshot.data[index]["unformated_date"] ==
                    DateFormat('MMMM dd, ' 'yyyy').format(widget.date)) {
                  return Text(snapshot.data[index].toString());
                } else {
                  return Text(
                      "No Classes available on ${DateFormat('MMMM dd, ' 'yyyy').format(widget.date)}");
                }
              }),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const SpinKitDoubleBounce(
            color: Color.fromARGB(255, 194, 109, 109),
            size: 50.0,
          );
        });
  }
}
