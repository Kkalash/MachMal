import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_to_do_app/authentification/auth.dart';

class Category {
  String? id;
  String? uid;
  String title;
  int categoryIndex;

  Category(
      {this.id, this.uid, required this.title, required this.categoryIndex});

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
  return Category(
      title: json['title'] as String,
      uid: json['uid'] != null ? (json['uid'] as String) : null,
      categoryIndex: json['category_index'] as int);
}

Map<String, dynamic> _categoryToJson(Category instance) => <String, dynamic>{
      'title': instance.title,
      'uid': AuthenticationService.uid,
      'category_index': instance.categoryIndex
    };
