part of 'categories_cubit.dart';

@immutable
sealed class CategoriesState {}

final class CategoriesInitial extends CategoriesState {}

final class GetCategoriesState extends CategoriesState {
  final bool isLoaded;
  final int statusCode;
  final bool isSuccess;
  final String message;
  final PaginationModel<CategoryModel>? categoriesPaginated;
  GetCategoriesState({required this.statusCode, required this.isLoaded, required this.isSuccess, required this.message, required this.categoriesPaginated});
}

final class AddEditCategoryState extends CategoriesState {
  final bool isLoaded;
  final int statusCode;
  final bool isSuccess;
  final String message;
  AddEditCategoryState({required this.statusCode, required this.isLoaded, required this.isSuccess, required this.message});
}
