class AddEditCourseModel {
  int? id;
  String title;
  String description;
  bool hasCertificate;
  String question;
  String answer;
  int categoryId;
  bool allowDownload;
  String goals;
  bool isLocked;

  AddEditCourseModel({
    this.id,
    required this.title,
    required this.description,
    required this.hasCertificate,
    required this.question,
    required this.answer,
    required this.categoryId,
    required this.allowDownload,
    required this.goals,
    required this.isLocked,
  });

  Map<String, dynamic> toJson() {
    return {
      'Id': id ?? 213,
      'Title': title.trim(),
      'Description': description,
      'HasCertificate': hasCertificate,
      'Question': question.trim(),
      'Answer': answer.trim(),
      'CategoryId': categoryId,
      'AllowDownload': allowDownload,
      'Goals': goals.trim(),
      'IsLocked': isLocked,
    };
  }
}
