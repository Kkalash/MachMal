import '../models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryFirestoreRepo {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('categories');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addCategory(Category category) {
    return collection.add(category.toJson());
  }

  void updateCategory(Category category) async {
    await collection.doc(category.categoryId).update(category.toJson());
  }

  void deleteCategory(String categoryId) async {
    await collection.doc(categoryId).delete();
  }
}
