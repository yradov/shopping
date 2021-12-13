class ShopingList {
  int id;
  String name;
  int priority;

  ShopingList({
    required this.id,
    required this.name,
    required this.priority,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0) ? null : id,
      'name': name,
      'priority': priority,
    };
  }
}// ShopingList
