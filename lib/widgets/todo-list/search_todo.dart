import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/shared/utils/utils.dart';
import 'package:flutter_to_do_app/repository/todo_repository.dart';

class SearchTodo extends StatelessWidget {
  final String categoryId;
  final TodoRepository repository;

  const SearchTodo(
      {Key? key, required this.categoryId, required this.repository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.search,
        size: 28,
        color: primaryColor,
      ),
      onPressed: () {
        _showTodoSearchSheet(context);
      },
    );
  }

  void _showTodoSearchSheet(BuildContext context) {
    final _todoSearchDescriptionFormController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              color: Colors.transparent,
              child: Container(
                height: 230,
                decoration: const BoxDecoration(
                    color: tertiaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _todoSearchDescriptionFormController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: 'Search for todo...',
                                labelText: 'Search *',
                                labelStyle: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              validator: (String? value) {
                                if (value!.isNotEmpty) {
                                  return value.contains('@')
                                      ? 'Do not use the @ char.'
                                      : null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: primaryColor,
                              radius: 18,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  size: 22,
                                  color: tertiaryColor,
                                ),
                                onPressed: () {
                                  repository.filterTodos(
                                      categoryId,
                                      _todoSearchDescriptionFormController
                                          .value.text);

                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
