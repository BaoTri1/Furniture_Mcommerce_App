import 'package:furniture_mcommerce_app/local_store/db/furiture_shop_database.dart';
import 'package:furniture_mcommerce_app/models/localstore/itemcart.dart';
import 'package:sqflite/sqflite.dart';

class ItemCartHandler {
  static Future<ItemCart> insertItemCart(
      ItemCart item) async {
    Database db = await FurnitureShopDatabase.getInstance();
    item.id = await db.insert(
        FurnitureShopDatabase.NAME_TABLE_ITEMS_CART, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return item;
  }

  static Future<int> countItem(String idUser) async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
    await db.query(FurnitureShopDatabase.NAME_TABLE_ITEMS_CART,
        where: 'idUser = ?',  whereArgs: [idUser]);

    return maps.length;
  }

  static Future<int> lastIndex() async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
    await db.query(FurnitureShopDatabase.NAME_TABLE_ITEMS_CART);

    int maxindex = 0;
    if (maps.isNotEmpty) {
      for (var i = 0; i < maps.length; i++) {
        if (maps[i]['id'] > maxindex) {
          maxindex = maps[i]['id'];
        }
      }
    }
    return maxindex;
  }

  static Future<List<ItemCart>> getListItemCart(String idUser) async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
    await db.query(FurnitureShopDatabase.NAME_TABLE_ITEMS_CART, where: 'idUser = ?', whereArgs: [idUser]);
    List<ItemCart> items = [];
    if (maps.isNotEmpty) {
      for (var i = 0; i < maps.length; i++) {
        items.add(ItemCart.fromMap(maps[i]));
      }
    }
    return items;
  }

  static Future<bool> checkItemCart(String idProduct, String idUser) async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
    await db.query(FurnitureShopDatabase.NAME_TABLE_ITEMS_CART,
        where: 'idProduct = ? AND idUser = ?',  whereArgs: [idProduct, idUser]);

    if (maps.isNotEmpty) {
      return true;
    }
    return false;
  }

  static Future<int> getQuantityProduct(String idProduct, String idUser) async {
    int quantity = 0;
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps = await db.query(FurnitureShopDatabase.NAME_TABLE_ITEMS_CART,
        where: 'idProduct = ? AND idUser = ?',  whereArgs: [idProduct, idUser]);

    if (maps.isNotEmpty) {
        quantity = maps[0]['quantity'];
    }
    return quantity;
  }

  static Future<int> updateQuantityItemCart(String idProduct, String idUser, int newQuantity) async {
    Database db = await FurnitureShopDatabase.getInstance();
    return await db.update(
        FurnitureShopDatabase.NAME_TABLE_ITEMS_CART, {'quantity': newQuantity},
        where: 'idProduct = ? and idUser = ?', whereArgs: [idProduct, idUser]);
  }

  static Future<int> updateItemCart(ItemCart item) async {
    Database db = await FurnitureShopDatabase.getInstance();
    return await db.update(
        FurnitureShopDatabase.NAME_TABLE_ITEMS_CART, item.toMap(),
        where: 'id = ? and idUser = ?', whereArgs: [item.id, item.idUser]);
  }

  static Future<void> deleteAll() async {
    Database db = await FurnitureShopDatabase.getInstance();
    await db.delete(FurnitureShopDatabase.NAME_TABLE_ITEMS_CART);
  }

  static Future<int> deleteItemCart(String idProduct, String idUser) async {
    Database db = await FurnitureShopDatabase.getInstance();
    return await db.delete(FurnitureShopDatabase.NAME_TABLE_ITEMS_CART,
        where: 'idProduct = ? AND idUser = ?', whereArgs: [idProduct, idUser]);
  }

  static Future close() async {
    Database db = await FurnitureShopDatabase.getInstance();
    db.close();
  }

}