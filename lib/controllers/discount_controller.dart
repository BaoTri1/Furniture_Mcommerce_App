import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:furniture_mcommerce_app/models/discount.dart';
import 'package:http/http.dart' as http;

import '../shared_resources/share_string.dart';

class DiscountController {
  static FetchListDiscount parseResultsListDiscount(String responseBody) {
    var result = json.decode(responseBody);
    FetchListDiscount results = FetchListDiscount.fromJson(result);

    return results;
  }

  static Future<FetchListDiscount> fetchListDiscount(int page, int limit) async {
    final response = await http.get(Uri.parse('${ShareString.URL_API}/discounts/?page=$page&limit=$limit&search='));
    if (response.statusCode == 200) {
      return compute(parseResultsListDiscount, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Can\'t get results');
    }
  }

  static Future<FetchListDiscount> CheckQuantityDiscount(String idDiscount) async {
    final response = await http.get(Uri.parse('${ShareString.URL_API}/discounts/checkQuantity?id=$idDiscount'));
    if (response.statusCode == 200) {
      return compute(parseResultsListDiscount, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Can\'t get results');
    }
  }

  static FetchCheckDiscountValid parseResulitsCheckDiscountValid(String responseBody) {
    var result = json.decode(responseBody);
    FetchCheckDiscountValid results = FetchCheckDiscountValid.fromJson(result);

    return results;
  }
  static Future<FetchCheckDiscountValid> checkDiscountValid(String idProduct) async {
    final response = await http.get(Uri.parse('${ShareString.URL_API}/discounts/checkDiscountValid?id=$idProduct'));
    if (response.statusCode == 200) {
      return compute(parseResulitsCheckDiscountValid, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Can\'t get results');
    }
  }


}