class Todo {
  int? id;
  int categoryId;
  String description;
  bool isDone = false;

  //When using curly braces { } we note dart that
  //the parameters are optional
  Todo(
      {this.id,
      required this.categoryId,
      required this.description,
      this.isDone = false});

  factory Todo.fromDatabaseJson(Map<String, dynamic> data) => Todo(
      //This will be used to convert JSON objects that
      //are coming from querying the database and converting
      //it into a Todo object
      id: data['id'],
      //Since sqlite doesn't have boolean type for true/false
      //we will 0 to denote that it is false
      //and 1 for true
      categoryId: data['category_id'],
      description: data['description'],
      isDone: data['is_done'] == 0 ? false : true);

  Map<String, dynamic> toDatabaseJson() => {
        //This will be used to convert Todo objects that
        //are to be stored into the datbase in a form of JSON
        'id': id,
        'category_id': categoryId,
        'description': description,
        'is_done': isDone == false ? 0 : 1
      };
}
