import 'package:bloc/bloc.dart';
import 'package:course_dashboard/core/data/models/success_model.dart';
import 'package:course_dashboard/features/sections/courses/data/models/course_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';

import '../../../../../core/data/models/error_model.dart';
import '../../../../../core/data/models/pagination_model.dart';
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
      print("Fail Data: ${l.message}");
    }, (r){
      print("Success Data: ${r.data.data}");
      emit(GetCoursesState(isLoaded: true, isSuccess: true, message: r.message, coursesPaginated: r.data, statusCode: r.statusCode));
    });
  }
}
