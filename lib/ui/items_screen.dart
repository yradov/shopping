import 'package:flutter/material.dart';

import '../models/list_items.dart';
import '../models/shoping_list.dart';
import '../util/dbhelper.dart';

class ItemsScreen extends StatefulWidget {
  final ShopingList shopingList;

  const ItemsScreen(
    this.shopingList,
  ) ;

  @override
  _ItemsScreenState createState() => _ItemsScreenState(shopingList);
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ShopingList shopingList;
  _ItemsScreenState(this.shopingList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shopingList.name),
      ),
      body: Container(),
    );
  }
}
