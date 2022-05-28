import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String? id;
  final String description;
  bool isDone;

  Todo({this.id, required this.description, this.isDone = false});

  factory Todo.fromSnapshot(DocumentSnapshot snapshot) {
    final todo = Todo.fromJson(snapshot.data() as Map<String, dynamic>);
    todo.id = snapshot.reference.id;

    return todo;
  }

  factory Todo.fromJson(Map<String, dynamic> json) => _todoFromJson(json);

  Map<String, dynamic> toJson() => _todoToJson(this);

  @override
  String toString() => 'Todo<$description>';
}

Todo _todoFromJson(Map<String, dynamic> json) {
  return Todo(
    description: json['description'] as String,
    isDone: json['is_done'] as bool,
  );
}

Map<String, dynamic> _todoToJson(Todo instance) => <String, dynamic>{
      'description': instance.description,
      'is_done': instance.isDone,
    };
