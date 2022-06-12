import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_to_do_app/shared/models/item.dart';

class ItemRepository {
  final itemController = StreamController<List<Item>>.broadcast();
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('categories');

  get items => itemController.stream;

  Future<List<Item>> getItemsByCategoryId(String categoryId) async {
    final List<Item> maps = [];
    final querySnapshot =
        await collection.doc(categoryId).collection('items').get();

    for (var doc in querySnapshot.docs) {
      maps.add(Item.fromSnapshot(doc));
    }

    maps.sort((item1, item2) => item1.isDone ? 1 : -1);
    itemController.sink.add(maps);

    return maps;
  }

  Future filterItems(String categoryId, String filter) async {
    final List<Item> items = await getItemsByCategoryId(categoryId);
    final List<Item> filterItems = items.isNotEmpty
        ? items
            .where((item) =>
                item.description.toLowerCase().contains(filter.toLowerCase()))
            .toList()
        : [];

    itemController.sink.add(filterItems);
  }

  Future addItem(String categoryId, Item item) async {
    collection.doc(categoryId).collection('items').add(item.toJson());
    await getItemsByCategoryId(categoryId);
  }

  void updateItem(String categoryId, Item item) async {
    await collection
        .doc(categoryId)
        .collection('items')
        .doc(item.id)
        .update(item.toJson());

    await getItemsByCategoryId(categoryId);
  }

  void deleteItem(String categoryId, String itemId) async {
    await collection.doc(categoryId).collection('items').doc(itemId).delete();
    await getItemsByCategoryId(categoryId);
  }
}
