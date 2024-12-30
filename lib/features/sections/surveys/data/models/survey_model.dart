import 'package:equatable/equatable.dart';

class SurveyModel extends Equatable {
  final int? id;
  final String? name;
  final String? unitName;
  final String? courseTitle;
  final int? order;
  final int? unitId;

  const SurveyModel(
      {this.id,
        this.name,
        this.unitName,
        this.courseTitle,
        this.order,
        this.unitId});

  factory SurveyModel.fromJson({required Map<String, dynamic> json}) => SurveyModel(
    id: json['id'],
    name: json['name'],
    unitName: json['unitName'],
    courseTitle: json['courseTitle'],
    order: json['order'],
    unitId: json['unitId'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id ?? 123;
    data['name'] = name;
    data['unitName'] = unitName;
    data['courseTitle'] = courseTitle;
    data['order'] = order;
    data['unitId'] = unitId;
    return data;
  }

  @override
  List<Object?> get props => [id, name, unitName, courseTitle, order, unitId];
}
