import 'package:furniture_mcommerce_app/local_store/db/furiture_shop_database.dart';
import 'package:furniture_mcommerce_app/models/localstore/itemfavorite.dart';
import 'package:sqflite/sqflite.dart';

class ItemFavoriteHandler {
  static Future<ItemFavorite> insertItemFavorite(
      ItemFavorite item) async {
    Database db = await FurnitureShopDatabase.getInstance();
    item.id = await db.insert(
        FurnitureShopDatabase.NAME_TABLE_ITEMS_FAVORITES, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return item;
  }

  static Future<int> countItem(String idUser) async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
    await db.query(FurnitureShopDatabase.NAME_TABLE_ITEMS_FAVORITES,
        where: 'idUser = ?',  whereArgs: [idUser]);

    return maps.length;
  }

  static Future<int> lastIndex() async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
    await db.query(FurnitureShopDatabase.NAME_TABLE_ITEMS_FAVORITES);

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

  static Future<bool> checkItemFavorite(String idProduct, String idUser) async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
    await db.query(FurnitureShopDatabase.NAME_TABLE_ITEMS_FAVORITES,
            where: 'idProduct = ? AND idUser = ?',  whereArgs: [idProduct, idUser]);

    if (maps.isNotEmpty) {
      return true;
    }
    return false;
  }

  static Future<List<ItemFavorite>> getListItemFavorites(String idUser) async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
    await db.query(FurnitureShopDatabase.NAME_TABLE_ITEMS_FAVORITES, where: 'idUser = ?', whereArgs: [idUser]);
    List<ItemFavorite> items = [];
    if (maps.isNotEmpty) {
      for (var i = 0; i < maps.length; i++) {
        items.add(ItemFavorite.fromMap(maps[i]));
      }
    }
    return items;
  }

  static Future<int> updateItemFavorite(ItemFavorite item) async {
    Database db = await FurnitureShopDatabase.getInstance();
    return await db.update(
        FurnitureShopDatabase.NAME_TABLE_ITEMS_FAVORITES, item.toMap(),
        where: 'id = ? and idUser = ?', whereArgs: [item.id, item.idUser]);
  }

  static Future<void> deleteAll() async {
    Database db = await FurnitureShopDatabase.getInstance();
    await db.delete(FurnitureShopDatabase.NAME_TABLE_ITEMS_FAVORITES);
  }

  static Future<int> deleteItemFavorite(String idProduct, String idUser) async {
    Database db = await FurnitureShopDatabase.getInstance();
    return await db.delete(FurnitureShopDatabase.NAME_TABLE_ITEMS_FAVORITES,
        where: 'idProduct = ? AND idUser = ?', whereArgs: [idProduct, idUser]);
  }

  static Future close() async {
    Database db = await FurnitureShopDatabase.getInstance();
    db.close();
  }

}