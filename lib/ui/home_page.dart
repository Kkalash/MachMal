import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_to_do_app/bloc/todo_bloc.dart';
import 'package:flutter_to_do_app/model/todo.dart';
import 'package:flutter_to_do_app/utils/utils.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  //We load our Todo BLoC that is used to get
  //the stream of Todo for StreamBuilder
  final TodoBloc todoBloc = TodoBloc();
  final String title;

  //Allows Todo card to be dismissable horizontally
  final DismissDirection _dismissDirection = DismissDirection.horizontal;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: TERTIARY_COLOR, //ganz oben der
        systemNavigationBarColor: TERTIARY_COLOR,
        //Android Bar mit zurueck/home screen etc.
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark));
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
                color: TERTIARY_COLOR,
                padding:
                    const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
                child: Container(
                    //This is where the magic starts
                    child: getTodosWidget()))),
        bottomNavigationBar: BottomAppBar(
          color: TERTIARY_COLOR,
          child: Container(
            decoration: const BoxDecoration(
                border: Border(
              top: BorderSide(color: SHADE_COLOR, width: 0.3),
              bottom: BorderSide(color: SHADE_COLOR, width: 0.3),
            )),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(
                    icon: const Icon(
                      // Burgermenue Button
                      Icons.menu,
                      color: PRIMARY_COLOR,
                      size: 28,
                    ),
                    onPressed: () {
                      //just re-pull UI for testing purposes
                      todoBloc.getTodos();
                    }),
                const Expanded(
                  //Text neben Burgermenu
                  child: Text(
                    "Todo",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'RobotoMono',
                        fontStyle: FontStyle.normal,
                        fontSize: 19),
                  ),
                ),
                Wrap(children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      size: 28,
                      color: PRIMARY_COLOR,
                    ),
                    onPressed: () {
                      _showTodoSearchSheet(context);
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 5),
                  )
                ])
              ],
            ),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked, //AddButton
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: FloatingActionButton(
            elevation: 5.0,
            onPressed: () {
              _showAddTodoSheet(context);
            },
            backgroundColor: PRIMARY_COLOR,
            child: const Icon(
              Icons.add,
              size: 32,
              color: TERTIARY_COLOR,
            ),
          ),
        ));
  }

//Add ToDO Fenster
  void _showAddTodoSheet(BuildContext context) {
    final _todoDescriptionFormController = TextEditingController();
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
                    color: TERTIARY_COLOR,
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
                              controller: _todoDescriptionFormController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: const TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                  hintText: 'I have to...',
                                  labelText: 'New Todo',
                                  labelStyle: TextStyle(
                                      color: PRIMARY_COLOR,
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
                              backgroundColor: PRIMARY_COLOR,
                              radius: 18,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.save,
                                  size: 22,
                                  color: TERTIARY_COLOR,
                                ),
                                onPressed: () {
                                  final newTodo = Todo(
                                      description:
                                          _todoDescriptionFormController
                                              .value.text);
                                  if (newTodo.description!.isNotEmpty) {
                                    /*Create new Todo object and make sure
                                    the Todo description is not empty,
                                    because what's the point of saving empty
                                    Todo
                                    */
                                    todoBloc.addTodo(newTodo);

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

  void _showTodoSearchSheet(BuildContext context) {
    final _todoSearchDescriptionFormController = TextEditingController();
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
                    color: TERTIARY_COLOR,
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
                              controller: _todoSearchDescriptionFormController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: 'Search for todo...',
                                labelText: 'Search *',
                                labelStyle: TextStyle(
                                    color: PRIMARY_COLOR,
                                    fontWeight: FontWeight.w500),
                              ),
                              validator: (String? value) {
                                if (value!.isNotEmpty) {
                                  return value.contains('@')
                                      ? 'Do not use the @ char.'
                                      : null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: PRIMARY_COLOR,
                              radius: 18,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  size: 22,
                                  color: TERTIARY_COLOR,
                                ),
                                onPressed: () {
                                  /*This will get all todos
                                  that contains similar string
                                  in the textform
                                  */
                                  todoBloc.getTodos(
                                      query:
                                          _todoSearchDescriptionFormController
                                              .value.text);
                                  //dismisses the bottomsheet
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
      return snapshot.data?.length != null
          ? ListView.builder(
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
                          "Deleting",
                          style: TextStyle(color: TERTIARY_COLOR),
                        ),
                      ),
                    ),
                    color: PRIMARY_ACCENT_COLOR,
                  ),
                  onDismissed: (direction) {
                    /*The magic
                    delete Todo item by ID whenever
                    the card is dismissed
                    */
                    todoBloc.deleteTodoById(todo.id!);
                  },
                  direction: _dismissDirection,
                  key: ObjectKey(todo),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        side:
                            //BorderSide(color: (Colors.grey[200])!, width: 0.5),
                            const BorderSide(color: (SHADE_COLOR), width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: TERTIARY_COLOR,
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
                                    color: SECONDARY_COLOR,
                                  )
                                : const Icon(
                                    Icons.check_box_outline_blank,
                                    size: 26.0,
                                    color: SECONDARY_COLOR,
                                  ),
                          ),
                        ),
                        title: Text(
                          todo.description!,
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
            )
          : Center(
              //this is used whenever there 0 Todo
              //in the data base
              child: noTodoMessageWidget(),
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
    todoBloc.getTodos();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          CircularProgressIndicator(),
          Text("Loading...",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
        ],
      ),
    );
  }

  Widget noTodoMessageWidget() {
    return const Text(
      "Start adding Todo...",
      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
    );
  }

  dispose() {
    /*close the stream in order
    to avoid memory leaks
    */
    todoBloc.dispose();
  }
}
