import 'package:equatable/equatable.dart';

class GoalModel extends Equatable {
  final int? id;
  final String? name;

  const GoalModel({required this.id, required this.name});

  factory GoalModel.fromJson(Map<String, dynamic> json) => GoalModel(
      id: json['id'] as int?,
      name: json['name'] as String?);


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  @override
  List<Object?> get props => [id, name];
}