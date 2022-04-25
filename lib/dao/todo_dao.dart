import 'dart:async';
import 'package:flutter_to_do_app/database/database.dart';
import 'package:flutter_to_do_app/model/todo.dart';

class TodoDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Todo records
  Future<int> createTodo(Todo todo) async {
    final db = await dbProvider.database;
    var result = db.insert(todoTABLE, todo.toDatabaseJson());
    return result;
  }

  //Get All Todo items by Category-ID
  Future<List<Todo>> getTodosByCategoryId(
      {List<String>? columns, required int categoryId}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = [];

    result = await db.query(todoTABLE,
        columns: columns, where: 'category_id = ?', whereArgs: [categoryId]);

    List<Todo> todos = result.isNotEmpty
        ? result.map((item) => Todo.fromDatabaseJson(item)).toList()
        : [];

    return todos;
  }

  Future<List<Todo>> filterTodosByDescription(
      int categoryid, String description) async {
    List<Todo> todos = await getTodosByCategoryId(categoryId: categoryid);
    return todos.map((e) => e.description.contains(description))
        as Future<List<Todo>>;
  }

  //Update Todo record
  Future<int> updateTodo(Todo todo) async {
    final db = await dbProvider.database;

    var result = await db.update(todoTABLE, todo.toDatabaseJson(),
        where: 'id = ?', whereArgs: [todo.id]);

    return result;
  }

  //Delete Todo records
  Future<int> deleteTodo(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(todoTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllTodos() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      todoTABLE,
    );

    return result;
  }
}
