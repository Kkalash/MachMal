import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_to_do_app/ui/todo_list.dart';
import 'package:flutter_to_do_app/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_to_do_app/widgets/no_data.dart';
import 'package:flutter_to_do_app/shared/utils/utils.dart';
import 'package:flutter_to_do_app/widgets/loading_data.dart';
import 'package:flutter_to_do_app/widgets/sidenav/about.dart';
import 'package:flutter_to_do_app/widgets/sidenav/login.dart';
import 'package:flutter_to_do_app/shared/models/category.dart';
import 'package:flutter_to_do_app/widgets/sidenav/settings.dart' as settings;
import 'package:flutter_to_do_app/widgets/sidenav/sign_out.dart';
import 'package:flutter_to_do_app/widgets/sidenav/add_category.dart';
import 'package:flutter_to_do_app/shared/enums/toast_type.enum.dart';
import 'package:flutter_to_do_app/repository/category_repository.dart';

class Sidenav extends Drawer {
  final CategoryFirestoreRepo categoryRepository = CategoryFirestoreRepo();

  Sidenav({Key? key}) : super(key: key);

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
          AddCategory(
            categoryRepository: categoryRepository,
          ),
          // getCategoriesWidget(),
          getCategoriesWidget(),
          const Divider(
            color: Colors.black,
            height: 20,
            thickness: 1,
            indent: 5,
            endIndent: 5,
          ),
          const settings.Settings(),
          const About(),
          loginOrSignOut()
        ],
      ),
    );
  }

  Widget getCategoriesWidget() {
    return StreamBuilder<QuerySnapshot>(
        stream: categoryRepository.getStream(),
        builder: (context, snapshot) {
          return getCategoryCardWidget(snapshot);
        });
  }

  Widget getCategoryCardWidget(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data?.docs.isEmpty == true
          ? const SizedBox(
              height: 100,
              child: NoData(text: 'Start adding Category...'),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                Category category =
                    Category.fromSnapshot(snapshot.data!.docs[index]);
                final Widget listTitle = ListTile(
                  title: Text(
                    category.title,
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
                                currentCategory: category,
                              ))),
                );

                return listTitle;
              });
    } else {
      return const Center(
        child: LoadingData(),
      );
    }
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
        categoryRepository.deleteCategory(category.id!);
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
          Text(StringUtils.capitalize(category.title),
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
