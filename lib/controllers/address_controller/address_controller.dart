import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:furniture_mcommerce_app/models/district.dart';
import 'package:furniture_mcommerce_app/models/province.dart';
import 'package:furniture_mcommerce_app/models/ward.dart';
import 'package:http/http.dart' as http;

class AddressController {
  // ignore: constant_identifier_names
  static const String url_province = 'https://vapi.vnappmob.com/api/province/';
  // ignore: constant_identifier_names
  static const String url_district =
      'https://vapi.vnappmob.com/api/province/district/';
  // ignore: constant_identifier_names
  static const String url_ward = 'https://vapi.vnappmob.com/api/province/ward/';

  static ListProvince parseResultsProvince(String responseBody) {
    var result = json.decode(responseBody);
    ListProvince results = ListProvince.fromJson(result);
    return results;
  }

  static Future<ListProvince> fetchProvince() async {
    final response = await http.get(Uri.parse(url_province));
    if (response.statusCode == 200) {
      return compute(parseResultsProvince, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Can\'t get results');
    }
  }

  static ListDistrict parseResultsDistrict(String responseBody) {
    var result = json.decode(responseBody);
    ListDistrict results = ListDistrict.fromJson(result);
    return results;
  }

  static Future<ListDistrict> fetchDistrict(String idProvince) async {
    final response = await http.get(Uri.parse('$url_district$idProvince'));
    if (response.statusCode == 200) {
      return compute(parseResultsDistrict, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Can\'t get results');
    }
  }

  static ListWard parseResultsWard(String responseBody) {
    var result = json.decode(responseBody);
    ListWard results = ListWard.fromJson(result);
    return results;
  }

  static Future<ListWard> fetchWard(String idDistrict) async {
    final response = await http.get(Uri.parse('$url_ward$idDistrict'));
    if (response.statusCode == 200) {
      return compute(parseResultsWard, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Can\'t get results');
    }
  }
}
