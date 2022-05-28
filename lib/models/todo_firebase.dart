import 'package:cloud_firestore/cloud_firestore.dart';

class TodoFirebase {
  String? todoId;
  final String description;
  bool isDone;

  TodoFirebase({this.todoId, required this.description, this.isDone = false});

  factory TodoFirebase.fromSnapshot(DocumentSnapshot snapshot) {
    final todo = TodoFirebase.fromJson(snapshot.data() as Map<String, dynamic>);
    todo.todoId = snapshot.reference.id;

    return todo;
  }

  factory TodoFirebase.fromJson(Map<String, dynamic> json) =>
      _todoFromJson(json);

  Map<String, dynamic> toJson() => _todoToJson(this);

  @override
  String toString() => 'Todo<$description>';
}

TodoFirebase _todoFromJson(Map<String, dynamic> json) {
  return TodoFirebase(
    description: json['description'] as String,
    isDone: json['is_done'] as bool,
  );
}

Map<String, dynamic> _todoToJson(TodoFirebase instance) => <String, dynamic>{
      'description': instance.description,
      'is_done': instance.isDone,
    };
