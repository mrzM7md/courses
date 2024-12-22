import 'package:course_dashboard/features/sections/courses/data/models/course_model.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../../core/data/models/error_model.dart';
import '../../../../../../core/data/models/pagination_model.dart';
import '../../../../../../core/data/models/success_model.dart';
import '../../../../../../core/values/pagination.dart';

abstract class BaseCoursesEndpointsActions {
  Future<Either<ErrorModel, SuccessModel<PaginationModel<CourseModel>>>> getCoursesAsync({required String keywordSearch, int pageNumber = pageNumber, int pageSize = pageSize});
}