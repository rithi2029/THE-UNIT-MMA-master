import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unitmma/constants/global_variables.dart';
import 'package:unitmma/scaffold/scaffold.dart';
import 'package:unitmma/screens/classes_screen/class_widget.dart';
import 'package:unitmma/screens/membership_screen/widget/member_ship_widget.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({Key? key}) : super(key: key);

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  final _currentDate = DateTime.now();
  final _dayFormatter = DateFormat('dd');
  final _monthFormatter = DateFormat('MMM');
  final _DateFormatter = DateFormat('EEE');

  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final scaffoldWidth = MediaQuery.of(context).size.width;
    final scaffoldHeight = MediaQuery.of(context).size.height;
    final dates = <Widget>[];
    for (int i = 0; i < 7; i++) {
      final date = _currentDate.add(Duration(days: i));
      dates.add(GestureDetector(
        onTap: () {
          setState(() {
            _date = date;
          });
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: GlobalVariables.baseColor,
                  width: 0.5,
                  style: BorderStyle.solid)),
          width: scaffoldWidth * 0.15,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                _dayFormatter.format(date),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                _DateFormatter.format(date),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          )),
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ScaffoldScreen(),
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
      body: SizedBox(
        width: scaffoldWidth,
        child: Column(
          children: [
            Container(
              height: scaffoldHeight * 0.08,
              width: scaffoldWidth,
              child: Row(
                children: [
                  Container(
                    width: scaffoldWidth * 0.15,
                    color: Colors.pink,
                  ),
                  Flexible(
                    child: Container(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 7,
                        itemBuilder: ((context, index) {
                          return dates[index];
                        }),
                      ),
                    ),
                  ),
                  Container(
                    width: scaffoldWidth * 0.15,
                    color: Colors.pink,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ClassWidget(
                date: _date,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
