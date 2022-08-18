import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:unitmma/constant_widgets/common_utils.dart';
import 'package:unitmma/model/product_model.dart';

import '../api/api_call.dart';

class ProductViewModel extends ChangeNotifier {
  late Product _product;

  Product get product => _product;

  Future<void> getProductList() async {
    CommonUtils().getInternetAction().then((value) {
      if (value) {}
    });

    APICall().getProducts().then((value) {
      if (value.statusCode == 200) {
        _product = Product.fromJson(json.decode());
      }
    });
  }
}
