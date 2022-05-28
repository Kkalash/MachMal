import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_to_do_app/models/todo.dart';
import 'package:flutter_to_do_app/ui/sidenav.dart';
import 'package:flutter_to_do_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_to_do_app/models/category.dart';
import 'package:flutter_to_do_app/widgets/no_data.dart';
import 'package:flutter_to_do_app/widgets/add_todo.dart';
import 'package:flutter_to_do_app/widgets/search_todo.dart';
import 'package:flutter_to_do_app/widgets/loading_data.dart';
import 'package:flutter_to_do_app/widgets/delete_filter.dart';
import 'package:flutter_to_do_app/repository/todo_firestore_repo.dart';

class TodoList extends StatelessWidget {
  final Category currentCategory;
  final TodoFireStoreRepo repository = TodoFireStoreRepo();

  final DismissDirection _dismissDirection = DismissDirection.horizontal;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  TodoList({Key? key, required this.currentCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: tertiaryColor, //ganz oben der
        systemNavigationBarColor: tertiaryColor,
        //Android Bar mit zurueck/home screen etc.
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark));
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        body: SafeArea(
            child: Container(
                color: tertiaryColor,
                padding:
                    const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
                child: Container(
                    //This is where the magic starts
                    child: getTodosWidget()))),
        drawer: Sidenav(),
        bottomNavigationBar: BottomAppBar(
          color: tertiaryColor,
          child: Container(
            decoration: const BoxDecoration(
                border: Border(
              top: BorderSide(color: shadeColor, width: 0.3),
              bottom: BorderSide(color: shadeColor, width: 0.3),
            )),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(
                    icon: const Icon(
                      // Burgermenue Button
                      Icons.menu,
                      color: primaryColor,
                      size: 28,
                    ),
                    onPressed: () {
                      //just re-pull UI for testing purposes
                      _scaffoldKey.currentState?.openDrawer();
                    }),
                Expanded(
                  //Text neben Burgermenu
                  child: Text(
                    currentCategory.title,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'RobotoMono',
                        fontStyle: FontStyle.normal,
                        fontSize: 19),
                  ),
                ),
                Wrap(children: <Widget>[
                  DeleteFilter(
                      categoryId: currentCategory.categoryId!,
                      repository: repository),
                  SearchTodo(
                    categoryId: currentCategory.categoryId!,
                    repository: repository,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 5),
                  ),
                ])
              ],
            ),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked, //AddButton
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: AddTodo(
            repository: repository,
            categoryId: currentCategory.categoryId!,
          ),
        ));
  }

  Widget getTodosWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: repository.getStream(currentCategory.categoryId!),
      builder: (context, snapshot) {
        return getTodoCardWidget(snapshot);
      },
    );
  }

  Widget getTodoCardWidget(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data?.docs.isEmpty == true
          ? const NoData(text: 'Start adding Todo...')
          : ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                Todo todo = Todo.fromSnapshot(snapshot.data!.docs[index]);
                final Widget dismissibleCard = Dismissible(
                  background: Container(
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Deleting',
                          style: TextStyle(color: tertiaryColor),
                        ),
                      ),
                    ),
                    color: primaryAccentColor,
                  ),
                  onDismissed: (direction) {
                    repository.deleteTodo(
                        currentCategory.categoryId!, todo.todoId!);
                  },
                  direction: _dismissDirection,
                  key: UniqueKey(),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: (shadeColor), width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: tertiaryColor,
                      child: ListTile(
                        leading: InkWell(
                          onTap: () {
                            todo.isDone = !todo.isDone;

                            repository.updateTodo(
                                currentCategory.categoryId!, todo);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: todo.isDone
                                ? const Icon(
                                    Icons.done,
                                    size: 26.0,
                                    color: secondaryColor,
                                  )
                                : const Icon(
                                    Icons.check_box_outline_blank,
                                    size: 26.0,
                                    color: secondaryColor,
                                  ),
                          ),
                        ),
                        title: Text(
                          todo.description,
                          style: TextStyle(
                              fontSize: 16.5,
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.w500,
                              decoration: todo.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ),
                      )),
                );
                return dismissibleCard;
              },
            );
    } else {
      return const Center(
        child: LoadingData(),
      );
    }
  }
}
