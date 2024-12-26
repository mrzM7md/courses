import 'package:course_dashboard/features/sections/courses/business/actions/methods_actions/base_courses_methods_actions.dart';
import 'package:course_dashboard/features/sections/courses/data/models/course_model.dart';
import 'package:course_dashboard/features/sections/courses/data/models/lesson_model.dart';
import 'package:course_dashboard/features/sections/courses/data/models/unit_model.dart';

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

  bool _isUnitLock = false;

  @override
  set isUnitLock(bool value) => _isUnitLock = value;

  @override
  bool get isUnitLock => _isUnitLock;

  bool _isLessonLock = false;

  @override
  set isLessonLock(bool value) => _isLessonLock = value;

  @override
  bool get isLessonLock => _isLessonLock;

  @override
  CourseModel concatCourseWithNewUnit(CourseModel course, UnitModel unit) {
    List<UnitModel> updatedUnits = course.units ?? [];
    updatedUnits.add(unit);

    CourseModel updatedCourse = CourseModel(
      id: course.id,
      title: course.title,
      description: course.description,
      units: updatedUnits,
      isLocked: course.isLocked,
      createdAt: course.createdAt,
      categoryName: course.categoryName,
      goals: course.goals,
      lessons: course.lessons,
      allowDownload: course.allowDownload,
      hasCertificate: course.hasCertificate,
      question: course.question,
      answer: course.answer,
      categoryId: course.categoryId,
      imageUrl: course.imageUrl,
    );

    return updatedCourse;
  }

  @override
  CourseModel concatCourseWithUpdatedUnit(CourseModel course, UnitModel unit) {
    List<UnitModel> updatedUnits = course.units ?? [];
    updatedUnits[updatedUnits.indexWhere((element) => element.id == unit.id)] = unit;

    CourseModel updatedCourse = CourseModel(
      id: course.id,
      title: course.title,
      description: course.description,
      units: updatedUnits,
      isLocked: course.isLocked,
      createdAt: course.createdAt,
      categoryName: course.categoryName,
      goals: course.goals,
      lessons: course.lessons,
      allowDownload: course.allowDownload,
      hasCertificate: course.hasCertificate,
      question: course.question,
      answer: course.answer,
      categoryId: course.categoryId,
      imageUrl: course.imageUrl,
    );

    return updatedCourse;
  }


  @override
  CourseModel concatCourseWithNewLesson(CourseModel course,
      LessonsModel lesson) {
    List<LessonsModel> updatedLessons = course.lessons ?? [];
    updatedLessons.add(lesson);

    CourseModel updatedCourse = CourseModel(
      id: course.id,
      title: course.title,
      description: course.description,
      units: course.units,
      isLocked: course.isLocked,
      createdAt: course.createdAt,
      categoryName: course.categoryName,
      goals: course.goals,
      lessons: updatedLessons,
      allowDownload: course.allowDownload,
      hasCertificate: course.hasCertificate,
      question: course.question,
      answer: course.answer,
      categoryId: course.categoryId,
      imageUrl: course.imageUrl,
    );

    return updatedCourse;
  }

  @override
  CourseModel deleteUnitFromCourse(CourseModel course, UnitModel unit) {
    List<UnitModel> updatedUnits = course.units?? [];
    updatedUnits.removeWhere((element) => element.id == unit.id);

    CourseModel updatedCourse = CourseModel(
      id: course.id,
      title: course.title,
      description: course.description,
      units: updatedUnits,
      isLocked: course.isLocked,
      createdAt: course.createdAt,
      categoryName: course.categoryName,
      goals: course.goals,
      lessons: course.lessons,
      allowDownload: course.allowDownload,
      hasCertificate: course.hasCertificate,
      question: course.question,
      answer: course.answer,
      categoryId: course.categoryId,
      imageUrl: course.imageUrl,
    );

    return updatedCourse;
  }
}