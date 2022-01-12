// ignore_for_file: prefer_conditional_assignment, constant_identifier_names

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/list_items.dart';
import '../models/shoping_list.dart';

class DBHelper {
  static const LISTS_TBL = 'lists';
  static const ITEMS_TBL = 'items';

  final int version = 1;
  Database? db;

  /*
      In Dart and Flutter, there is a feature called "factory constructors" that overrides
    the default behavior when you call the constructor of a class: instead of creating a
    new instance, the factory constructor only returns an instance of the class.
      In our case, this means that the first time the factory constructor gets called, it will
    return a new instance of DbHelper. After DbHelper has already been
    instantiated, the constructor will not build another instance, but just return the
    existing one.
      In detail, first, we are creating a private constructor named _internal. Then, in
    the factory constructor, we just return it to the outside caller.
  */
  static final DBHelper _dbHelper = DBHelper._internal();
  DBHelper._internal();

  factory DBHelper() {
    return _dbHelper;
  }

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
  } // insertList

  Future<List<ShopingList>> getLists() async {
    final List<Map<String, dynamic>> maps = await db!.query('lists');

    return List.generate(maps.length, (i) {
      return ShopingList(maps[i]['id'], maps[i]['name'], maps[i]['priority']);
    });
  } // getLists

  Future<int> insertItem(ListItem item) async {
    int id = await db!.insert(
      ITEMS_TBL,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  } // insertItem

  Future<List<ListItem>> getItems(int idList) async {
    final List<Map<String, dynamic>> maps =
        await db!.query('items', where: 'idList = ?', whereArgs: [idList]);

    return List.generate(maps.length, (i) {
      return ListItem(
        maps[i]['id'],
        maps[i]['idList'],
        maps[i]['name'],
        maps[i]['quantity'],
        maps[i]['note'],
      );
    });
  } // getItems

  Future<int> deleteList(ShopingList list) async {
    int result =
        await db!.delete("items", where: "idList = ?", whereArgs: [list.id]);
    result = await db!.delete("lists", where: "id = ?", whereArgs: [list.id]);
    return result;
  } // deleteList

  Future<int> deleteItem(ListItem item) async {
    int result =
        await db!.delete("items", where: "id = ?", whereArgs: [item.id]);
    return result;
  }

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
