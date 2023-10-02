import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FurnitureShopDatabase {
  static Database? _database;

  static const String NAME_DATABASE = 'FurnitureShopDatabase.db';

  static const String NAME_TABLE_ACCOUNT = 'Account';
  static const String NAME_TABLE_HISTORY_SEARCH = 'HistorySearch';
  static const String NAME_TABLE_ITEMS_CART = 'ItemsCart';
  static const String NAME_TABLE_ITEMS_FAVORITES = 'ItemsFavorites';
  static const String NAME_TABLE_SHIPPING_ADDRESS = 'ShippingAddress';

  static Future getInstance() async {
    _database ??=
        await openDatabase(join(await getDatabasesPath(), NAME_DATABASE),
            onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE $NAME_TABLE_ACCOUNT(id INTEGER PRIMARY KEY, sdt TEXT, passwd TEXT, isLogin INTEGER)");
      await db.execute(
          "CREATE TABLE $NAME_TABLE_HISTORY_SEARCH(id INTEGER PRIMARY KEY, id_user TEXT, text TEXT)");
      await db.execute(
          "CREATE TABLE $NAME_TABLE_ITEMS_CART(id INTEGER PRIMARY KEY, id_user TEXT, name TEXT, price REAL, quantity INTEGER, urlImg TEXT)");
      await db.execute(
          "CREATE TABLE $NAME_TABLE_ITEMS_FAVORITES(id INTEGER PRIMARY KEY, id_user TEXT, name TEXT, urlImg TEXT)");
      await db.execute(
          "CREATE TABLE $NAME_TABLE_SHIPPING_ADDRESS(id INTEGER PRIMARY KEY, id_user TEXT, name TEXT, sdt TEXT, address TEXT, isDefault INTEGER)");
    }, version: 2);
    return _database!;
  }
}
