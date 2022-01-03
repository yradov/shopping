import 'package:flutter/material.dart';
import './util/dbhelper.dart';
import './models/shoping_list.dart';
import './ui/items_screen.dart';
import './ui/shopping_list_dialog.dart';

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
        body: ShoppingList(),
      ),
    );
  }
} // MyApp

class ShoppingList extends StatefulWidget {
  ShoppingList({Key? key}) : super(key: key);

  @override
  _ShoppingListState createState() => _ShoppingListState();
} // ShList

class _ShoppingListState extends State<ShoppingList> {
  DBHelper helper = DBHelper();
  List<ShopingList> shopingList = [];
  late ShopingListDialog dialog;

  @override
  void initState() {
    dialog = ShopingListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showData();

    return ListView.builder(
      itemCount: shopingList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(shopingList[index].name),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemsScreen(shopingList[index]),
                ));
          },
          leading: CircleAvatar(
            child: Text(shopingList[index].priority.toString()),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      dialog.buildDialog(context, shopingList[index], false));
            },
          ),
        );
      },
    );
  } // build

  Future showData() async {
    await helper.openDb();

    shopingList = await helper.getLists();
    setState(() {
      shopingList = shopingList;
    });
    //TESTS CODE
    // ShopingList list = ShopingList(0, 'Bakery', 2);
    // int listId = await helper.insertList(list);
    // ListItem item = ListItem(0, listId, 'Bread', 'note', '1 kg');
    // int itemId = await helper.insertItem(item);
    // print('List Id: ' + listId.toString());
    // print('Item Id: ' + itemId.toString());
  }
}// _ShListState


