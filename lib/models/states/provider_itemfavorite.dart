import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:furniture_mcommerce_app/local_store/db/account_handler.dart';
import 'package:furniture_mcommerce_app/local_store/db/itemfavorite_handler.dart';

class ProviderItemFavorite with ChangeNotifier {
  int _countItemFavorite = 0;

  ProviderItemFavorite(){
      fetchQuantityItemFavorite();
  }

  int get getCountItemFavorite => _countItemFavorite;

  set countItemFavorite(int value) {
    _countItemFavorite = value;
  }

  void setCountItemFavorite(int value) {
      _countItemFavorite = value;
      notifyListeners();
  }

  void reloadCountItemFavorite(){
    fetchQuantityItemFavorite();
  }

  Future<void> fetchQuantityItemFavorite() async {
      String idUser = await AccountHandler.getIdUser();
      if(idUser.isEmpty) return;
      _countItemFavorite = await ItemFavoriteHandler.countItem(idUser);
      notifyListeners();
  }

}