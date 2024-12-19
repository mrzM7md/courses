import 'package:bloc/bloc.dart';
import 'package:course_dashboard/core/data/models/pagination_model.dart';
import 'package:course_dashboard/core/values/pagination.dart';
import 'package:course_dashboard/features/sections/categories/business/actions/endpoints_actions/base_categories_endpoints_actions.dart';
import 'package:course_dashboard/features/sections/categories/business/actions/endpoints_actions/categories_endpoints_actions.dart';
import 'package:course_dashboard/features/sections/categories/data/models/category_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';

import '../../../../../core/data/models/error_model.dart';
import '../../../../../core/data/models/success_model.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit({required this.baseCategoriesEndpointsActions}) : super(CategoriesInitial());

  static CategoriesCubit get(context) => BlocProvider.of(context);
  final BaseCategoriesEndpointsActions baseCategoriesEndpointsActions;

  Future<void> getCategories({required String keywordSearch}) async {
    emit(GetCategoriesState(isLoaded: false, isSuccess: false, message: "", pagination: null, statusCode: 0));
    Either<ErrorModel, SuccessModel<PaginationModel<CategoryModel>>> x = await baseCategoriesEndpointsActions.getCategoriesAsync(keywordSearch: keywordSearch);
    x.match((l){
      emit(GetCategoriesState(isLoaded: true, isSuccess: false, message: l.message, pagination: null, statusCode: l.statusCode));
    }, (r){
      emit(GetCategoriesState(isLoaded: true, isSuccess: true, message: r.message, pagination: r.data, statusCode: r.statusCode));
    });
  }
}
