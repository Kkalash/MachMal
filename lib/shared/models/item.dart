import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String? id;
  final String description;
  bool isDone;

  Item({this.id, required this.description, this.isDone = false});

  factory Item.fromSnapshot(DocumentSnapshot snapshot) {
    final item = Item.fromJson(snapshot.data() as Map<String, dynamic>);
    item.id = snapshot.reference.id;

    return item;
  }

  factory Item.fromJson(Map<String, dynamic> json) => _itemFromJson(json);

  Map<String, dynamic> toJson() => _itemToJson(this);
}

Item _itemFromJson(Map<String, dynamic> json) {
  return Item(
    description: json['description'] as String,
    isDone: json['is_done'] as bool,
  );
}

Map<String, dynamic> _itemToJson(Item instance) => <String, dynamic>{
      'description': instance.description,
      'is_done': instance.isDone,
    };
