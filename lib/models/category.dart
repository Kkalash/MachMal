import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String? categoryId;
  String title;

  Category({this.categoryId, required this.title});

  factory Category.fromSnapshot(DocumentSnapshot snapshot) {
    final category = Category.fromJson(snapshot.data() as Map<String, dynamic>);
    category.categoryId = snapshot.reference.id;

    return category;
  }

  factory Category.fromJson(Map<String, dynamic> json) =>
      _categoryFromJson(json);

  Map<String, dynamic> toJson() => _categoryToJson(this);

  @override
  String toString() => 'Category<$title>';
}

Category _categoryFromJson(Map<String, dynamic> json) {
  return Category(title: json['title'] as String);
}

Map<String, dynamic> _categoryToJson(Category instance) => <String, dynamic>{
      'title': instance.title,
    };
