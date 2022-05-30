import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_to_do_app/shared/models/category.dart';

class CategoryFirestoreRepo {
  final _categoryController = StreamController<List<Category>>.broadcast();
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('categories');

  get category => _categoryController.stream;

  Future<List<Category>> getCategories() async {
    final List<Category> maps = [];
    final querySnapshot = await collection.get();

    for (var doc in querySnapshot.docs) {
      maps.add(Category.fromSnapshot(doc));
    }

    _categoryController.sink.add(maps);

    return maps;
  }

  Future addCategory(Category category) async {
    collection.add(category.toJson());
    await getCategories();
  }

  void updateCategory(Category category) async {
    await collection.doc(category.id).update(category.toJson());
    await getCategories();
  }

  void deleteCategory(String categoryId) async {
    await collection.doc(categoryId).delete();
    await getCategories();
  }
}
