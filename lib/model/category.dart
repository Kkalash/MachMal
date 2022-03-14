class Category {
  int? id;
  String? description;

  Category({
    this.id,
    this.description,
  });

  factory Category.fromDataJson(Map<String, dynamic> data) =>
      Category(id: data['id'], description: data['description']);

  Map<String, dynamic> toDatabaseJson() =>
      {'id': id, 'description': description};
}
