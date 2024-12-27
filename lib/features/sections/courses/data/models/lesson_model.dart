import 'package:equatable/equatable.dart';

class LessonModel extends Equatable {
  final int? id;
  final String? name;
  final int? unitId;
  final String? unitName;
  final String? videoUrl;
  final String? script;
  final int? order;
  final bool? isLocked;

  const LessonModel(
      { required this.id,
        required this.name,
        required this.unitId,
        required this.unitName,
        required this.order,
        required this.isLocked,
        required this.videoUrl,
        required this.script,
      });
  
  // fromJson with required constructor
  factory LessonModel.fromJson({required Map<String, dynamic> json}) => LessonModel(
      id: json['id'],
      name: json['name'],
      unitId: json['unitId'],
      unitName: json['unitName'],
      order: json['order'],
      isLocked: json['isLocked'],
      videoUrl: json['videoUrl'],
        script: json['script'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id ?? 122;
    data['name'] = name;
    data['unitId'] = unitId;
    data['unitName'] = unitName;
    data['order'] = order;
    data['isLocked'] = isLocked;
    data['videoUrl'] = videoUrl;
    data['script'] = script;
    return data;
  }

  @override
  List<Object?> get props => [id, name, unitId, unitName, order, isLocked, videoUrl, script];
}