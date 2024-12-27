import 'package:bloc/bloc.dart';
import 'package:course_dashboard/core/data/models/success_model.dart';
import 'package:course_dashboard/features/sections/courses/data/models/add_course_model.dart';
import 'package:course_dashboard/features/sections/courses/data/models/course_model.dart';
import 'package:course_dashboard/features/sections/courses/data/models/lesson_model.dart';
import 'package:course_dashboard/features/sections/courses/data/models/unit_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import 'dart:typed_data';

import '../../../../../core/data/models/error_model.dart';
import '../../../../../core/data/models/pagination_model.dart';
import '../../../../../core/enums/operations_enum.dart';
import '../../../../../core/values/pagination.dart';
import '../actions/endpoints_actions/base_courses_endpoints_actions.dart';

part 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  final BaseCoursesEndpointsActions baseCoursesEndpointsActions;
  CoursesCubit({required this.baseCoursesEndpointsActions}) : super(CoursesInitial());

  static CoursesCubit get(context) => BlocProvider.of(context);

  Future<void> getCourses({required String keywordSearch, pageNumber = pageNumber, int pageSize = pageSize}) async {
    emit(GetCoursesState(isLoaded: false, isSuccess: false, message: "", coursesPaginated: null, statusCode: 0));
    Either<ErrorModel, SuccessModel<PaginationModel<CourseModel>>> x = await baseCoursesEndpointsActions.getCoursesAsync(keywordSearch: keywordSearch, pageNumber: pageNumber, pageSize: pageSize);
    x.match((l){
      emit(GetCoursesState(isLoaded: true, isSuccess: false, message: l.message, coursesPaginated: null, statusCode: l.statusCode));
    }, (r){
      emit(GetCoursesState(isLoaded: true, isSuccess: true, message: r.message, coursesPaginated: r.data, statusCode: r.statusCode));
    });
  }

  Future<void> addCourse({required AddEditCourseModel addEditCourseModel, required Uint8List? fileBytes}) async {
    emit(AddEditDeleteCourseState(isLoaded: false, isSuccess: false, message: "", statusCode: 0,
      operation: OperationsEnum.ADD,
    ));
    Either<ErrorModel, SuccessModel> x = await baseCoursesEndpointsActions.addEditCourse(addEditCourseModel: addEditCourseModel, image: fileBytes);
    x.match((l){
      emit(AddEditDeleteCourseState(isLoaded: true, isSuccess: false, message: l.message, statusCode: l.statusCode,
        operation: OperationsEnum.ADD,
      ));
    }, (r){
      // print("TRUE RES: ${r.data}");
      emit(AddEditDeleteCourseState(isLoaded: true, isSuccess: true, message: r.message, statusCode: r.statusCode,
        operation: OperationsEnum.ADD,
      ));
      getCourses(keywordSearch: "");
    });
  }

  Future<void> updateCourse({required AddEditCourseModel addEditCourseModel, required Uint8List? fileBytes}) async {
    emit(AddEditDeleteCourseState(isLoaded: false, isSuccess: false, message: "", statusCode: 0,
      operation: OperationsEnum.EDIT,
    ));
    Either<ErrorModel, SuccessModel<String>> x = await baseCoursesEndpointsActions.addEditCourse(addEditCourseModel: addEditCourseModel, image: fileBytes);
    x.match((l){
      emit(AddEditDeleteCourseState(isLoaded: true, isSuccess: false, message: l.message, statusCode: l.statusCode,
        operation: OperationsEnum.EDIT,
        courseId: addEditCourseModel.id
      ));
    }, (r){
      emit(AddEditDeleteCourseState(isLoaded: true, isSuccess: true, message: r.message, statusCode: r.statusCode,
        operation: OperationsEnum.EDIT,
          courseId: addEditCourseModel.id,
      ));
      getCourses(keywordSearch: "");
    });
  }

  Future<void> deleteCourse({required int courseId}) async {
    emit(AddEditDeleteCourseState(isLoaded: false,
      isSuccess: false,
      message: "",
      statusCode: 0,
      courseId: courseId,
      operation: OperationsEnum.DELETE,
    ));
    Either<ErrorModel, SuccessModel<String?>> x = await baseCoursesEndpointsActions
        .deleteCourseAsync(courseId: courseId);
    x.match((l) {
      emit(AddEditDeleteCourseState(isLoaded: true,
        isSuccess: false,
        message: l.message,
        statusCode: l.statusCode,
        courseId: courseId,
        operation: OperationsEnum.DELETE,
      ));
    }, (r) {
      emit(AddEditDeleteCourseState(isLoaded: true,
        isSuccess: true,
        message: r.message,
        statusCode: r.statusCode,
        courseId: courseId,
        operation: OperationsEnum.DELETE,
      ));
      getCourses(keywordSearch: "");
    });
  }



  void changeCourseCategorySelected({required int categoryIdSelected}){
    baseCoursesEndpointsActions.baseCoursesMethodsActions.courseCategorySelectedId = categoryIdSelected;
    emit(ChangeCourseCategorySelectedState(selectedCategoryId: categoryIdSelected));
  }

  void changeCourseImageSelected(){
    emit(ChangeCourseImageSelectedState());
  }

  void changeCourseAllowDownload(){
    baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseAllowDownload = !baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseAllowDownload;
    emit(IsCourseAllowDownloadState());
  }

  void changeCourseAllowLock(){
    baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseLock = !baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseLock;
    emit(IsCourseLockState());
  }

  void changeCourseHasCertificate(){
    baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseHasCertificate = !baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseHasCertificate;
    emit(IsCourseHasCertificateState());
  }


  Future<void> addUnit({required UnitModel unitModel}) async {
    emit(AddEditDeleteUnitState(isLoaded: false, isSuccess: false, message: "", statusCode: 0,
      operation: OperationsEnum.ADD,
      unitModel: null
    ));
    Either<ErrorModel, SuccessModel<UnitModel>> x = await baseCoursesEndpointsActions.addEditUnit(unitModel: unitModel);
    x.match((l){
      emit(AddEditDeleteUnitState(isLoaded: true, isSuccess: false, message: l.message, statusCode: l.statusCode,
        operation: OperationsEnum.ADD,
          unitModel: null
      ));
    }, (r) async {
      await getCourses(keywordSearch: "");
      emit(AddEditDeleteUnitState(isLoaded: true, isSuccess: true, message: r.message, statusCode: r.statusCode,
        operation: OperationsEnum.ADD,
          unitModel: r.data
      ));
    });
  }

  Future<void> editUnit({required UnitModel unitModel}) async {
    emit(AddEditDeleteUnitState(isLoaded: false, isSuccess: false, message: "", statusCode: 0,
        operation: OperationsEnum.EDIT,
        unitModel: null
    ));
    Either<ErrorModel, SuccessModel<UnitModel>> x = await baseCoursesEndpointsActions.addEditUnit(unitModel: unitModel);
    x.match((l){
      emit(AddEditDeleteUnitState(isLoaded: true, isSuccess: false, message: l.message, statusCode: l.statusCode,
          operation: OperationsEnum.EDIT,
          unitModel: null
      ));
    }, (r) async {
      await getCourses(keywordSearch: "");
      emit(AddEditDeleteUnitState(isLoaded: true, isSuccess: true, message: r.message, statusCode: r.statusCode,
          operation: OperationsEnum.EDIT,
          unitModel: r.data
      ));
    });
  }

  Future<void> deleteUnit({required int unitId}) async {
    emit(AddEditDeleteUnitState(isLoaded: false, isSuccess: false, message: "", statusCode: 0,
        operation: OperationsEnum.DELETE,
        unitModel: null
    ));
    Either<ErrorModel, SuccessModel<String?>> result = await baseCoursesEndpointsActions.deleteUnit(unitId: unitId);
    result.match((l){
      emit(AddEditDeleteUnitState(isLoaded: true, isSuccess: false, message: l.message, statusCode: l.statusCode,
          operation: OperationsEnum.DELETE,
          unitModel: null
      ));
    }, (r) async {
      await getCourses(keywordSearch: "");
      emit(AddEditDeleteUnitState(isLoaded: true, isSuccess: true, message: r.message, statusCode: r.statusCode,
          operation: OperationsEnum.DELETE,
          unitModel: null
      ));
    });
  }

  void changeUnitAllowLock(){
    baseCoursesEndpointsActions.baseCoursesMethodsActions.isUnitLock = !baseCoursesEndpointsActions.baseCoursesMethodsActions.isUnitLock;
    emit(IsUnitLockState());
  }


  Future<void> addLesson({required LessonModel lesson}) async {
    emit(AddEditDeleteLessonState(isLoaded: false, isSuccess: false, message: "", statusCode: 0,
        operation: OperationsEnum.ADD,
        lessonModel: null
    ));
    Either<ErrorModel, SuccessModel<LessonModel>> x = await baseCoursesEndpointsActions.addEditLesson(lessonModel: lesson);
    x.match((l){
      emit(AddEditDeleteLessonState(isLoaded: true, isSuccess: false, message: l.message, statusCode: l.statusCode,
          operation: OperationsEnum.ADD,
          lessonModel: null
      ));
    }, (r) async {
      await getCourses(keywordSearch: "");
      emit(AddEditDeleteLessonState(isLoaded: true, isSuccess: true, message: r.message, statusCode: r.statusCode,
          operation: OperationsEnum.ADD,
          lessonModel: r.data
      ));
    });
  }

  Future<void> editLesson({required LessonModel lessonModel}) async {
    emit(AddEditDeleteLessonState(isLoaded: false, isSuccess: false, message: "", statusCode: 0,
        operation: OperationsEnum.EDIT,
        lessonModel: null
    ));
    Either<ErrorModel, SuccessModel<LessonModel>> x = await baseCoursesEndpointsActions.addEditLesson(lessonModel: lessonModel);
    x.match((l){
      emit(AddEditDeleteLessonState(isLoaded: true, isSuccess: false, message: l.message, statusCode: l.statusCode,
          operation: OperationsEnum.EDIT,
          lessonModel: null
      ));
    }, (r) async {
      await getCourses(keywordSearch: "");
      emit(AddEditDeleteLessonState(isLoaded: true, isSuccess: true, message: r.message, statusCode: r.statusCode,
          operation: OperationsEnum.EDIT,
          lessonModel: r.data
      ));
    });
  }

  Future<void> deleteLesson({required int lessonId}) async {
    emit(AddEditDeleteLessonState(isLoaded: false, isSuccess: false, message: "", statusCode: 0,
        operation: OperationsEnum.DELETE,
        lessonModel: null
    ));
    Either<ErrorModel, SuccessModel<String?>> result = await baseCoursesEndpointsActions.deleteLesson(lessonId: lessonId);
    result.match((l){
      emit(AddEditDeleteLessonState(isLoaded: true, isSuccess: false, message: l.message, statusCode: l.statusCode,
          operation: OperationsEnum.DELETE,
          lessonModel: null
      ));
    }, (r) async {
      await getCourses(keywordSearch: "");
      emit(AddEditDeleteLessonState(isLoaded: true, isSuccess: true, message: r.message, statusCode: r.statusCode,
          operation: OperationsEnum.DELETE,
          lessonModel: null
      ));
    });
  }

  void changeLessonAllowLock(){
    baseCoursesEndpointsActions.baseCoursesMethodsActions.isLessonLock = !baseCoursesEndpointsActions.baseCoursesMethodsActions.isLessonLock;
    emit(IsLessonLockState());
  }

  void changeLessonUnitSelected({required int unitIdSelected}){
    baseCoursesEndpointsActions.baseCoursesMethodsActions.lessonUnitSelectedId = unitIdSelected;
    emit(ChangeLessonUnitSelectedState(selectedUnitId: unitIdSelected));
  }
}