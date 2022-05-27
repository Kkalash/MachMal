import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_to_do_app/utils/utils.dart';
import 'package:flutter_to_do_app/ui/todo_list.dart';
import 'package:flutter_to_do_app/widgets/toast.dart';
import 'package:flutter_to_do_app/models/category.dart';
import 'package:flutter_to_do_app/widgets/no_data.dart';
import 'package:flutter_to_do_app/bloc/category_bloc.dart';
import 'package:flutter_to_do_app/widgets/sidenav/about.dart';
import 'package:flutter_to_do_app/widgets/sidenav/login.dart';
import 'package:flutter_to_do_app/enums/toast_type.enum.dart';
import 'package:flutter_to_do_app/widgets/sidenav/settings.dart';
import 'package:flutter_to_do_app/widgets/sidenav/sign_out.dart';
import 'package:flutter_to_do_app/widgets/sidenav/add_category.dart';

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
          loginOrSignOut()
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
                      showAlertDialog(context, category);
                      // ignore: todo
                      // TODO: Navigate to the next category after if current category is deleted.
                    },
                    child: const Icon(Icons.delete, color: primaryColor),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                      primary: tertiaryColor, // <-- Button color
                    ),
                  ),
                  onTap: () => Navigator.pushReplacement(
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

  Widget loginOrSignOut() {
    return FirebaseAuth.instance.currentUser == null ||
            FirebaseAuth.instance.currentUser?.isAnonymous == true
        ? const Login()
        : const SignOut();
  }

  showAlertDialog(BuildContext context, Category category) {
    Widget cancelButton = TextButton(
      child: const Text('Cancel'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text('Delete'),
      onPressed: () {
        categoryBloc.deleteCategoryById(category.id!);
        Navigator.of(context).pop();
        Toast(
            context: context,
            message: 'Category deleted successfuly',
            type: ToastType.success);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          const Text('Delete '),
          Text(StringUtils.capitalize(category.description),
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: primaryColor)),
        ],
      ),
      content: const Text('Would you like to delete this category?'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
