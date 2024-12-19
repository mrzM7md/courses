import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable{
  final int? id;
  final String name;
  const CategoryModel({required this.name, required this.id});

  factory CategoryModel.fromJson({required  Map<String, dynamic> json}) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [id, name];
}