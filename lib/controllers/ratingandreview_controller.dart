import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:furniture_mcommerce_app/models/rating.dart';

import 'package:furniture_mcommerce_app/shared_resources/share_string.dart';
import 'package:http/http.dart' as http;

import '../local_store/db/account_handler.dart';

class RatingAndReviewController {
  static FetchListReview parseResultsListReview(String responseBody) {
    var result = json.decode(responseBody);
    FetchListReview results = FetchListReview.fromJson(result);
    return results;
  }

  static Future<FetchListReview> fetchListReview(int page, int limit, String idProduct) async {
    String token = await AccountHandler.getToken();
    print(token);

    final response = await http.get(
        Uri.parse('${ShareString.URL_API}/reviews/product/?id=$idProduct&page=$page&limit=$limit'),
        headers: <String, String> {
          HttpHeaders.contentTypeHeader: "application/json", // or whatever
          HttpHeaders.authorizationHeader: token,
        },
    );
    if (response.statusCode == 200) {
      return compute(parseResultsListReview, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Can\'t get results');
    }
  }

  static FetchRating parseResultsRating(String responseBody) {
    var result = json.decode(responseBody);
    FetchRating results = FetchRating.fromJson(result);
    return results;
  }

  static Future<FetchRating> fetchRating(String idProduct) async {
    print('Gọi lại');
    final response = await http.get(Uri.parse('${ShareString.URL_API}/reviews/rating/$idProduct'));
    if (response.statusCode == 200) {
      return compute(parseResultsRating, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Can\'t get results');
    }
  }

  static Future<FetchRating> createReview(String idUser, String idProduct, int point, String comment) async {

    String token = await AccountHandler.getToken();
    print(token);

    final response = await http.post(
        Uri.parse('${ShareString.URL_API}/reviews/addReview'),
        headers: <String, String> {
          HttpHeaders.contentTypeHeader: "application/json", // or whatever
          HttpHeaders.authorizationHeader: token,
        },
        body: jsonEncode(<String, dynamic> {
          "idUser": idUser,
          "idProduct": idProduct,
          "point": point,
          "comment": comment,
        })
    );
    if (response.statusCode == 200) {
      return compute(parseResultsRating, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      print(response.body);
      throw Exception('Can\'t get results');
    }
  }

}