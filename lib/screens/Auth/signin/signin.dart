// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitmma/constants/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:unitmma/constants/utils.dart';
import 'package:unitmma/scaffold/scaffold.dart';
import 'package:unitmma/screens/Auth/signup/signup.dart';
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
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: const [
                    Text(
                      "Hello Again !",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Welcome you\'ve been missed !",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString(
                                    'action', data["user_email"]);
                                final String? action =
                                    prefs.getString('action');

                                print(action);

                                Uri demo = Uri.parse(
                                    "https://theunitmma.co.uk/wp-json/wp/v2/users/me");

                                final test = await http.get(demo, headers: {
                                  "Content-Type": "application/json",
                                  "Accept": "application/json",
                                  "Authorization": "Bearer ${data["token"]}"
                                });
                                var json = jsonDecode(test.body);
                                print(json["id"]);

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ScaffoldScreen(),
                                  ),
                                );
                              } else {
                                print(data["message"]);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Html(data: data["message"], style: {
                                      "strong": Style(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                      "body": Style(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
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
                                border:
                                    Border.all(color: GlobalVariables.white)),
                            child: Center(
                                child: Text("Sign-In",
                                    style: TextStyle(
                                        color: GlobalVariables.white))),
                          ),
                        ),
                      ),
                      Text("Forgot password"),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ScaffoldScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'I"ll do this later',
                          style: TextStyle(color: GlobalVariables.baseColor),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account ? "),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SignUpScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Signup',
                              style:
                                  TextStyle(color: GlobalVariables.baseColor),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
