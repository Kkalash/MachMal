import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_to_do_app/shared/models/todo.dart';

class TodoFireStoreRepo {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('categories');

  Stream<QuerySnapshot> getStream(String cateoryId) {
    return collection.doc(cateoryId).collection('todos').snapshots();
  }

  Future<QuerySnapshot> filterTodos(String categoryId, String filter) {
    return collection
        .doc(categoryId)
        .collection('todos')
        .where('description',
            isGreaterThanOrEqualTo: filter, isLessThan: filter + '\uf8ff')
        .get();
  }

  Future<QuerySnapshot> getTodosByCategoryId(String categoryId) {
    return collection.doc(categoryId).collection('todos').get();
  }

  Future<DocumentReference> addTodo(String categoryId, Todo todo) {
    return collection.doc(categoryId).collection('todos').add(todo.toJson());
  }

  void updateTodo(String categoryId, Todo todo) async {
    await collection
        .doc(categoryId)
        .collection('todos')
        .doc(todo.id)
        .update(todo.toJson());
  }

  void deleteTodo(String categoryId, String todoId) async {
    await collection.doc(categoryId).collection('todos').doc(todoId).delete();
  }
}
