import 'package:bloc/bloc.dart';
import 'package:course_dashboard/core/data/models/success_model.dart';
import 'package:course_dashboard/features/sections/posts/business/cubit_controller/posts_state.dart';
import 'package:course_dashboard/features/sections/posts/data/models/add_edit_post_model.dart';import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import 'dart:typed_data';

import '../../../../../core/data/models/error_model.dart';
import '../../../../../core/data/models/pagination_model.dart';
import '../../../../../core/enums/operations_enum.dart';
import '../../../../../core/values/pagination.dart';
import '../../data/models/post_model.dart';
import '../actions/endpoints_actions/base_posts_endpoints_actions.dart';

class PostsCubit extends Cubit<PostsState> {
  final BasePostsEndpointsActions basePostsEndpointsActions;
  PostsCubit({required this.basePostsEndpointsActions}) : super(PostsInitial());

  static PostsCubit get(context) => BlocProvider.of(context);

  Future<void> getPosts({required String keywordSearch, pageNumber = pageNumber, int pageSize = pageSize}) async {
    emit(GetPostsState(isLoaded: false, isSuccess: false, message: "", postsPaginated: null, statusCode: 0));
    Either<ErrorModel, SuccessModel<PaginationModel<PostModel>>> x = await basePostsEndpointsActions.getPostsAsync(keywordSearch: keywordSearch, pageNumber: pageNumber, pageSize: pageSize);
    x.match((l){
      emit(GetPostsState(isLoaded: true, isSuccess: false, message: l.message, postsPaginated: null, statusCode: l.statusCode));
    }, (r){
      emit(GetPostsState(isLoaded: true, isSuccess: true, message: r.message, postsPaginated: r.data, statusCode: r.statusCode));
    });
  }

  Future<void> addPost({required AddEditPostModel addEditPostModel, required Uint8List? fileBytes}) async {
    emit(AddEditDeletePostState(isLoaded: false, isSuccess: false, message: "", statusCode: 0,
      operation: OperationsEnum.ADD,
    ));
    Either<ErrorModel, SuccessModel> x = await basePostsEndpointsActions.addEditPost(addEditPostModel: addEditPostModel, image: fileBytes);
    x.match((l){
      emit(AddEditDeletePostState(isLoaded: true, isSuccess: false, message: l.message, statusCode: l.statusCode,
        operation: OperationsEnum.ADD,
      ));
    }, (r){
      // print("TRUE RES: ${r.data}");
      emit(AddEditDeletePostState(isLoaded: true, isSuccess: true, message: r.message, statusCode: r.statusCode,
        operation: OperationsEnum.ADD,
      ));
      getPosts(keywordSearch: "");
    });
  }

  Future<void> updatePost({required AddEditPostModel addEditPostModel, required Uint8List? fileBytes}) async {
    emit(AddEditDeletePostState(isLoaded: false, isSuccess: false, message: "", statusCode: 0,
      operation: OperationsEnum.EDIT,
    ));
    Either<ErrorModel, SuccessModel<String>> x = await basePostsEndpointsActions.addEditPost(addEditPostModel: addEditPostModel, image: fileBytes);
    x.match((l){
      emit(AddEditDeletePostState(isLoaded: true, isSuccess: false, message: l.message, statusCode: l.statusCode,
          operation: OperationsEnum.EDIT,
          postId: addEditPostModel.id
      ));
    }, (r){
      emit(AddEditDeletePostState(isLoaded: true, isSuccess: true, message: r.message, statusCode: r.statusCode,
        operation: OperationsEnum.EDIT,
        postId: addEditPostModel.id,
      ));
      getPosts(keywordSearch: "");
    });
  }

  Future<void> deletePost({required int postId}) async {
    emit(AddEditDeletePostState(isLoaded: false,
      isSuccess: false,
      message: "",
      statusCode: 0,
      postId: postId,
      operation: OperationsEnum.DELETE,
    ));
    Either<ErrorModel, SuccessModel<String?>> x = await basePostsEndpointsActions
        .deletePostAsync(postId: postId);
    x.match((l) {
      emit(AddEditDeletePostState(isLoaded: true,
        isSuccess: false,
        message: l.message,
        statusCode: l.statusCode,
        postId: postId,
        operation: OperationsEnum.DELETE,
      ));
    }, (r) {
      emit(AddEditDeletePostState(isLoaded: true,
        isSuccess: true,
        message: r.message,
        statusCode: r.statusCode,
        postId: postId,
        operation: OperationsEnum.DELETE,
      ));
      getPosts(keywordSearch: "");
    });
  }



  void changePostCategorySelected({required int categoryIdSelected}){
    basePostsEndpointsActions.basePostsMethodsActions.postCategorySelectedId = categoryIdSelected;
    emit(ChangePostCategorySelectedState(selectedCategoryId: categoryIdSelected));
  }

  void changePostImageSelected(){
    emit(ChangePostImageSelectedState());
  }
}