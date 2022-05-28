import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryFirebase {
  String? categoryId;
  String title;

  CategoryFirebase({this.categoryId, required this.title});

  factory CategoryFirebase.fromSnapshot(DocumentSnapshot snapshot) {
    final category =
        CategoryFirebase.fromJson(snapshot.data() as Map<String, dynamic>);
    category.categoryId = snapshot.reference.id;

    return category;
  }

  factory CategoryFirebase.fromJson(Map<String, dynamic> json) =>
      _categoryFromJson(json);

  Map<String, dynamic> toJson() => _categoryToJson(this);

  @override
  String toString() => 'Category<$title>';
}

CategoryFirebase _categoryFromJson(Map<String, dynamic> json) {
  return CategoryFirebase(title: json['title'] as String);
}

Map<String, dynamic> _categoryToJson(CategoryFirebase instance) =>
    <String, dynamic>{
      'title': instance.title,
    };
