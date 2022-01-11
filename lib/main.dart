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
      home: ShList(),
    );
  }
} // MyApp

class ShList extends StatefulWidget {
  @override
  _ShListState createState() => _ShListState();
} // ShList

class _ShListState extends State<ShList> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shoping List'),
      ),
      body: ListView.builder(
        itemCount: shopingList.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(shopingList[index].name),
            onDismissed: (direction) {
              String strName = shopingList[index].name;
              helper.deleteList(shopingList[index]);
              setState(() {
                shopingList.removeAt(index);
              });
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("$strName deleted")));
            },
            child: ListTile(
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
                      builder: (BuildContext context) => dialog.buildDialog(
                          context, shopingList[index], false));
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
            builder: (BuildContext context) =>
                dialog.buildDialog(context, ShopingList(0, '', 0), true),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
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


