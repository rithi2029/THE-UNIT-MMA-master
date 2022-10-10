import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unitmma/constants/global_variables.dart';
import 'package:unitmma/scaffold/scaffold.dart';
import 'package:unitmma/screens/classes_screen/class.dart';
import 'package:unitmma/screens/classes_screen/class_widget.dart';
import 'package:unitmma/screens/membership_screen/widget/member_ship_widget.dart';

class ClassDetail extends StatefulWidget {
  final Map<String, dynamic> data;
  const ClassDetail({Key? key, required this.data}) : super(key: key);

  @override
  State<ClassDetail> createState() => _ClassDetailState();
}

class _ClassDetailState extends State<ClassDetail> {
  DateTime _selectedDate = DateTime.now();
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 7)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
    print('...');
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldWidth = MediaQuery.of(context).size.width;
    final scaffoldHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ClassScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: GlobalVariables.baseColor,
          ),
        ),
        actions: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.search_rounded,
                      color: GlobalVariables.baseColor),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.shopping_cart_checkout_outlined,
                      color: GlobalVariables.baseColor),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: GlobalVariables.white,
        title: const Text(
          "Classes",
          style: TextStyle(color: GlobalVariables.baseColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: scaffoldWidth,
        height: scaffoldHeight,
        child: Column(
          children: [
            Container(
              height: scaffoldHeight * 0.3,
              child: CachedNetworkImage(
                width: double.infinity,
                height: scaffoldHeight * 0.3,
                fit: BoxFit.fill,
                imageUrl: widget.data["info"]["img"].toString(),
                errorWidget: (context, url, error) => Icon(Icons.error),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: scaffoldHeight * 0.4,
                width: scaffoldWidth,
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data["info"]["name"],
                      style: TextStyle(
                          fontSize: 16,
                          color: GlobalVariables.baseColor,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      "Price : ${widget.data["info"]["price"]}",
                      style: TextStyle(
                          fontSize: 14,
                          color: GlobalVariables.baseColor,
                          fontWeight: FontWeight.w800),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? 'No Date Chosen!'
                                : 'Choose Date: ${DateFormat.yMd().format(_selectedDate)}',
                          ),
                        ),
                        ElevatedButton(
                          child: Text(
                            'Choose Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _presentDatePicker,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(child: Text(widget.data.toString())),
            )
          ],
        ),
      ),
    );
  }
}
