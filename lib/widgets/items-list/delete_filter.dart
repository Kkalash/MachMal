import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/shared/utils/utils.dart';
import 'package:flutter_to_do_app/repository/item_repository.dart';

class DeleteFilter extends StatelessWidget {
  final String categoryId;
  final ItemRepository repository;

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
      onPressed: () => repository.getItemsByCategoryId(categoryId),
    );
  }
}
