class AddCourseModel {
  int? id;
  String title;
  String description;
  String? imageFile;
  bool hasCertificate;
  String question;
  String answer;
  int categoryId;
  bool allowDownload;
  String? goals;
  bool? isLocked;

  AddCourseModel({
    this.id,
    required this.title,
    required this.description,
    this.imageFile,
    required this.hasCertificate,
    required this.question,
    required this.answer,
    required this.categoryId,
    required this.allowDownload,
    this.goals,
    this.isLocked,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageFile': imageFile,
      'hasCertificate': hasCertificate,
      'question': question,
      'answer': answer,
      'categoryId': categoryId,
      'allowDownload': allowDownload,
      'goals': goals,
      'isLocked': isLocked,
    };
  }
}
