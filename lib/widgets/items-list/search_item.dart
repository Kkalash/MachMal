import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/shared/utils/utils.dart';
import 'package:flutter_to_do_app/repository/item_repository.dart';

class SearchItem extends StatefulWidget {
  final BuildContext context;
  final String categoryId;
  final ItemRepository repository;

  const SearchItem(
      {Key? key,
      required this.context,
      required this.categoryId,
      required this.repository})
      : super(key: key);

  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  late String categoryId;
  late ItemRepository repository;

  @override
  initState() {
    super.initState();
    categoryId = widget.categoryId;
    repository = widget.repository;
  }

  @override
  Widget build(BuildContext context) {
    context = widget.context;

    return IconButton(
      icon: const Icon(
        Icons.search,
        size: 28,
        color: primaryColor,
      ),
      onPressed: () => _showItemSearchSheet(context),
    );
  }

  void _showItemSearchSheet(BuildContext context) {
    final itemSearchDescriptionFormController = TextEditingController();

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
                height: 150,
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
                              controller: itemSearchDescriptionFormController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: 'Search for item...',
                                labelText: 'Search *',
                                labelStyle: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
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
                                  repository.filterItems(
                                      categoryId,
                                      itemSearchDescriptionFormController
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
