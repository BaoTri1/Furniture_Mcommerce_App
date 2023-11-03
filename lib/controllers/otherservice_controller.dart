import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:furniture_mcommerce_app/models/methodpayment.dart';
import 'package:furniture_mcommerce_app/models/methodshipping.dart';
import 'package:http/http.dart' as http;

import 'package:furniture_mcommerce_app/shared_resources/share_string.dart';

class OtherServiceController {

  static FetchMethodShipping parseResultsListMethodShipping(String responseBody) {
    var result = json.decode(responseBody);
    FetchMethodShipping results = FetchMethodShipping.fromJson(result);
    return results;
  }

  static Future<FetchMethodShipping> fetchListMethodShipping(String token) async {
    final response = await http.get(
        Uri.parse('${ShareString.URL_API}/services/methodShipping'),
      headers: <String, String> {
        HttpHeaders.contentTypeHeader: "application/json", // or whatever
        HttpHeaders.authorizationHeader: token,
      },
    );
    if (response.statusCode == 200) {
      return compute(parseResultsListMethodShipping, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Can\'t get results');
    }
  }

  static FetchMethodPayment parseResultsListMethodPayment(String responseBody) {
    var result = json.decode(responseBody);
    FetchMethodPayment results = FetchMethodPayment.fromJson(result);
    return results;
  }

  static Future<FetchMethodPayment> fetchListMethodPayment(String token) async {
    final response = await http.get(
        Uri.parse('${ShareString.URL_API}/services/methodPayment'),
        headers: <String, String> {
          HttpHeaders.contentTypeHeader: "application/json", // or whatever
          HttpHeaders.authorizationHeader: token,
        },
    );
    if (response.statusCode == 200) {
      return compute(parseResultsListMethodPayment, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Can\'t get results');
    }
  }
}