import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import 'package:furniture_mcommerce_app/shared_resources/share_string.dart';
import 'package:furniture_mcommerce_app/models/authorization.dart';
import 'package:path/path.dart';

import '../local_store/db/account_handler.dart';

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

    static FetchInfoUser parseResultsInfoUser(String responseBody) {
      var result = json.decode(responseBody);
      FetchInfoUser results = FetchInfoUser.fromJson(result);

      return results;
    }

    static Future<FetchInfoUser> getInfoUser() async {

      String token = await AccountHandler.getToken();
      print(token);

      final response = await http.get(
          Uri.parse('${ShareString.URL_API}/users/info'),
          headers: <String, String> {
            HttpHeaders.contentTypeHeader: "application/json", // or whatever
            HttpHeaders.authorizationHeader: token,
          }
      );
      if (response.statusCode == 200) {
        return compute(parseResultsInfoUser, response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Not Found');
      } else {
        throw Exception('Can\'t get results');
      }
    }

    static Future<FetchInfoUser> updateInfoUser(String idUser, String fullName, String sdt, String email,
        String gender, String dayOfBird) async {

      String token = await AccountHandler.getToken();
      print(token);

      final response = await http.put(
          Uri.parse('${ShareString.URL_API}/users/updateInfo/?id=$idUser'),
          headers: <String, String> {
            HttpHeaders.contentTypeHeader: "application/json", // or whatever
            HttpHeaders.authorizationHeader: token,
          },
          body: jsonEncode(<String, dynamic> {
            'fullName': fullName,
            'sdtUser': sdt,
            'email': email,
            'gender': gender,
            'dateOfBirth': dayOfBird
          })
      );
      if (response.statusCode == 200) {
        return compute(parseResultsInfoUser, response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Not Found');
      } else {
        throw Exception('Can\'t get results');
      }
    }

    static Future<FetchInfoUser> updateAvatar(String idUser, File image) async {

      String token = await AccountHandler.getToken();
      print(token);

      // Tạo request với phương thức PUT
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${ShareString.URL_API}/images/uploadavatar/?id=$idUser'),
      );

      // Thêm token vào header
      request.headers['authorization'] = token;

      // Thêm hình ảnh vào request dưới dạng form-data
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();

      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: basename(image.path),
        contentType: MediaType('image', 'jpeg'), // Thay đổi kiểu dữ liệu tùy theo định dạng hình ảnh của bạn
      );

      request.files.add(multipartFile);

      // Gửi request và nhận response
      var response = await request.send();



      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        return compute(parseResultsInfoUser, responseBody);
      } else if (response.statusCode == 404) {
        throw Exception('Not Found');
      } else {
        throw Exception('Can\'t get results');
      }
    }
}