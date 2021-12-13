import 'package:flutter/material.dart';
import './util/dbhelper.dart';
import './models/list_items.dart';
import './models/shoping_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoping List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Shoping List'),
        ),
        body: ShList(),
      ),
    );
  }
} // MyApp

class ShList extends StatefulWidget {
  ShList({Key? key}) : super(key: key);

  @override
  _ShListState createState() => _ShListState();
} // ShList

class _ShListState extends State<ShList> {
  DBHelper helper = DBHelper();

  @override
  Widget build(BuildContext context) {
    showData();
    return Container();
  } // build

  Future showData() async {
    await helper.openDb();

    ShopingList list = ShopingList(0, 'Bakery', 2);
    int listId = await helper.insertList(list);

    ListItem item = ListItem(0, listId, 'Bread', 'note', '1 kg');
    int itemId = await helper.insertItem(item);

    print('List Id: ' + listId.toString());
    print('Item Id: ' + itemId.toString());
  }
}// _ShListState


