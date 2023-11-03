import 'package:furniture_mcommerce_app/local_store/db/furiture_shop_database.dart';
import 'package:furniture_mcommerce_app/models/localstore/account.dart';
import 'package:sqflite/sqflite.dart';

class AccountHandler {
  static Future<Account> insertAccount(
      Account item) async {
    Database db = await FurnitureShopDatabase.getInstance();
    item.id = await db.insert(
        FurnitureShopDatabase.NAME_TABLE_ACCOUNT, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return item;
  }

  static Future<int> countItem() async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
    await db.query(FurnitureShopDatabase.NAME_TABLE_ACCOUNT);

    return maps.length;
  }

  static Future<int> lastIndex() async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
    await db.query(FurnitureShopDatabase.NAME_TABLE_ACCOUNT);

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

  static Future<bool> checkAccountforDatabase() async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
    await db.query(FurnitureShopDatabase.NAME_TABLE_ACCOUNT, where: 'id = ?', whereArgs: [1]);

    if (maps.isNotEmpty) {
      return true;
    }
    return false;
  }

  static Future<bool> checkIsLogin() async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
    await db.query(FurnitureShopDatabase.NAME_TABLE_ACCOUNT, where: 'id = ?', whereArgs: [1]);

    if (maps.isNotEmpty) {
      if(maps[0]['isLogin'] == 1){
          return true;
      }
    }
    return false;
  }


  static Future<Account> getAccount() async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
    await db.query(FurnitureShopDatabase.NAME_TABLE_ACCOUNT, where: 'id = ?', whereArgs: [1]);

    Account account = Account(id: 0, idUser: '', sdt: '', passwd: '', isLogin: 0, token: '');
    if (maps.isNotEmpty) {
      account = Account(
          id: maps[0]['id'],
          idUser: maps[0]['idUser'],
          sdt: maps[0]['sdt'],
          passwd: maps[0]['passwd'],
          isLogin: maps[0]['isLogin'],
          token: maps[0]['token']);
    }
    return account;
  }

  static Future<String> getToken() async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
    await db.query(FurnitureShopDatabase.NAME_TABLE_ACCOUNT, where: 'id = ?', whereArgs: [1]);

    String token = '';
    if (maps.isNotEmpty) {
      token = maps[0]['token'];
    }
    return token;
  }

  static Future<String> getIdUser() async {
    Database db = await FurnitureShopDatabase.getInstance();
    List<Map<String, dynamic>> maps =
    await db.query(FurnitureShopDatabase.NAME_TABLE_ACCOUNT, where: 'id = ?', whereArgs: [1]);

    String idUser = '';
    if (maps.isNotEmpty) {
      idUser = maps[0]['idUser'];
    }
    return idUser;
  }

  static Future<int> updateAccount(Account item) async {
    Database db = await FurnitureShopDatabase.getInstance();
    return await db.update(
        FurnitureShopDatabase.NAME_TABLE_ACCOUNT, item.toMap(),
        where: 'id = ? and idUser = ?', whereArgs: [item.id, item.idUser]);
  }

  static Future<int> setStateLogin(int id, int isLogin, String token) async {
    Database db = await FurnitureShopDatabase.getInstance();
    return await db.update(
        FurnitureShopDatabase.NAME_TABLE_ACCOUNT,{'isLogin' : isLogin, 'token': token},
        where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteAll() async {
    Database db = await FurnitureShopDatabase.getInstance();
    await db.delete(FurnitureShopDatabase.NAME_TABLE_ACCOUNT);
  }

  static Future<int> deleteItemAccount(int id, String id_user) async {
    Database db = await FurnitureShopDatabase.getInstance();
    return await db.delete(FurnitureShopDatabase.NAME_TABLE_ACCOUNT,
        where: 'id = ? AND idUser = ?', whereArgs: [id, id_user]);
  }

  static Future close() async {
    Database db = await FurnitureShopDatabase.getInstance();
    db.close();
  }
}