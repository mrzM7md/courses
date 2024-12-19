import 'package:course_dashboard/core/data/models/pagination_model.dart';
import 'package:course_dashboard/core/data/models/success_model.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../../core/data/models/error_model.dart';
import '../../../../../../core/values/pagination.dart';
import '../../../data/models/category_model.dart';

abstract class BaseCategoriesEndpointsActions {
  Future<Either<ErrorModel, SuccessModel<CategoryModel>>> addEditCategoryAsync({required CategoryModel category});
  Future<Either<ErrorModel, SuccessModel<PaginationModel<CategoryModel>>>> getCategoriesAsync({String? keywordSearch, int pageNumber = pageNumber, int pageSize = pageSize});
  Future<Either<ErrorModel, SuccessModel<String?>>> deleteCategoryAsync({required String categoryId});
}