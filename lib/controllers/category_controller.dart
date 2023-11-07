import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:furniture_mcommerce_app/models/category.dart';

import 'package:furniture_mcommerce_app/shared_resources/share_string.dart';
import 'package:furniture_mcommerce_app/models/product.dart';
import 'package:http/http.dart' as http;

class CategoryController {
  static FetchListCategory parseResultsListCategory(String responseBody) {
    var result = json.decode(responseBody);
    FetchListCategory results = FetchListCategory.fromJson(result);
    return results;
  }

  static Future<FetchListCategory> fetchListCategory(String search, String idCatParent, String nameroom) async {
    final response = await http.get(Uri.parse('${ShareString.URL_API}/categories/list/?search=$search&idCatParent=$idCatParent&nameroom=$nameroom'));
    if (response.statusCode == 200) {
      return compute(parseResultsListCategory, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Can\'t get results');
    }
  }
}