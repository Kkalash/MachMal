import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/shared/models/item.dart';
import 'package:flutter_to_do_app/shared/utils/utils.dart';
import 'package:flutter_to_do_app/repository/item_repository.dart';

class AddItem extends StatefulWidget {
  final BuildContext context;
  final String categoryId;
  final ItemRepository repository;

  const AddItem(
      {Key? key,
      required this.context,
      required this.categoryId,
      required this.repository})
      : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  late String categoryId;
  late ItemRepository repository;

  @override
  void initState() {
    super.initState();

    categoryId = widget.categoryId;
    repository = widget.repository;
  }

  @override
  Widget build(BuildContext context) {
    context = widget.context;

    return FloatingActionButton(
      elevation: 5.0,
      onPressed: () => _showAddItemSheet(context),
      backgroundColor: primaryColor,
      child: const Icon(
        Icons.add,
        size: 32,
        color: tertiaryColor,
      ),
    );
  }

  void _showAddItemSheet(BuildContext context) {
    final itemDescriptionController = TextEditingController();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
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
                              controller: itemDescriptionController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: const TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                  hintText: 'I have to...',
                                  labelText: 'New Item',
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
                                  final newItem = Item(
                                      description: itemDescriptionController
                                          .value.text
                                          .trim());

                                  if (newItem.description.isNotEmpty) {
                                    repository.addItem(categoryId, newItem);

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
