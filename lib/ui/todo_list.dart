import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_to_do_app/ui/sidenav.dart';
import 'package:flutter_to_do_app/models/todo.dart';
import 'package:flutter_to_do_app/utils/utils.dart';
import 'package:flutter_to_do_app/bloc/todo_bloc.dart';
import 'package:flutter_to_do_app/models/category.dart';
import 'package:flutter_to_do_app/widgets/no_data.dart';
import 'package:flutter_to_do_app/widgets/todo-list/add_todo.dart';
import 'package:flutter_to_do_app/bloc/category_bloc.dart';
import 'package:flutter_to_do_app/widgets/todo-list/search_todo.dart';
import 'package:flutter_to_do_app/widgets/todo-list/delete_filter.dart';

class TodoList extends StatelessWidget {
  final CategoryBloc categoryBloc;
  final TodoBloc todoBloc = TodoBloc();
  final Category currentCategory;

  //Allows Todo card to be dismissable horizontally
  final DismissDirection _dismissDirection = DismissDirection.horizontal;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  TodoList(this.categoryBloc, {Key? key, required this.currentCategory})
      : super(key: key);

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
        drawer: Sidenav(categoryBloc),
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
                    currentCategory.description,
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
                      todoBloc: todoBloc, categoryId: currentCategory.id!),
                  SearchTodo(
                      todoBloc: todoBloc, categoryId: currentCategory.id!),
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
            todoBloc: todoBloc,
            categoryId: currentCategory.id!,
          ),
        ));
  }

  Widget getTodosWidget() {
    /*The StreamBuilder widget,
    basically this widget will take stream of data (todos)
    and construct the UI (with state) based on the stream
    */
    return StreamBuilder(
      stream: todoBloc.todos,
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
        return getTodoCardWidget(snapshot);
      },
    );
  }

  Widget getTodoCardWidget(AsyncSnapshot<List<Todo>> snapshot) {
    /*Since most of our operations are asynchronous
    at initial state of the operation there will be no stream
    so we need to handle it if this was the case
    by showing users a processing/loading indicator*/
    if (snapshot.hasData) {
      /*Also handles whenever there's stream
      but returned returned 0 records of Todo from DB.
      If that the case show user that you have empty Todos
      */
      return snapshot.data?.isEmpty == true
          ? const NoData(text: 'Start adding Todo...')
          : ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, itemPosition) {
                Todo todo = snapshot.data![itemPosition];
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
                    /*The magic
                    delete Todo item by ID whenever
                    the card is dismissed
                    */
                    todoBloc.deleteTodoById(todo.id!);
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
                            //Reverse the value
                            todo.isDone = !todo.isDone;
                            /*
                            Another magic.
                            This will update Todo isDone with either
                            completed or not
                          */
                            todoBloc.updateTodo(todo);
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
      return Center(
        /*since most of our I/O operations are done
        outside the main thread asynchronously
        we may want to display a loading indicator
        to let the use know the app is currently
        processing*/
        child: loadingData(),
      );
    }
  }

  Widget loadingData() {
    //pull todos again
    todoBloc.getTodosByCategoryId(categoryId: currentCategory.id!);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          CircularProgressIndicator(),
          Text('Loading...',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
        ],
      ),
    );
  }

  dispose() {
    /*close the stream in order
    to avoid memory leaks
    */
    todoBloc.dispose();
    categoryBloc.dispose();
  }
}
