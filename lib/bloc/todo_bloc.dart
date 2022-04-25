import 'package:flutter_to_do_app/model/todo.dart';
import 'package:flutter_to_do_app/repository/todo_repository.dart';

import 'dart:async';

class TodoBloc {
  //Get instance of the Repository
  final _todoRepository = TodoRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _todoController = StreamController<List<Todo>>.broadcast();

  get todos => _todoController.stream;

  TodoBloc();

  getTodosByCategoryId({required int categoryId}) async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    _todoController.sink.add(
        await _todoRepository.getAllTodosByCategoryId(categoryId: categoryId));
  }

  filterTodos(int categoryId, String description) async {
    await _todoRepository.filterTodosByDescription(
        categoryId: categoryId, description: description);
  }

  addTodo(Todo todo) async {
    await _todoRepository.insertTodo(todo);
    getTodosByCategoryId(categoryId: todo.categoryId);
  }

  updateTodo(Todo todo) async {
    await _todoRepository.updateTodo(todo);
    getTodosByCategoryId(categoryId: todo.categoryId);
  }

  deleteTodoById(int id) async {
    _todoRepository.deleteTodoById(id);
  }

  dispose() {
    _todoController.close();
  }
}
