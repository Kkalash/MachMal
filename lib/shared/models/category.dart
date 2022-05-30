import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String? id;
  String title;

  Category({this.id, required this.title});

  factory Category.fromSnapshot(DocumentSnapshot snapshot) {
    final category = Category.fromJson(snapshot.data() as Map<String, dynamic>);
    category.id = snapshot.reference.id;

    return category;
  }

  factory Category.fromJson(Map<String, dynamic> json) =>
      _categoryFromJson(json);

  Map<String, dynamic> toJson() => _categoryToJson(this);
}

Category _categoryFromJson(Map<String, dynamic> json) {
  return Category(title: json['title'] as String);
}

Map<String, dynamic> _categoryToJson(Category instance) => <String, dynamic>{
      'title': instance.title,
    };
