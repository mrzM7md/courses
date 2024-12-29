import 'package:course_dashboard/features/sections/courses/data/models/course_model.dart';
import 'package:course_dashboard/features/sections/posts/business/actions/methods_actions/base_posts_methods_actions.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../../core/data/models/error_model.dart';
import '../../../../../../core/data/models/pagination_model.dart';
import '../../../../../../core/data/models/success_model.dart';
import '../../../../../../core/values/pagination.dart';

import 'dart:typed_data';

import '../../../data/models/add_edit_post_model.dart';
import '../../../data/models/post_model.dart';

abstract class BasePostsEndpointsActions {
  final BasePostsMethodsActions basePostsMethodsActions;
  BasePostsEndpointsActions({required this.basePostsMethodsActions});

  Future<Either<ErrorModel, SuccessModel<PaginationModel<PostModel>>>> getPostsAsync({required String keywordSearch, int pageNumber = pageNumber, int pageSize = pageSize});
  Future<Either<ErrorModel, SuccessModel<String>>> addEditPost({required Uint8List? image ,required AddEditPostModel addEditPostModel});
  Future<Either<ErrorModel, SuccessModel<String>>> deletePostAsync({required int postId});
}