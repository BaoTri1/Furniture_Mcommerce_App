import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:furniture_mcommerce_app/shared_resources/share_string.dart';
import 'package:furniture_mcommerce_app/models/authorization.dart';

class AuthorizationController {
    static Authorization parseResultsAuthorization(String responseBody) {
        var result = json.decode(responseBody);
        Authorization authorization = Authorization.fromJson(result);

        return authorization;
    }

    static Future<Authorization> loginHandler(String sdt, String passwd) async {
      final response = await http.post(
        Uri.parse('${ShareString.URL_API}/users/login'),
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String> {
          'sdt': sdt,
          'passwd': passwd
        })
      );
      if (response.statusCode == 200) {
        return compute(parseResultsAuthorization, response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Not Found');
      } else {
        throw Exception('Can\'t get results');
      }
    }

    static Future<Authorization> signupHandler(String fullName, String sdt, String passwd) async {
      final response = await http.post(
          Uri.parse('${ShareString.URL_API}/users/signup'),
          headers: <String, String> {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String> {
            'sdt': sdt,
            'passwd': passwd,
            'fullName': fullName,
          })
      );
      if (response.statusCode == 200) {
        return compute(parseResultsAuthorization, response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Not Found');
      } else {
        throw Exception('Can\'t get results');
      }
    }
}