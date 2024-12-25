import 'package:bloc/bloc.dart';
import 'package:course_dashboard/core/data/models/pagination_model.dart';
import 'package:course_dashboard/core/enums/operations_enum.dart';
import 'package:course_dashboard/core/values/pagination.dart';
import 'package:course_dashboard/features/sections/categories/business/actions/endpoints_actions/base_categories_endpoints_actions.dart';
import 'package:course_dashboard/features/sections/categories/data/models/category_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';

import '../../../../../core/data/models/error_model.dart';
import '../../../../../core/data/models/success_model.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState>{
  CategoriesCubit({required this.baseCategoriesEndpointsActions}) : super(CategoriesInitial());

  static CategoriesCubit get(context) => BlocProvider.of(context);
  final BaseCategoriesEndpointsActions baseCategoriesEndpointsActions;

  Future<void> getCategories({required String keywordSearch, pageNumber = pageNumber, int pageSize = pageSize}) async {
    emit(GetCategoriesState(isLoaded: false, isSuccess: false, message: "", categoriesPaginated: null, statusCode: 0));
    Either<ErrorModel, SuccessModel<PaginationModel<CategoryModel>>> x = await baseCategoriesEndpointsActions.getCategoriesAsync(keywordSearch: keywordSearch, pageNumber: pageNumber, pageSize: pageSize);
    x.match((l){
      emit(GetCategoriesState(isLoaded: true, isSuccess: false, message: l.message, categoriesPaginated: null, statusCode: l.statusCode));
    }, (r){
      emit(GetCategoriesState(isLoaded: true, isSuccess: true, message: r.message, categoriesPaginated: r.data, statusCode: r.statusCode));
    });
  }

  Future<void> addCategory({required CategoryModel categoryModel}) async {
    emit(AddEditDeleteCategoryState(isLoaded: false, isSuccess: false, message: "", statusCode: 0,
      operation: OperationsEnum.ADD,
    ));
    Either<ErrorModel, SuccessModel<CategoryModel>> x = await baseCategoriesEndpointsActions.addEditCategoryAsync(category: categoryModel);
    x.match((l){
      emit(AddEditDeleteCategoryState(isLoaded: true, isSuccess: false, message: l.message, statusCode: l.statusCode,
        operation: OperationsEnum.ADD,
      ));
    }, (r){
      emit(AddEditDeleteCategoryState(isLoaded: true, isSuccess: true, message: r.message, statusCode: r.statusCode,
        operation: OperationsEnum.ADD,
      ));
      getCategories(keywordSearch: "");
    });
  }

  Future<void> updateCategory({required CategoryModel categoryModel}) async {
    emit(AddEditDeleteCategoryState(isLoaded: false, isSuccess: false, message: "", statusCode: 0, categoryId: categoryModel.id,
      operation: OperationsEnum.EDIT,
    ));
    Either<ErrorModel, SuccessModel<CategoryModel>> x = await baseCategoriesEndpointsActions.addEditCategoryAsync(category: categoryModel);
    x.match((l){
      emit(AddEditDeleteCategoryState(isLoaded: true, isSuccess: false, message: l.message, statusCode: l.statusCode, categoryId: categoryModel.id,
        operation: OperationsEnum.EDIT,
              ));
    }, (r){
      emit(AddEditDeleteCategoryState(isLoaded: true, isSuccess: true, message: r.message, statusCode: r.statusCode, categoryId: categoryModel.id,
        operation: OperationsEnum.EDIT,
      ));
      getCategories(keywordSearch: "");
    });
  }

  // make deleteCategory method
  Future<void> deleteCategory({required int categoryId}) async {
    emit(AddEditDeleteCategoryState(isLoaded: false,
        isSuccess: false,
        message: "",
        statusCode: 0,
        categoryId: categoryId,
      operation: OperationsEnum.DELETE,
    ));
    Either<ErrorModel, SuccessModel<String?>> x = await baseCategoriesEndpointsActions
        .deleteCategoryAsync(categoryId: categoryId);
    x.match((l) {
      emit(AddEditDeleteCategoryState(isLoaded: true,
          isSuccess: false,
          message: l.message,
          statusCode: l.statusCode,
          categoryId: categoryId,
        operation: OperationsEnum.DELETE,
      ));
    }, (r) {
      emit(AddEditDeleteCategoryState(isLoaded: true,
          isSuccess: true,
          message: r.message,
          statusCode: r.statusCode,
          categoryId: categoryId,
        operation: OperationsEnum.DELETE,
      ));
      getCategories(keywordSearch: "");
    });
  }

}
