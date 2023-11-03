import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class ShareMethod {
    static Future<bool> checkInternetConnection(BuildContext context) async {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        // Không có kết nối internet
        return false;
      } else {
        // Có kết nối internet
        return true;
      }
    }
}