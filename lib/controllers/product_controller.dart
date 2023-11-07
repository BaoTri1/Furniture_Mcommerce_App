import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:furniture_mcommerce_app/shared_resources/share_string.dart';
import 'package:furniture_mcommerce_app/models/product.dart';
import 'package:http/http.dart' as http;

class ProductController {
  //?page=1&limit=20&category=&price=0-1000000000&typeroom=&search=
  // ignore: constant_identifier_names
  //static const String url_product = '${ShareString.URL_API}/products/?page=1&limit=20';

  static FetchListProduct parseResultsListProduct(String responseBody) {
    var result = json.decode(responseBody);
    FetchListProduct results = FetchListProduct.fromJson(result);
    return results;
  }

  static Future<FetchListProduct> fetchListProduct(int page, int limit) async {
    final response = await http.get(Uri.parse('${ShareString.URL_API}/products/?page=$page&limit=$limit'));
    if (response.statusCode == 200) {
      return compute(parseResultsListProduct, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Can\'t get results');
    }
  }

  static Future<FetchListProduct> fetchSearchListProduct(int page, int limit, String search, String category,
            String nameroom,String price, String idCatParent) async {
    final response = await http.get(
        Uri.parse(
            '${ShareString.URL_API}/products/'
                '?page=$page&limit=$limit&category=$category&price=$price&typeroom=$nameroom&search=$search&catparent=$idCatParent')
    );
    if (response.statusCode == 200) {
      return compute(parseResultsListProduct, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Can\'t get results');
    }
  }

  static Future<FetchListProduct> fetchListSimilarProduct(int page, int limit, String category) async {
    final response = await http.get(Uri.parse('${ShareString.URL_API}/products/similar/?page=$page&limit=$limit&category=$category'));
    if (response.statusCode == 200) {
      return compute(parseResultsListProduct, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Can\'t get results');
    }
  }

  static FetchProduct parseResultsProduct(String responseBody) {
    var result = json.decode(responseBody);
    FetchProduct results = FetchProduct.fromJson(result);
    return results;
  }

  static Future<FetchProduct> fetchProduct(String id) async {
    final response = await http.get(Uri.parse('${ShareString.URL_API}/products/items/?id=$id'));
    if (response.statusCode == 200) {
      return compute(parseResultsProduct, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Can\'t get results');
    }
  }

  static Future<FetchProduct> checkQuantityProduct(String id, int numCheck) async {
    final response = await http.get(Uri.parse('${ShareString.URL_API}/products/checkQuantity?id=$id&numCheck=$numCheck'));
    if (response.statusCode == 200) {
      return compute(parseResultsProduct, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Can\'t get results');
    }
  }
}