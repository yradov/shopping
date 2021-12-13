// ignore_for_file: prefer_conditional_assignment

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/list_items.dart';
import '../models/shoping_list.dart';

class DBHelper {
  static const LISTS_TBL = 'lists';
  static const ITEMS_TBL = 'items';

  final int version = 1;
  Database? db;

  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), "shoping.db"),
          onCreate: (database, version) {
        database.execute(
            'CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)');
        database.execute(
            'CREATE TABLE items(id INTEGER PRIMARY KEY, idList INTEGER, name TEXT, quantity TEXT, note TEXT, FOREIGN KEY(idList) REFERENCES lists(id))');
      }, version: version);
    }

    return db!;
  } // openDb

  Future<int> insertList(ShopingList list) async {
    int id = await db!.insert(
      LISTS_TBL,
      list.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }// insertList

  Future<int> insertItem(ListItem item) async {
    int id = await db!.insert(
      ITEMS_TBL,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }// insertItem

  Future testDb() async {
    db = await openDb();
    await db!.execute('INSERT INTO $LISTS_TBL VALUES (0, "Fruit", 2)');
    await db!.execute(
        'INSERT INTO $ITEMS_TBL VALUES (0, 0, "Apples", "2 Kg", "Better if they are green")');

    List lists = await db!.rawQuery('select * from $LISTS_TBL');
    List items = await db!.rawQuery('select * from $ITEMS_TBL');

    print(lists[0].toString());
    print(items[0].toString());
  } // testDb
}// DBHelper
