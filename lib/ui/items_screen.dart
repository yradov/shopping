import 'package:flutter/material.dart';

import '../models/list_items.dart';
import '../models/shoping_list.dart';
import '../util/dbhelper.dart';

class ItemsScreen extends StatefulWidget {
  final ShopingList shopingList;

  const ItemsScreen(
    this.shopingList,
  );

  @override
  _ItemsScreenState createState() => _ItemsScreenState(shopingList);
} // ItemsScreen

class _ItemsScreenState extends State<ItemsScreen> {
  final ShopingList shopingList;
  _ItemsScreenState(this.shopingList);

  DBHelper helper = DBHelper();
  List<ListItem> items = [];

  @override
  Widget build(BuildContext context) {
    showData(shopingList.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(shopingList.name),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(items[index].name),
            subtitle: Text(
              'Quantity: ${items[index].quantity} - Note: ${items[index].note}',
            ),
            onTap: () {},
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            ),
          );
        },
      ),
    );
  } // build

  Future showData(int idList) async {
    await helper.openDb();
    items = await helper.getItems(idList);

    setState(() {
      items = items;
    });
  } // showData
}// _ItemsScreenState
