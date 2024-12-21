import 'package:equatable/equatable.dart';

class LessonsModel extends Equatable {
  final int? id;
  final String? name;
  final int? unitId;
  final String? unitName;
  final int? order;
  final bool? isLocked;

  const LessonsModel(
      { required this.id,
        required this.name,
        required this.unitId,
        required this.unitName,
        required this.order,
        required this.isLocked});
  
  // fromJson with required constructor
  factory LessonsModel.fromJson({required Map<String, dynamic> json}) => LessonsModel(
      id: json['id'],
      name: json['name'],
      unitId: json['unitId'],
      unitName: json['unitName'],
      order: json['order'],
      isLocked: json['isLocked']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['unitId'] = unitId;
    data['unitName'] = unitName;
    data['order'] = order;
    data['isLocked'] = isLocked;
    return data;
  }

  @override
  List<Object?> get props => [id, name, unitId, unitName, order, isLocked];
}