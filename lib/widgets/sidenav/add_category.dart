import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_to_do_app/models/category.dart';
import 'package:flutter_to_do_app/utils/utils.dart';
import 'package:flutter_to_do_app/repository/category_repository.dart';

class AddCategory extends StatelessWidget {
  final CategoryFirestoreRepo categoryRepository;

  const AddCategory({Key? key, required this.categoryRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50.0,
        margin: const EdgeInsets.only(left: 10, top: 5, right: 90),
        child: ElevatedButton(
          onPressed: () => addNewCategory(context),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0),
              ))),
          child: Ink(
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryColor, primaryColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: Container(
              constraints:
                  const BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
              alignment: Alignment.center,
              child: RichText(
                text: const TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    children: [
                      WidgetSpan(
                          child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.0),
                        child: Icon(Icons.add),
                      )),
                      TextSpan(
                          text: 'New Category',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0))
                    ]),
              ),
            ),
          ),
        ));
  }

  void addNewCategory(BuildContext context) {
    final _categoryDescriptionFormController = TextEditingController();

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
                    color: Colors.white,
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
                              controller: _categoryDescriptionFormController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: const TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                  hintText: 'Work',
                                  labelText: 'New Category',
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
                                  final test = Category(
                                      title: StringUtils.capitalize(
                                          _categoryDescriptionFormController
                                              .value.text
                                              .trim()));

                                  // final newCategory = Category(
                                  //     description: StringUtils.capitalize(
                                  //         _categoryDescriptionFormController
                                  //             .value.text
                                  //             .trim()));
                                  if (test.title.isNotEmpty) {
                                    /*Create new Category object and make sure
                                    the Category description is not empty,
                                    because what's the point of saving empty
                                    Category
                                    */
                                    // categoryBloc.addCategory(newCategory);
                                    categoryRepository.addCategory(test);

                                    //dismisses the bottomsheet
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
