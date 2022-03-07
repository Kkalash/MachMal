class Todo {
  int? id;
  String? description;
  bool isDone = false;

  //When using curly braces { } we note dart that
  //the parameters are optional
  Todo({this.id, this.description, this.isDone = false});
  factory Todo.fromDatabaseJson(Map<String, dynamic> data) => Todo(
        //This will be used to convert JSON objects that
        //are coming from querying the database and converting
        //it into a Todo object
        id: data['id'],
        description: data['description'],
        //Since sqlite doesn't have boolean type for true/false
        //we will 0 to denote that it is false
        //and 1 for true
        isDone: data['is_done'] == 0 ? false : true,
      );

  Map<String, dynamic> toDatabaseJson() => {
        //This will be used to convert Todo objects that
        //are to be stored into the datbase in a form of JSON
        "id": id,
        "description": description,
        "is_done": isDone == false ? 0 : 1,
      };
}
