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
  final _DateFormatter = DateFormat('EEE');

  List day = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  var _classes = [];
  var _cat = [];
  DateTime filterData = DateTime.now();
  var availableDays = [];
  var _eventDays = [];
  var _startTimeStamp = [];
  List<Map<String, dynamic>> fillteredList = [];
  List<Map<String, dynamic>> eventList = [];

  Map<String, String> headers = {"Content-Type": "application/json"};

  getCategorie(data) async {
    if (filterData != data) {
      setState(() {
        filterData = data;
        _classes = [];
        availableDays = [];
        _eventDays = [];
        _startTimeStamp = [];
        _cat = [];
      });
    }

    final res = await http.get(
        Uri.parse(
            "https://theunitmma.co.uk/wp-json/wc/v2/products?consumer_key=ck_dc42350e0d839a416bb73fdef9984544907a8fdb&consumer_secret=cs_023b27d43090a807fc43d77cda696a15cc87442e"),
        headers: headers);
    final result = jsonDecode(res.body);
    for (var item = 0; item < result.length; item++) {
      if (result[item]["categories"].length != 0 &&
          result[item]["categories"][0]["name"] == "Classes") {
        for (var i = 0; i < result[item]["meta_data"].length; i++) {
          if (result[item]["meta_data"][i]["key"] ==
              "WooCommerceEventsDateTimestamp") {
            setState(() {
              if (_startTimeStamp.isEmpty) {
                _startTimeStamp = [
                  ..._startTimeStamp,
                  int.parse(result[item]["meta_data"][i]["value"])
                ];
              } else {
                var data = _startTimeStamp.where((e) =>
                    e == int.parse(result[item]["meta_data"][i]["value"]));

                if (data.isEmpty) {
                  _startTimeStamp = [
                    ..._startTimeStamp,
                    int.parse(result[item]["meta_data"][i]["value"])
                  ];
                }
              }
            });
          }

          if (result[item]["meta_data"][i]["key"] ==
              "WooCommerceEventsNumDays") {
            setState(() {
              if (_eventDays.isEmpty) {
                _eventDays = [
                  ..._eventDays,
                  int.parse(result[item]["meta_data"][i]["value"])
                ];
              } else {
                var data = _eventDays.where((e) =>
                    e == int.parse(result[item]["meta_data"][i]["value"]));

                if (data.isEmpty) {
                  _eventDays = [
                    ..._eventDays,
                    int.parse(result[item]["meta_data"][i]["value"])
                  ];
                }
              }
            });
          }
          if (result[item]["meta_data"][i]["key"] ==
              "unit_mma_avaialble_days") {
            setState(() {
              var seen = Set<String>();

              if (availableDays.isEmpty) {
                availableDays = [
                  ...availableDays,
                  jsonDecode(result[item]["meta_data"][i]["value"])
                ];
                availableDays = availableDays
                    .where((numone) => seen.add(numone.toString()))
                    .toList();
              } else {
                var data = availableDays.where((e) =>
                    e == jsonDecode(result[item]["meta_data"][i]["value"]));

                if (data.isEmpty) {
                  availableDays = [
                    ...availableDays,
                    jsonDecode(result[item]["meta_data"][i]["value"])
                  ];
                  availableDays = availableDays
                      .where((numone) => seen.add(numone.toString()))
                      .toList();
                }
              }
            });
            var data = [];
            for (int j = 0; data.length < _eventDays[item]; j++) {
              final date = DateTime.fromMillisecondsSinceEpoch(
                      _startTimeStamp[item] * 1000)
                  .add(Duration(days: j));
              for (var d = 0; d < availableDays[item].length; d++) {
                if (day[jsonDecode(availableDays[item][d])] ==
                    _DateFormatter.format(date)) {
                  data = [...data, DateFormat('MMMM dd, ' 'yyyy').format(date)];
                }
              }
            }
            setState(() {
              var seen = Set<String>();

              _cat = [..._cat, data];
              _cat =
                  _cat.where((numone) => seen.add(numone.toString())).toList();
            });
            Map<String, dynamic> newData = {
              "id": result[item]["id"],
              "name": result[item]["name"],
              "img": result[item]["images"][0]["src"],
              "availableDays": availableDays[item],
              "eventDays": _eventDays[item],
              "startTimeStamp": DateTime.fromMillisecondsSinceEpoch(
                  _startTimeStamp[item] * 1000),
              "dates": _cat[item],
            };
            setState(() {
              var seen = Set<String>();

              fillteredList = [...fillteredList, newData];
              fillteredList = fillteredList
                  .where((numone) => seen.add(numone.toString()))
                  .toList();
            });
          }
        }
      }
    }
    for (var i = 0; i < fillteredList.length; i++) {}
  }

  @override
  void initState() {
    super.initState();
    getCategorie(widget.date);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getCategorie(widget.date);
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

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: fillteredList.length,
      itemBuilder: ((context, index) {
        return Column(
          children: [
            Card(child: Text(fillteredList[index].toString())),
          ],
        );
      }),
    );

    // By default, show a loading spinner.
  }
}
