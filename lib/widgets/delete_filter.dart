import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/repository/todo_firestore_repo.dart';
import 'package:flutter_to_do_app/utils/utils.dart';

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
        // todoBloc.getTodosByCategoryId(categoryId: categoryId);
        repository.getStream(categoryId);
      },
    );
  }
}
