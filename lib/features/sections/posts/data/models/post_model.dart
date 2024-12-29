import 'package:course_dashboard/core/network/server/api_constance.dart';
import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
  final int? id;
  final String? title;
  final String? imageUrl;
  final String? createdAt;
  final String? description;
  final int? categoryId;
  final String? categoryName;

  const PostModel(
      { required this.id,
        required this.title,
        required this.imageUrl,
        required this.createdAt,
        required this.description,
        required this.categoryId,
        required this.categoryName,});


  factory PostModel.fromJson({required Map<String, dynamic> json}) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      imageUrl: ApiConstance.getImageLink(imageUri: json['imageUrl']!),
      createdAt: json['createdAt'],
      description: json['description'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['imageUrl'] = imageUrl;
    data['createdAt'] = createdAt;
    data['description'] = description;
    data['categoryId'] = categoryId;
    data['categoryName'] = categoryName;
    return data;
  }

  @override
  List<Object?> get props => [id, title, imageUrl, createdAt, description, categoryId, categoryName];
}
