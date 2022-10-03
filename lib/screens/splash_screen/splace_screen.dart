import 'dart:async';
import 'dart:io';
//import 'package:connectivity/connectivity.dart';
//import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unitmma/scaffold/scaffold.dart';
import 'package:unitmma/screens/Auth/signup/signup.dart';
import 'package:unitmma/screens/home_screen/home.dart';

import '../Auth/signin/signin.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  late AnimationController animationController;
  late Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void _showDialog() {
    // dialog implementation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Internet needed!"),
        content: Text("Kindly connect your device with internet"),
        actions: <Widget>[
          ElevatedButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  void navigationPage() {
    Timer.run(() {
      try {
        InternetAddress.lookup('google.com').then((result) {
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new
                  //OnBoardScreen()
                  //  HomePage1(),
                  ScaffoldScreen(),
            ));
          } else {
            _showDialog(); // show dialog
          }
        }).catchError((error) {
          _showDialog(); // show dialog
        });
      } on SocketException catch (_) {
        _showDialog();
        print('not connected'); // show dialog
      }
    });
  }

  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //isInternet();

    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 5),
    );

    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
                fit: BoxFit.fill,
                image: NetworkImage(
                  "https://theunitmma.co.uk/wp-content/uploads/2021/09/cropped-the-unit-mixed-martial-arts.jpg",
                )),
          ],
        ),
      ),
    );
  }
}
