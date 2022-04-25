import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/bloc/category_bloc.dart';
import 'package:flutter_to_do_app/model/category.dart';
import 'package:flutter_to_do_app/ui/home_page.dart';
import 'package:flutter_to_do_app/utils/utils.dart';

class Sidenav extends Drawer {
  final String newCategoryButtonText = 'New Category';
  final String headerTitleText = 'Categories';
  final CategoryBloc categoryBloc;

  const Sidenav(this.categoryBloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      backgroundColor: tertiaryColor,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Container(
              alignment: Alignment.center,
              child: Text(headerTitleText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)),
            ),
            decoration: const BoxDecoration(
              color: primaryAccentColor,
            ),
          ),
          newCategoryButton(context),
          getCategoriesWidget(),
          const Divider(
            color: Colors.black,
            height: 20,
            thickness: 1,
            indent: 5,
            endIndent: 5,
          ),
        ],
      ),
    );
  }

  Widget newCategoryButton(BuildContext contex) {
    return Container(
        height: 50.0,
        margin: const EdgeInsets.only(left: 10, top: 5, right: 90),
        child: ElevatedButton(
          onPressed: () => addNewCategory(contex),
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
                text: TextSpan(
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    children: [
                      const WidgetSpan(
                          child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.0),
                        child: Icon(Icons.add),
                      )),
                      TextSpan(
                          text: newCategoryButtonText,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0))
                    ]),
              ),
            ),
          ),
        ));
  }

  Widget getCategoriesWidget() {
    return StreamBuilder(
        stream: categoryBloc.categories,
        builder:
            (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          return getCategoryCardWidget(snapshot);
        });
  }

  Widget getCategoryCardWidget(AsyncSnapshot<List<Category>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data?.length != null
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data?.length,
              itemBuilder: (context, itemPostion) {
                Category category = snapshot.data![itemPostion];
                final Widget listTitle = ListTile(
                  title: Text(
                    category.description,
                    style: const TextStyle(
                      fontSize: 20.5,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      categoryBloc.deleteCategoryById(category.id!);
                    },
                    child: const Icon(Icons.delete, color: primaryColor),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                      primary: tertiaryColor, // <-- Button color
                    ),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                categoryBloc,
                                currentCategory: category,
                              ))),
                );

                return listTitle;
              })
          : Center(
              child: noCategoryMessageWidget(),
            );
    } else {
      return Center(
        child: loadingData(),
      );
    }
  }

  Widget noCategoryMessageWidget() {
    return const Text(
      'Start adding Category...',
      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
    );
  }

  Widget loadingData() {
    categoryBloc.getCategories();

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        CircularProgressIndicator(),
        Text('Loading...',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
      ],
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
                                      color: Colors.indigoAccent,
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
                              backgroundColor: Colors.indigoAccent,
                              radius: 18,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.save,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  final newCategory = Category(
                                      description:
                                          _categoryDescriptionFormController
                                              .value.text
                                              .trim());
                                  if (newCategory.description.isNotEmpty) {
                                    /*Create new Category object and make sure
                                    the Category description is not empty,
                                    because what's the point of saving empty
                                    Category
                                    */
                                    categoryBloc.addCategory(newCategory);

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
