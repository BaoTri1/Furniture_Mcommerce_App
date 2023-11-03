import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:furniture_mcommerce_app/local_store/db/account_handler.dart';
import 'package:furniture_mcommerce_app/local_store/db/itemcart_handler.dart';

class ProviderItemCart with ChangeNotifier {
  int _countItemCart = 0;

  ProviderItemCart(){
    fetchQuantityItemCart();
  }

  int get getCountItemCart => _countItemCart;

  set countItemCart(int value) {
    _countItemCart = value;
  }

  void setCountItemCart(int value) {
    _countItemCart = value;
    notifyListeners();
  }

  void reloadCountItemCart(){
    fetchQuantityItemCart();
  }

  Future<void> fetchQuantityItemCart() async {
    String idUser = await AccountHandler.getIdUser();
    if(idUser.isEmpty) return;
    _countItemCart = await ItemCartHandler.countItem(idUser);
    notifyListeners();
  }

}