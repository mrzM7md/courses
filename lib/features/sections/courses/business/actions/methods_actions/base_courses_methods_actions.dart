import 'package:course_dashboard/features/sections/courses/data/models/course_model.dart';
import 'package:course_dashboard/features/sections/courses/data/models/lesson_model.dart';

import '../../../data/models/unit_model.dart';

abstract class BaseCoursesMethodsActions {
  set courseCategorySelectedId(int? value);
  int? get courseCategorySelectedId;

  set isCourseHasCertificate(bool value);
  bool get isCourseHasCertificate;

  set isCourseAllowDownload(bool value);
  bool get isCourseAllowDownload;

  set isCourseLock(bool value);
  bool get isCourseLock;

  set isUnitLock(bool value);
  bool get isUnitLock;

  set isLessonLock(bool value);
  bool get isLessonLock;

  CourseModel concatCourseWithNewUnit(CourseModel course, UnitModel unit);
  CourseModel concatCourseWithUpdatedUnit(CourseModel course, UnitModel unit);
  CourseModel deleteUnitFromCourse(CourseModel course, UnitModel unit);

  set lessonUnitSelectedId(int? value);
  int? get lessonUnitSelectedId;

  CourseModel concatCourseWithNewLesson(CourseModel course, LessonModel lesson);
  CourseModel concatCourseWithUpdatedLesson(CourseModel course, LessonModel lesson);
  CourseModel deleteLessonFromCourse(CourseModel course, LessonModel lesson);

}