// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitmma/constants/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:unitmma/constants/utils.dart';
import 'package:unitmma/scaffold/scaffold.dart';
import 'package:unitmma/screens/home_screen/home.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../constant_widgets/common_textbutton.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.white,
      appBar: AppBar(
        title: const Text("Sign-In"),
        backgroundColor: GlobalVariables.baseColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: const [
                  Text(
                    "Hello Again !",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Welcome you\'ve been missed !",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Image(
                  fit: BoxFit.fill,
                  width: 200,
                  image: NetworkImage(
                    "https://theunitmma.co.uk/wp-content/uploads/2021/09/cropped-the-unit-mixed-martial-arts.jpg",
                  )),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _signInFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Enter Your Email',
                      hideText: false,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Enter Your Password',
                      hideText: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: GestureDetector(
                        onTap: () async {
                          if (_signInFormKey.currentState!.validate()) {
                            http.Response res = await http.post(
                                Uri.parse(
                                    "https://theunitmma.co.uk/wp-json/jwt-auth/v1/token"),
                                body: jsonEncode({"username": _emailController.text, "password": _passwordController.text}),
                                headers: <String, String>{
                                  "Content-Type":
                                      "application/json; charset=UTF-8"
                                });
                            var data = jsonDecode(res.body);

                            if (data["token"] != null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ScaffoldScreen(),
                                ),
                              );
                            } else {
                              print(data["message"]);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Html(data: data["message"], style: {
                                    "strong": Style(
                                      backgroundColor:
                                          Color.fromARGB(80, 255, 255, 255),
                                    ),
                                    "body": Style(
                                      backgroundColor:
                                          Color.fromARGB(80, 255, 255, 255),
                                    )
                                  }),
                                ),
                              );
                            }
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                              color: GlobalVariables.baseColor,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: GlobalVariables.white)),
                          child: Center(
                              child: Text("Sign-In",
                                  style:
                                      TextStyle(color: GlobalVariables.white))),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
