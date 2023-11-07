import 'package:furniture_mcommerce_app/local_store/db/furiture_shop_database.dart';
import 'package:furniture_mcommerce_app/models/localstore/item_history_search.dart';
import 'package:furniture_mcommerce_app/models/localstore/shipping_address.dart';
import 'package:sqflite/sqflite.dart';

class ShippingAddressHandler {
  static Future<ShippingAddress> insertShippingAddress(
      ShippingAddress item) async {
    Database db = await FurnitureShopDatabase.getInstance();
    item.id = await db.insert(
        FurnitureShopDatabase.NAME_TABLE_SHIPPING_ADDRESS, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return item;
  }

  static Future<int> countItem(String idUser) async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
        await db.query(FurnitureShopDatabase.NAME_TABLE_SHIPPING_ADDRESS,
            where: 'idUser = ?',  whereArgs: [idUser]);

    return maps.length;
  }

  static Future<int> lastIndex() async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
    await db.query(FurnitureShopDatabase.NAME_TABLE_SHIPPING_ADDRESS);

    int maxindex = 0;
    if (maps.isNotEmpty) {
      for (var i = 0; i < maps.length; i++) {
        if(maps[i]['id'] > maxindex){
          maxindex = maps[i]['id'];
        }
      }
    }

    return maxindex;
  }

  static Future<List<ShippingAddress>> getListItemShippingAddress(String idUser) async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
        await db.query(FurnitureShopDatabase.NAME_TABLE_SHIPPING_ADDRESS, where: 'idUser = ?', whereArgs: [idUser]);
    List<ShippingAddress> items = [];
    if (maps.isNotEmpty) {
      for (var i = 0; i < maps.length; i++) {
        items.add(ShippingAddress.fromMap(maps[i]));
      }
    }
    return items;
  }

  static Future<ShippingAddress> getItemShippingAddressDefault(String idUser) async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
    await db.query(FurnitureShopDatabase.NAME_TABLE_SHIPPING_ADDRESS, where: 'idUser = ? and isDefault = ?', whereArgs: [idUser, 1]);
    print(maps[0]);
    return ShippingAddress.fromMap(maps[0]);
  }

  static Future<int> updateShippingAddress(ShippingAddress item) async {
    Database db = await FurnitureShopDatabase.getInstance();
    return await db.update(
        FurnitureShopDatabase.NAME_TABLE_SHIPPING_ADDRESS, item.toMap(),
        where: 'id = ? and idUser = ?', whereArgs: [item.id, item.idUser]);
  }

  static Future<void> deleteAll() async {
    Database db = await FurnitureShopDatabase.getInstance();
    await db.delete(FurnitureShopDatabase.NAME_TABLE_SHIPPING_ADDRESS);
  }

  static Future<int> deleteItemShippingAddress(int id, String id_user) async {
    Database db = await FurnitureShopDatabase.getInstance();
    return await db.delete(FurnitureShopDatabase.NAME_TABLE_SHIPPING_ADDRESS,
        where: 'id = ? AND idUser = ?', whereArgs: [id, id_user]);
  }

  static Future close() async {
    Database db = await FurnitureShopDatabase.getInstance();
    db.close();
  }
}
