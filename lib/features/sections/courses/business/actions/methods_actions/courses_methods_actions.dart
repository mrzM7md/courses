import 'package:course_dashboard/features/sections/courses/business/actions/methods_actions/base_courses_methods_actions.dart';

class CoursesMethodsActions implements BaseCoursesMethodsActions {
  int? _courseCategorySelectedId;
  @override
  set courseCategorySelectedId(int? value) => _courseCategorySelectedId = value;
  @override
  int? get courseCategorySelectedId => _courseCategorySelectedId;


  bool _isCourseHasCertificate = false;
  @override
  set isCourseHasCertificate(bool value) => _isCourseHasCertificate = value;
  @override
  bool get isCourseHasCertificate => _isCourseHasCertificate;


  bool _isCourseAllowDownload = false;
  @override
  set isCourseAllowDownload(bool value) => _isCourseAllowDownload = value;
  @override
  bool get isCourseAllowDownload => _isCourseAllowDownload;


  bool _isCourseLock = false;
  @override
  set isCourseLock(bool value) => _isCourseLock = value;
  @override
  bool get isCourseLock => _isCourseLock;



}