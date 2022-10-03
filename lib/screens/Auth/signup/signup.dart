// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:unitmma/constants/global_variables.dart';
import 'package:unitmma/scaffold/scaffold.dart';
import 'package:unitmma/screens/Auth/signin/signin.dart';

import '../../../constant_widgets/common_textbutton.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
    final scaffoldHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: GlobalVariables.white,
      appBar: AppBar(
        title: const Text("Sign-Up"),
        backgroundColor: GlobalVariables.baseColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: scaffoldHeight * 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _nameController,
                        hintText: 'Enter Your Username',
                        hideText: false,
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
                            if (_signUpFormKey.currentState!.validate()) {
                              http.Response res = await http.post(
                                  Uri.parse(
                                      "https://theunitmma.co.uk/wp-json/wc/v2/customers?consumer_key=ck_dc42350e0d839a416bb73fdef9984544907a8fdb&consumer_secret=cs_023b27d43090a807fc43d77cda696a15cc87442e"),
                                  body: jsonEncode({
                                    "email": _emailController.text,
                                    "username": _nameController.text,
                                    "password": _passwordController.text
                                  }),
                                  headers: <String, String>{
                                    "Content-Type":
                                        "application/json; charset=UTF-8"
                                  });
                              var data = jsonDecode(res.body);

                              if (res.statusCode == 201) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SignInScreen(),
                                  ),
                                );
                              } else {
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
                              child: Text(
                                "Sign-Up",
                                style: TextStyle(color: GlobalVariables.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ScaffoldScreen(),
                          ));
                        },
                        child: const Text(
                          'I"ll do this later',
                          style: TextStyle(color: GlobalVariables.baseColor),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account ? "),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign-in',
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
