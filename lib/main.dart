import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitmma/provider/product_view_model.dart';
import 'package:unitmma/scaffold/scaffold.dart';
import 'package:unitmma/screens/Auth/signin/signin.dart';
import 'package:unitmma/screens/Auth/signup/signup.dart';
import 'package:unitmma/screens/home_screen/home.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ProductViewModel())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInScreen(),
    );
  }
}
