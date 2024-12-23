import 'package:course_dashboard/features/sections/courses/business/actions/methods_actions/base_courses_methods_actions.dart';
import 'package:course_dashboard/features/sections/courses/data/models/course_model.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../../core/data/models/error_model.dart';
import '../../../../../../core/data/models/pagination_model.dart';
import '../../../../../../core/data/models/success_model.dart';
import '../../../../../../core/values/pagination.dart';

abstract class BaseCoursesEndpointsActions {
  final BaseCoursesMethodsActions baseCoursesMethodsActions;
  BaseCoursesEndpointsActions({required this.baseCoursesMethodsActions});

  Future<Either<ErrorModel, SuccessModel<PaginationModel<CourseModel>>>> getCoursesAsync({required String keywordSearch, int pageNumber = pageNumber, int pageSize = pageSize});
}