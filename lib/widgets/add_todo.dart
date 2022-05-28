import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/models/todo.dart';
import 'package:flutter_to_do_app/utils/utils.dart';
import 'package:flutter_to_do_app/repository/todo_firestore_repo.dart';

class AddTodo extends StatelessWidget {
  final String categoryId;
  final TodoFireStoreRepo repository;

  const AddTodo({Key? key, required this.categoryId, required this.repository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 5.0,
      onPressed: () {
        _showAddTodoSheet(context);
      },
      backgroundColor: primaryColor,
      child: const Icon(
        Icons.add,
        size: 32,
        color: tertiaryColor,
      ),
    );
  }

  void _showAddTodoSheet(BuildContext context) {
    final _todoDescriptionFormController = TextEditingController();
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
                              controller: _todoDescriptionFormController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: const TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                  hintText: 'I have to...',
                                  labelText: 'New Todo',
                                  labelStyle: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w500)),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Empty description!';
                                }
                                return value.contains('')
                                    ? 'Do not use the @ char.'
                                    : null;
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
                                  Icons.save,
                                  size: 22,
                                  color: tertiaryColor,
                                ),
                                onPressed: () {
                                  final newTodo = Todo(
                                      description:
                                          _todoDescriptionFormController
                                              .value.text
                                              .trim());

                                  if (newTodo.description.isNotEmpty) {
                                    repository.addTodo(categoryId, newTodo);

                                    Navigator.pop(context);
                                  }
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
