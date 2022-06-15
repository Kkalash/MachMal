import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_to_do_app/widgets/toast.dart';
import 'package:flutter_to_do_app/shared/utils/utils.dart';
import 'package:flutter_to_do_app/shared/models/category.dart';
import 'package:flutter_to_do_app/shared/enums/toast_type.enum.dart';
import 'package:flutter_to_do_app/repository/category_repository.dart';

class AddCategory extends StatefulWidget {
  final BuildContext context;
  final CategoryRepository categoryRepository;

  const AddCategory(
      {Key? key, required this.context, required this.categoryRepository})
      : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  late CategoryRepository categoryRepository;

  @override
  void initState() {
    super.initState();

    categoryRepository = widget.categoryRepository;
  }

  @override
  Widget build(BuildContext context) {
    context = widget.context;

    return Container(
        height: 50.0,
        margin: const EdgeInsets.only(left: 10, top: 5, right: 90),
        child: ElevatedButton(
          onPressed: () => _showaddNewCategorySheet(context),
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

  void _showaddNewCategorySheet(BuildContext context) {
    final descriptionController = TextEditingController();

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
                              controller: descriptionController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                  hintText: 'Shopping list',
                                  labelText: 'New Category',
                                  labelStyle: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w500)),
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
                                onPressed: () => addCategory(context,
                                    descriptionController.value.text.trim()),
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

  void addCategory(BuildContext context, String description) async {
    final newCategory = Category(title: StringUtils.capitalize(description));

    final isDuplicate = (await categoryRepository.getCategories())
        .any((category) => category.title == newCategory.title);

    if (newCategory.title.isEmpty) {
      Toast(
          context: context,
          message: 'Empty description!',
          type: ToastType.warning);
    } else {
      if (isDuplicate) {
        Toast(
            context: context,
            message: 'Category already exists!',
            type: ToastType.warning);
      } else {
        await categoryRepository.addCategory(newCategory);

        Navigator.pop(context);
      }
    }
  }
}
