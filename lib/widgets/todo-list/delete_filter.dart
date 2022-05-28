import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/shared/utils/utils.dart';
import 'package:flutter_to_do_app/repository/todo_firestore_repo.dart';

class DeleteFilter extends StatelessWidget {
  final String categoryId;
  final TodoFireStoreRepo repository;

  const DeleteFilter(
      {Key? key, required this.categoryId, required this.repository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.undo,
        size: 28,
        color: primaryColor,
      ),
      onPressed: () {
        late Future<QuerySnapshot<Object?>> test =
            repository.getTodosByCategoryId(categoryId);
        print(test.asStream());
      },
    );
  }
}
