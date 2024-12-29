import 'package:course_dashboard/core/data/models/pagination_model.dart';

import '../../../../../core/enums/operations_enum.dart';
import '../../data/models/post_model.dart';

// @immutable


sealed class PostsState {}

final class PostsInitial extends PostsState {}

final class GetPostsState extends PostsState {
  final bool isLoaded;
  final int statusCode;
  final bool isSuccess;
  final String message;
  final PaginationModel<PostModel>? postsPaginated;
  GetPostsState({required this.statusCode, required this.isLoaded, required this.isSuccess, required this.message, required this.postsPaginated,});
}

final class AddEditDeletePostState extends PostsState {
  final int? postId;
  final bool isLoaded;
  final int statusCode;
  final bool isSuccess;
  final String message;
  final OperationsEnum operation;
  AddEditDeletePostState({required this.statusCode, required this.isLoaded, required this.isSuccess, required this.message, this.postId, required this.operation});
}

final class ChangePostCategorySelectedState extends PostsState {
  final int selectedCategoryId;
  ChangePostCategorySelectedState({required this.selectedCategoryId,});
}

final class ChangePostImageSelectedState extends PostsState {}
