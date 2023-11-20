import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:furniture_mcommerce_app/local_store/db/account_handler.dart';
import 'package:furniture_mcommerce_app/models/order.dart';
import 'package:http/http.dart' as http;

import 'package:furniture_mcommerce_app/shared_resources/share_string.dart';

import '../models/ItemOrder.dart';

class OrderController {

  static FetchOrder parseResultsOrder(String responseBody) {
    var result = json.decode(responseBody);
    FetchOrder results = FetchOrder.fromJson(result);

    return results;
  }

  static Future<FetchOrder> createOrder(String idDelivery, String idUser, String idPayment,
      String name, String sdt, String address, double total, bool payStatus, List<ItemOrder> items) async {

    String token = await AccountHandler.getToken();
    print(token);

    final response = await http.post(
        Uri.parse('${ShareString.URL_API}/orders/createOrder'),
        headers: <String, String> {
          HttpHeaders.contentTypeHeader: "application/json", // or whatever
          HttpHeaders.authorizationHeader: token,
        },
        body: jsonEncode(<String, dynamic> {
          "idDelivery": idDelivery,
          "idUser": idUser,
          "idPayment": idPayment,
          "nameCustomer": name,
          "sdtOrder": sdt,
          "address": address,
          "total": total,
          "payStatus": payStatus,
          "products": items
        })
    );
    if (response.statusCode == 200) {
      return compute(parseResultsOrder, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      print(response.body);
      throw Exception('Can\'t get results');
    }
  }

  static Future<FetchOrder> getInfoOrder(String idOrder) async {

    String token = await AccountHandler.getToken();
    print(token);

    final response = await http.get(
        Uri.parse('${ShareString.URL_API}/orders/items/?id=$idOrder'),
        headers: <String, String> {
          HttpHeaders.contentTypeHeader: "application/json", // or whatever
          HttpHeaders.authorizationHeader: token,
        }
    );
    if (response.statusCode == 200) {
      return compute(parseResultsOrder, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      print(response.body);
      throw Exception('Can\'t get results');
    }
  }

  static FetchListOrder parseResultsListOrder(String responseBody) {
    var result = json.decode(responseBody);
    FetchListOrder results = FetchListOrder.fromJson(result);

    return results;
  }

  static Future<FetchListOrder> getListOrderProcess(String idUser) async {

    String token = await AccountHandler.getToken();
    print(token);

    final response = await http.get(
        Uri.parse('${ShareString.URL_API}/orders/list-order-process-for-user/?idUser=$idUser'),
        headers: <String, String> {
          HttpHeaders.contentTypeHeader: "application/json", // or whatever
          HttpHeaders.authorizationHeader: token,
        },
    );
    if (response.statusCode == 200) {
      return compute(parseResultsListOrder, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      print(response.body);
      throw Exception('Can\'t get results');
    }
  }

  static Future<FetchListOrder> getListOrderReadyDelivery(String idUser) async {

    String token = await AccountHandler.getToken();
    print(token);

    final response = await http.get(
      Uri.parse('${ShareString.URL_API}/orders/list-order-readydelivery-for-user/?idUser=$idUser'),
      headers: <String, String> {
        HttpHeaders.contentTypeHeader: "application/json", // or whatever
        HttpHeaders.authorizationHeader: token,
      },
    );
    if (response.statusCode == 200) {
      return compute(parseResultsListOrder, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      print(response.body);
      throw Exception('Can\'t get results');
    }
  }

  static Future<FetchListOrder> getListOrderDelivering(String idUser) async {

    String token = await AccountHandler.getToken();
    print(token);

    final response = await http.get(
      Uri.parse('${ShareString.URL_API}/orders/list-order-delivering-for-user/?idUser=$idUser'),
      headers: <String, String> {
        HttpHeaders.contentTypeHeader: "application/json", // or whatever
        HttpHeaders.authorizationHeader: token,
      },
    );
    if (response.statusCode == 200) {
      return compute(parseResultsListOrder, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      print(response.body);
      throw Exception('Can\'t get results');
    }
  }

  static Future<FetchListOrder> getListOrderDelivered(String idUser) async {

    String token = await AccountHandler.getToken();
    print(token);

    final response = await http.get(
      Uri.parse('${ShareString.URL_API}/orders/list-order-delivered-for-user/?idUser=$idUser'),
      headers: <String, String> {
        HttpHeaders.contentTypeHeader: "application/json", // or whatever
        HttpHeaders.authorizationHeader: token,
      },
    );
    if (response.statusCode == 200) {
      return compute(parseResultsListOrder, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      print(response.body);
      throw Exception('Can\'t get results');
    }
  }

  static Future<FetchListOrder> getListOrderCancel(String idUser) async {

    String token = await AccountHandler.getToken();
    print(token);

    final response = await http.get(
      Uri.parse('${ShareString.URL_API}/orders/list-order-cancel-for-user/?idUser=$idUser'),
      headers: <String, String> {
        HttpHeaders.contentTypeHeader: "application/json", // or whatever
        HttpHeaders.authorizationHeader: token,
      },
    );
    if (response.statusCode == 200) {
      return compute(parseResultsListOrder, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      print(response.body);
      throw Exception('Can\'t get results');
    }
  }

  static FetchNumOrder parseResultsNumOrder(String responseBody) {
    var result = json.decode(responseBody);
    FetchNumOrder results = FetchNumOrder.fromJson(result);

    return results;
  }

  static Future<FetchNumOrder> getNumOrder(String idUser) async {

    String token = await AccountHandler.getToken();
    print(token);

    final response = await http.get(
      Uri.parse('${ShareString.URL_API}/orders/count-order-for-user/?idUser=$idUser'),
      headers: <String, String> {
        HttpHeaders.contentTypeHeader: "application/json", // or whatever
        HttpHeaders.authorizationHeader: token,
      },
    );
    if (response.statusCode == 200) {
      return compute(parseResultsNumOrder, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      print(response.body);
      throw Exception('Can\'t get results');
    }
  }

  static Future<FetchOrder> cancleOrder(String idOrder, String status, List<ItemOrder> items) async {

    String token = await AccountHandler.getToken();
    print(token);

    final response = await http.put(
        Uri.parse('${ShareString.URL_API}/orders/cancleOrder/?idOrder=$idOrder'),
        headers: <String, String> {
          HttpHeaders.contentTypeHeader: "application/json", // or whatever
          HttpHeaders.authorizationHeader: token,
        },
        body: jsonEncode(<String, dynamic> {
          "status": status,
          "products": items
        })
    );
    if (response.statusCode == 200) {
      return compute(parseResultsOrder, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      print(response.body);
      throw Exception('Can\'t get results');
    }
  }

}

