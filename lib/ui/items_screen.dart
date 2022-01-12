import 'package:flutter/material.dart';

import '../models/list_items.dart';
import '../models/shoping_list.dart';
import '../util/dbhelper.dart';
import 'list_item_dialog.dart';

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
    ListItemDialog dialog = ListItemDialog();

    return Scaffold(
      appBar: AppBar(
        title: Text(shopingList.name),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(items[index].name),
            onDismissed: (direction) {
              String strName = items[index].name;
              helper.deleteItem(items[index]);
              setState(() {
                items.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$strName deleted"),
                ),
              );
            },
            child: ListTile(
              title: Text(items[index].name),
              subtitle: Text(
                'Quantity: ${items[index].quantity} - Note: ${items[index].note}',
              ),
              onTap: () {},
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          dialog.buildAlert(context, items[index], false));
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => dialog.buildAlert(
                  context, ListItem(0, shopingList.id, '', '', ''), true));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.pink,
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
