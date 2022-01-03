import 'package:flutter/material.dart';
import '../util/dbhelper.dart';
import '../models/shoping_list.dart';

class ShopingListDialog {
  final txtName = TextEditingController();
  final txtPriority = TextEditingController();

  Widget buildDialog(BuildContext context, ShopingList list, bool isNew) {
    DBHelper helper = DBHelper();

    if (!isNew) {
      txtName.text = list.name;
      txtPriority.text = list.priority.toString();
    }

    return AlertDialog(
      title: Text((isNew) ? 'New shopping list' : 'Edit shopping list'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0)
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: const InputDecoration(hintText: "Shoping List Name"),
            ),
            TextField(
              controller: txtPriority,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: "Shoping List Priority (1-3)"),
            ),
            ElevatedButton(
              child: const Text('Save Shoping List'),
              onPressed: () {
                list.name = txtName.text;
                list.priority = int.parse(txtPriority.text);
                helper.insertList(list);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  } // buildDialog

}// ShopingListDialog
