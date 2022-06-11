import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_to_do_app/ui/sidenav.dart';
import 'package:flutter_to_do_app/widgets/no_data.dart';
import 'package:flutter_to_do_app/shared/models/todo.dart';
import 'package:flutter_to_do_app/shared/utils/utils.dart';
import 'package:flutter_to_do_app/widgets/loading_data.dart';
import 'package:flutter_to_do_app/shared/models/category.dart';
import 'package:flutter_to_do_app/widgets/todo-list/add_todo.dart';
import 'package:flutter_to_do_app/repository/todo_repository.dart';
import 'package:flutter_to_do_app/widgets/todo-list/search_todo.dart';
import 'package:flutter_to_do_app/widgets/todo-list/delete_filter.dart';

class TodoListPage extends StatelessWidget {
  final Category category;
  final TodoRepository todoRepository = TodoRepository();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  static String? currentCategoryId;

  TodoListPage({Key? key, required this.category}) : super(key: key) {
    currentCategoryId = category.id;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: tertiaryColor,
        systemNavigationBarColor: tertiaryColor,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark));

    const borderSide = BorderSide(color: shadeColor, width: 0.3);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        body: SafeArea(
            child: Container(
                color: tertiaryColor,
                padding:
                    const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
                child: Container(child: getTodosWidget()))),
        drawer: const Sidenav(),
        bottomNavigationBar: BottomAppBar(
          color: tertiaryColor,
          child: Container(
            decoration: const BoxDecoration(
                border: Border(
              top: borderSide,
              bottom: borderSide,
            )),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: primaryColor,
                      size: 28,
                    ),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer()),
                Expanded(
                  child: Text(
                    category.title,
                    style: const TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.w600,
                        fontFamily: fontFamilyRaleway,
                        fontStyle: FontStyle.italic,
                        fontSize: 19),
                  ),
                ),
                Wrap(children: <Widget>[
                  DeleteFilter(
                      categoryId: category.id!, repository: todoRepository),
                  SearchTodo(
                    categoryId: category.id!,
                    repository: todoRepository,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 5),
                  ),
                ])
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: AddTodo(
            repository: todoRepository,
            categoryId: category.id!,
          ),
        ));
  }

  Widget getTodosWidget() {
    return StreamBuilder(
      stream: todoRepository.todos,
      builder: (context, AsyncSnapshot<List<Todo>> snapshot) {
        return getTodoCardWidget(snapshot);
      },
    );
  }

  Widget getTodoCardWidget(AsyncSnapshot<List<Todo>> snapshot) {
    if (snapshot.hasData) {
      if (snapshot.data?.isEmpty == true) {
        return const NoData(text: 'Start adding Todo...');
      } else {
        return ListView.builder(
          itemCount: snapshot.data?.length,
          itemBuilder: (context, index) {
            Todo todo = snapshot.data![index];
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
              onDismissed: (direction) =>
                  todoRepository.deleteTodo(category.id!, todo.id!),
              direction: DismissDirection.horizontal,
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

                        todoRepository.updateTodo(category.id!, todo);
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
                          fontFamily: fontFamilyRaleway,
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
      }
    } else {
      todoRepository.getTodosByCategoryId(category.id!);

      return const Center(
        child: LoadingData(),
      );
    }
  }
}
