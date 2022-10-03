// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitmma/constants/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:unitmma/screens/checkout_screen/check_out_widget.dart';
import 'package:unitmma/screens/payment_screen/payment_screen.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final _chechOutForm = GlobalKey<FormState>();
  late dynamic countryValue = "";
  late dynamic stateValue = "";
  late dynamic cityValue = "";
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _stateName = TextEditingController();
  final TextEditingController _countryName = TextEditingController();
  final TextEditingController _blockNumber = TextEditingController();
  final TextEditingController _appartment = TextEditingController();
  final TextEditingController _street = TextEditingController();
  final TextEditingController _town = TextEditingController();
  final TextEditingController _postCode = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _stateName.dispose();
    _countryName.dispose();
    _blockNumber.dispose();
    _appartment.dispose();
    _street.dispose();
    _town.dispose();
    _postCode.dispose();
    _phoneNumber.dispose();
    _email.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldWidth = MediaQuery.of(context).size.width;
    final scaffoldHeight = MediaQuery.of(context).size.height;

    Map<String, dynamic> checkOut = {};
    Map<String, dynamic> updatePayload = {};

    localStore() async {
      final prefs = await SharedPreferences.getInstance();
      final String? checkoutData = prefs.getString('checkout');
      var data = jsonDecode(checkoutData!);
      _firstName.text = data["first_name"];
      _lastName.text = data["last_name"];
      _stateName.text = data["_stateName"];
      _countryName.text = data["country_name"];
      _blockNumber.text = data["building_number"];
      _appartment.text = data["appartment"];
      _street.text = data["street"];
      _town.text = data["town"];
      _postCode.text = data["post_code"];
      _phoneNumber.text = data["phone_number"];
      _email.text = data["email"];
    }

    saveAddred() async {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        checkOut = {
          "first_name": _firstName.text,
          "last_name": _lastName.text,
          "_stateName": _stateName.text,
          "country_name": _countryName.text,
          "building_number": _blockNumber.text,
          "appartment": _appartment.text,
          "street": _street.text,
          "town": _town.text,
          "post_code": _postCode.text,
          "phone_number": _phoneNumber.text,
          "email": _email.text,
        };
      });
      await prefs.setString('checkout', jsonEncode({}));
    }

    getCheckoutData() async {
      setState(() {
        checkOut = {
          "first_name": _firstName.text,
          "last_name": _lastName.text,
          "_stateName": stateValue,
          "country_name": countryValue,
          "building_number": _blockNumber.text,
          "appartment": _appartment.text,
          "street": _street.text,
          "town": cityValue,
          "post_code": _postCode.text,
          "phone_number": _phoneNumber.text,
          "email": _email.text,
        };
        Map<String, dynamic> billing = {
          "first_name": _firstName.text,
          "last_name": _lastName.text,
          "company": "",
          "address_1":
              "${_appartment.text},${_street.text},${_town.text},postcode:${_postCode.text},${_stateName.text},${_countryName.text}",
          "address_2":
              "${_appartment.text},${_street.text},${_town.text},postcode:${_postCode.text},${_stateName.text},${_countryName.text}",
          "city": cityValue,
          "state": stateValue,
          "postcode": _postCode.text,
          "country": countryValue,
          "email": _email.text,
          "phone": _phoneNumber.text,
        };
        Map<String, dynamic> shipping = {
          "first_name": _firstName.text,
          "last_name": _lastName.text,
          "company": "",
          "address_1":
              "${_appartment.text},${_street.text},${_town.text},postcode:${_postCode.text},${_stateName.text},${_countryName.text}",
          "address_2":
              "${_appartment.text},${_street.text},${_town.text},postcode:${_postCode.text},${_stateName.text},${_countryName.text}",
          "city": cityValue,
          "state": stateValue,
          "postcode": _postCode.text,
          "country": countryValue,
          "phone": _phoneNumber.text,
        };
        updatePayload = {
          "first_name": _firstName.text,
          "last_naem": _lastName.text,
          "billing": billing,
          "shipping": shipping
        };
      });

      print(updatePayload);

      // final response = await http.put(
      //   Uri.parse(
      //       "https://theunitmma.co.uk/wp-json/wc/v2/customers/38?consumer_key=ck_dc42350e0d839a416bb73fdef9984544907a8fdb&consumer_secret=cs_023b27d43090a807fc43d77cda696a15cc87442e"),
      //   headers: {
      //     'Content-type': 'application/json',
      //     'Accept': 'application/json',
      //   },
      //   body: jsonEncode(updatePayload),
      //   // body: {"first_name":"Divyalakshmy10","billing":{"first_name":"Divyalakshmy0","address_1":"4/462,Kapparngr0,Kongalapuram0","address_2":"sithurajapuram post0","city":"svks0","postcode":"626190"}}
      // );
      // if (response.statusCode == 200) {
      // } else {
      //   // If that call was not successful, throw an error.
      //   print("response.body" + response.body.toString());
      //   throw Exception('Failed to load post');
      // }
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: GlobalVariables.baseColor),
        backgroundColor: GlobalVariables.white,
        title: const Text(
          "Check Out",
          style: TextStyle(color: GlobalVariables.baseColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: _chechOutForm,
              child: Column(
                children: [
                  CheckOutWidget(
                    hintText: 'First Name',
                    errorText: " Please Enter First Name",
                    controller: _firstName,
                  ),
                  CheckOutWidget(
                    hintText: 'Last Name',
                    errorText: " Please Enter Last Name",
                    controller: _lastName,
                  ),
                  CheckOutWidget(
                    hintText: 'Phone Number',
                    errorText: " Please Enter Phone Number",
                    controller: _phoneNumber,
                  ),
                  CheckOutWidget(
                    hintText: 'Email',
                    errorText: " Please Enter Email",
                    controller: _email,
                  ),
                  Container(
                    width: scaffoldWidth * 0.93,
                    child: CSCPicker(
                      layout: Layout.vertical,
                      onCountryChanged: (counter) {
                        setState(() {
                          countryValue = counter;
                        });
                      },
                      onStateChanged: (state) {
                        setState(() {
                          stateValue = state;
                        });
                      },
                      onCityChanged: (city) {
                        setState(() {
                          cityValue = city;
                        });
                      },
                    ),
                  ),
                  // CheckOutWidget(
                  //   hintText: 'Country Name',
                  //   errorText: " Please Enter Country Name",
                  //   controller: _countryName,
                  // ),
                  // CheckOutWidget(
                  //   hintText: 'State',
                  //   errorText: " Please Enter State Name",
                  //   controller: _stateName,
                  // ),
                  // CheckOutWidget(
                  //   hintText: 'Town or city',
                  //   errorText: " Please Enter Town or City",
                  //   controller: _town,
                  // ),
                  CheckOutWidget(
                    hintText: 'Appartment',
                    errorText: " Please Enter Building Number or Name",
                    controller: _appartment,
                  ),
                  CheckOutWidget(
                    hintText: 'Block',
                    errorText: " Please Enter Building Number or Name",
                    controller: _blockNumber,
                  ),
                  CheckOutWidget(
                    hintText: 'Street',
                    errorText: " Please Enter Building Number or Name",
                    controller: _street,
                  ),
                  CheckOutWidget(
                    hintText: 'Post-Code',
                    errorText: " Please Enter Zipcode",
                    controller: _postCode,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        onPressed: () {
                          if (_chechOutForm.currentState!.validate()) {
                            saveAddred();
                          }
                        },
                        child: Text(
                          "SAVE ADDRESS",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          getCheckoutData();

                          if (_chechOutForm.currentState!.validate()) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PaymentScreen(data: updatePayload),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("One or more fields are em"),
                              ),
                            );
                          }
                        },
                        child: Text("CONTINUE TO SHIPPING"),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
