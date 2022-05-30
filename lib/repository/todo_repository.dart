import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_to_do_app/shared/models/todo.dart';

class TodoRepository {
  final _todoController = StreamController<List<Todo>>.broadcast();
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('categories');

  get todos => _todoController.stream;

  Future<List<Todo>> getTodosByCategoryId(String categoryId) async {
    final List<Todo> maps = [];
    final querySnapshot =
        await collection.doc(categoryId).collection('todos').get();

    for (var doc in querySnapshot.docs) {
      maps.add(Todo.fromSnapshot(doc));
    }

    _todoController.sink.add(maps);

    return maps;
  }

  Future filterTodos(String categoryId, String filter) async {
    final List<Todo> todos = await getTodosByCategoryId(categoryId);
    final List<Todo> filterTodos = todos.isNotEmpty
        ? todos
            .where((todo) =>
                todo.description.toLowerCase().contains(filter.toLowerCase()))
            .toList()
        : [];

    _todoController.sink.add(filterTodos);
  }

  Future addTodo(String categoryId, Todo todo) async {
    collection.doc(categoryId).collection('todos').add(todo.toJson());
    await getTodosByCategoryId(categoryId);
  }

  void updateTodo(String categoryId, Todo todo) async {
    await collection
        .doc(categoryId)
        .collection('todos')
        .doc(todo.id)
        .update(todo.toJson());

    await getTodosByCategoryId(categoryId);
  }

  void deleteTodo(String categoryId, String todoId) async {
    await collection.doc(categoryId).collection('todos').doc(todoId).delete();
    await getTodosByCategoryId(categoryId);
  }
}
