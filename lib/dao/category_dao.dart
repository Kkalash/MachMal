import 'dart:async';
import 'package:flutter_to_do_app/database/database_category.dart';
import 'package:flutter_to_do_app/model/category.dart';

class CategoryDao {
  final dbprovider = DatabaseProvider.dbProvider;

  Future<int> createCategory(Category category) async {
    final db = await dbprovider.database;
    var result = db.insert(categoryTABLE, category.toDatabaseJson());
    return result;
  }

  Future<List<Category>> getCategories(
      {List<String>? columns, String? query}) async {
    final db = await dbprovider.database;

    List<Map<String, dynamic>> result = [];
    if (query != null) {
      if (query.isNotEmpty) {
        result = await db.query(categoryTABLE,
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ['%$query%']);
      }
    } else {
      result = await db.query(categoryTABLE, columns: columns);
    }

    List<Category> caregory = result.isNotEmpty
        ? result.map((item) => Category.fromDataJson(item)).toList()
        : [];

    return caregory;
  }

  Future<int> updateCategory(Category category) async {
    final db = await dbprovider.database;

    var result = await db.update(categoryTABLE, category.toDatabaseJson(),
        where: 'id = ?', whereArgs: [category.id]);

    return result;
  }

  Future<int> deleteCategory(int id) async {
    final db = await dbprovider.database;
    var result =
        await db.delete(categoryTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }
}
