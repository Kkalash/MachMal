import 'dart:async';

import 'package:flutter_to_do_app/model/category.dart';
import 'package:flutter_to_do_app/repository/category_repository.dart';

class CategoryBloc {
  final _categoryRepository = CategoryRepository();

  final _categoryController = StreamController<List<Category>>.broadcast();

  get categories => _categoryController.stream;

  CategoryBloc() {
    getCategories();
  }

  getCategories({String? query}) async {
    _categoryController.sink
        .add(await _categoryRepository.getAllCategories(query: query));
  }

  addCategory(Category category) async {
    await _categoryRepository.insertCategory(category);
    getCategories();
  }

  updateCategory(Category category) async {
    await _categoryRepository.updateCategory(category);
    getCategories();
  }

  deleteCategoryById(int id) async {
    _categoryRepository.deleteCategory(id);
    getCategories();
  }

  dispose() {
    _categoryController.close();
  }
}
