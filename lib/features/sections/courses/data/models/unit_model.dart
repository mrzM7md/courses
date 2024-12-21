import 'package:equatable/equatable.dart';

class UnitModel extends Equatable {
  final int? id;
  final String? name;
  final int? order;
  final bool? isLocked;
  final int? courseId;

  const UnitModel({
    required this.id,
    required this.name,
    required this.order,
    required this.isLocked,
    required this.courseId
  });

  factory UnitModel.fromJson({required Map<String, dynamic> json}) => UnitModel(
        id: json['id'],
        name: json['name'],
        order: json['order'],
        isLocked: json['isLocked'],
        courseId: json['courseId'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['order'] = order;
    data['isLocked'] = isLocked;
    data['courseId'] = courseId;
    return data;
  }

  @override
  List<Object?> get props => [id, name, order, isLocked, courseId];
}
