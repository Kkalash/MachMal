import 'package:flutter_to_do_app/dao/category_dao.dart';
import 'package:flutter_to_do_app/models/category.dart';

class CategoryRepository {
  final categoryDao = CategoryDao();

  Future getAllCategories({String? query}) =>
      categoryDao.getCategories(query: query);

  Future insertCategory(Category category) =>
      categoryDao.createCategory(category);

  Future updateCategory(Category category) =>
      categoryDao.updateCategory(category);

  Future deleteCategory(int id) => categoryDao.deleteCategory(id);
}
