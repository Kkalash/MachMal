import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/bloc/category_bloc.dart';
import 'package:flutter_to_do_app/models/category.dart';
import 'package:flutter_to_do_app/ui/todo_list.dart';
import 'package:flutter_to_do_app/utils/utils.dart';
import 'package:flutter_to_do_app/widgets/about.dart';
import 'package:flutter_to_do_app/widgets/add_category.dart';
import 'package:flutter_to_do_app/widgets/no_data.dart';
import 'package:flutter_to_do_app/widgets/settings.dart';

class Sidenav extends Drawer {
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
              child: const Text('Categories',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)),
            ),
            decoration: const BoxDecoration(
              color: primaryAccentColor,
            ),
          ),
          AddCategory(categoryBloc: categoryBloc),
          getCategoriesWidget(),
          const Divider(
            color: Colors.black,
            height: 20,
            thickness: 1,
            indent: 5,
            endIndent: 5,
          ),
          const Settings(),
          const About(),
        ],
      ),
    );
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
      return snapshot.data?.isEmpty == true
          ? const SizedBox(
              height: 100,
              child: NoData(text: 'Start adding Category...'),
            )
          : ListView.builder(
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
                      MaterialPageRoute(
                          builder: (context) => TodoList(
                                categoryBloc,
                                currentCategory: category,
                              ));
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
                          builder: (context) => TodoList(
                                categoryBloc,
                                currentCategory: category,
                              ))),
                );

                return listTitle;
              });
    } else {
      return Center(
        child: loadingData(),
      );
    }
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
}
