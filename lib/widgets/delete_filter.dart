import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/bloc/todo_bloc.dart';
import 'package:flutter_to_do_app/utils/utils.dart';

class DeleteFilter extends StatelessWidget {
  final TodoBloc todoBloc;
  final int categoryId;

  const DeleteFilter(
      {Key? key, required this.todoBloc, required this.categoryId})
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
        todoBloc.getTodosByCategoryId(categoryId: categoryId);
      },
    );
  }
}
