import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:unitmma/constant_widgets/common_utils.dart';
import 'package:unitmma/model/product_model.dart';

import '../api/api_call.dart';

class ProductViewModel extends ChangeNotifier {
  Product? post;
  bool loading = false;

  getPostData() async {
    loading = true;
    post = (await APICall().getProducts());
  }
}
