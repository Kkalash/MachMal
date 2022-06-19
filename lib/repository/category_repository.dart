import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_to_do_app/authentification/auth.dart';
import 'package:flutter_to_do_app/shared/models/category.dart';

class CategoryRepository {
  final _categoryController = StreamController<List<Category>>.broadcast();
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('categories');

  get category => _categoryController.stream;

  Future<List<Category>> getCategories() async {
    final List<Category> maps = [];

    final Query<Object?> query;
    if (AuthenticationService.uid != null) {
      query = collection.where('uid', isEqualTo: AuthenticationService.uid);
    } else {
      query = collection.where('uid', isNull: true);
    }

    final QuerySnapshot<Object?> querySnapshot =
        await query.orderBy('category_index').get();

    for (var doc in querySnapshot.docs) {
      maps.add(Category.fromSnapshot(doc));
    }

    _categoryController.sink.add(maps);

    return maps;
  }

  Future addCategory(Category category) async {
    await collection.add(category.toJson()).then((_) => getCategories());
  }

  Future updateCategory(Category category) async {
    await collection
        .doc(category.id)
        .update(category.toJson())
        .then((_) => getCategories());
  }

  Future deleteCategory(String categoryId) async {
    await collection
        .doc(categoryId)
        .collection('items')
        .get()
        .then((querySnapshot) => {
              if (querySnapshot.size > 0)
                // ignore: avoid_function_literals_in_foreach_calls
                {querySnapshot.docs.forEach((doc) => doc.reference.delete())}
            })
        .then((_) => collection.doc(categoryId).delete());
  }
}
