import 'package:course_dashboard/features/sections/courses/data/models/goal_model.dart';
import 'package:course_dashboard/features/sections/courses/data/models/lesson_model.dart';
import 'package:course_dashboard/features/sections/courses/data/models/unit_model.dart';
import 'package:equatable/equatable.dart';

class CourseModel extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final String? imageUrl;
  final bool? hasCertificate;
  final String? question;
  final String? answer;
  final int? categoryId;
  final bool? allowDownload;
  final bool? isLocked;
  final String? createdAt;
  final String? categoryName;
  final List<GoalModel>? goals;
  final List<UnitModel>? units;
  final List<LessonsModel>? lessons;

  const CourseModel(
      { required this.id,
        required this.title,
        required this.description,
        required this.imageUrl,
        required this.hasCertificate,
        required this.question,
        required this.answer,
        required this.categoryId,
        required this.allowDownload,
        required this.isLocked,
        required this.createdAt,
        required this.categoryName,
        required this.goals,
        required this.units,
        required this.lessons,
      });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        hasCertificate: json['hasCertificate'],
        question: json['question'],
        answer: json['answer'],
        categoryId: json['categoryId'],
        allowDownload: json['allowDownload'],
        isLocked: json['isLocked'],
        createdAt: json['createdAt'],
        categoryName: json['categoryName'],
        goals: json['goals'] != null ? List<GoalModel>.from(json['goals'].map((x) => GoalModel.fromJson(x))) : null,
        units: json['units'] != null ? List<UnitModel>.from(json['units'].map((x) => UnitModel.fromJson(json: x))) : null,
        lessons: json['lessons'] != null ? List<LessonsModel>.from(json['lessons'].map((x) => LessonsModel.fromJson(json: x))) : null);
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['imageUrl'] = imageUrl;
    data['hasCertificate'] = hasCertificate;
    data['question'] = question;
    data['answer'] = answer;
    data['categoryId'] = categoryId;
    data['allowDownload'] = allowDownload;
    data['isLocked'] = isLocked;
    data['createdAt'] = createdAt;
    data['categoryName'] = categoryName;
    if (goals != null) {
      data['goals'] = goals!.map((v) => v.toJson()).toList();
    }
    if (units != null) {
      data['units'] = units!.map((v) => v.toJson()).toList();
    }
    if (lessons != null) {
      data['lessons'] = lessons!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imageUrl,
    hasCertificate,
    question,
    answer,
    categoryId,
    allowDownload,
    isLocked,
    createdAt,
    categoryName,
    goals,
    units,
    lessons,
  ];
}