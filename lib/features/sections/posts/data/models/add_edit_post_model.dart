class AddEditPostModel{
  final int? id;
  final String? title;
  final String? description;
  final int? categoryId;

  const AddEditPostModel(
      { required this.id,
        required this.title,
        required this.description,
        required this.categoryId,
      });


  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 123,
      'title': title,
      'description': description,
      'categoryId': categoryId,
    };
  }

}
