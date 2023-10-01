import 'package:furniture_mcommerce_app/local_store/db/furiture_shop_database.dart';
import 'package:furniture_mcommerce_app/models/item_history_search.dart';
import 'package:sqflite/sqflite.dart';

class HistorySearchHandler {
  static Future<ItemHistorySearch> insertHistorySearch(
      ItemHistorySearch item) async {
    Database db = await FurnitureShopDatabase.getInstance();
    item.id = await db.insert(
        FurnitureShopDatabase.NAME_TABLE_HISTORY_SEARCH, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return item;
  }

  static Future<int> countItem() async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
        await db.query(FurnitureShopDatabase.NAME_TABLE_HISTORY_SEARCH);

    return maps.length;
  }

  static Future<List<ItemHistorySearch>> getListItemHistorySearch() async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
        await db.query(FurnitureShopDatabase.NAME_TABLE_HISTORY_SEARCH);
    List<ItemHistorySearch> items = [];
    if (maps.isNotEmpty) {
      for (var i = 0; i < maps.length; i++) {
        items.add(ItemHistorySearch.fromMap(maps[i]));
      }
    }
    return items;
  }

  static Future<int> updateHistorySearch(ItemHistorySearch item) async {
    Database db = await FurnitureShopDatabase.getInstance();
    return await db.update(
        FurnitureShopDatabase.NAME_TABLE_HISTORY_SEARCH, item.toMap(),
        where: 'id = ? and id_user = ?', whereArgs: [item.id, item.id_user]);
  }

  static Future<void> deleteAll() async {
    Database db = await FurnitureShopDatabase.getInstance();
    await db.delete(FurnitureShopDatabase.NAME_TABLE_HISTORY_SEARCH);
  }

  static Future<int> deleteItemHistorySearch(int id, String id_user) async {
    Database db = await FurnitureShopDatabase.getInstance();
    return await db.delete(FurnitureShopDatabase.NAME_TABLE_HISTORY_SEARCH,
        where: 'id = ? AND id_user = ?', whereArgs: [id, id_user]);
  }

  static Future close() async {
    Database db = await FurnitureShopDatabase.getInstance();
    db.close();
  }
}
