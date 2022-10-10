import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import "package:http/http.dart" as http;
import 'package:intl/intl.dart';
import 'package:unitmma/constants/global_variables.dart';
import 'package:unitmma/screens/classes_screen/class/class_details.dart';

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
  List<Map<String, dynamic>> _classTiming = [];
  var Time = [];

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
        eventList = [];
        _classTiming = [];
        Time = [];
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
              "unit_mma_daywise_schedule") {
            result[item]["meta_data"][i]["value"].values.forEach((e) {
              setState(() {
                var seen = Set<String>();

                _classTiming = [
                  ..._classTiming,
                  {
                    "day": day[int.parse(e["unit_mma_sch_day"])],
                    "timing": {
                      "from": e["unit_mma_sch_frm_time"],
                      "to": e["unit_mma_sch_to_time"]
                    }
                  }
                ];
                _classTiming = _classTiming
                    .where((numone) => seen.add(numone.toString()))
                    .toList();
              });
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
            for (int j = 0; j < _eventDays[item]; j++) {
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
              "price": result[item]["price"],
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

    for (var i = 0; i < fillteredList.length; i++) {
      var match = fillteredList[i]["dates"].where(
          (m) => m == DateFormat('MMMM dd, ' 'yyyy').format(widget.date));
      if (match.isNotEmpty) {
        setState(() {
          var seen = Set<String>();

          eventList = [...eventList, fillteredList[i]];
          eventList =
              eventList.where((numone) => seen.add(numone.toString())).toList();
        });
      }
    }
    for (var i = 0; i < _classTiming.length; i++) {
      print(_classTiming[i]["day"]);
      setState(() {
        if (_classTiming[i]["day"] == _DateFormatter.format(widget.date)) {
          var seen = Set<String>();

          Time = [
            ...Time,
            [_classTiming[i]["timing"]["from"], _classTiming[i]["timing"]["to"]]
          ];
          Time = Time.where((numone) => seen.add(numone.toString())).toList();
        }
      });
    }
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

    if (eventList.isNotEmpty) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: eventList.length,
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ClassDetail(
                      data: {"info": eventList[index], "timing": Time}),
                ),
              );
            },
            child: Container(
              height: scaffoldHeight * 0.15,
              child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: scaffoldWidth * 0.65,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                eventList[index]["name"],
                                style: TextStyle(
                                  color: GlobalVariables.baseColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(DateFormat('MMMM dd, ' 'yyyy')
                                  .format(widget.date)),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Container(
                            child: CachedNetworkImage(
                              width: double.infinity,
                              fit: BoxFit.fill,
                              imageUrl: eventList[index]["img"],
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              placeholder: ((context, url) => Container(
                                    child: const Center(
                                      child: CircularProgressIndicator.adaptive(
                                        backgroundColor: Colors.pinkAccent,
                                        strokeWidth: 1,
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          );
        }),
      );
    } else {
      return Center(
          child: Text(
              "No Classes Available on ${DateFormat('MMMM dd, ' 'yyyy').format(widget.date)}"));
    }

    // By default, show a loading spinner.
  }
}
