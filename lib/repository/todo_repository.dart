import 'package:flutter_to_do_app/dao/todo_dao.dart';
import 'package:flutter_to_do_app/models/todo.dart';

class TodoRepository {
  final todoDao = TodoDao();

  Future getAllTodosByCategoryId({required int categoryId}) =>
      todoDao.getTodosByCategoryId(categoryId: categoryId);

  Future filterTodosByDescription(
          {required int categoryId, required String description}) =>
      todoDao.filterTodosByDescription(categoryId, description);

  Future insertTodo(Todo todo) => todoDao.createTodo(todo);

  Future updateTodo(Todo todo) => todoDao.updateTodo(todo);

  Future deleteTodoById(int id) => todoDao.deleteTodo(id);

  Future deleteAllTodos() => todoDao.deleteAllTodos();
}
