import 'dart:convert';
import 'dart:io';

import 'package:course_dashboard/core/data/models/pagination_model.dart';
import 'package:course_dashboard/core/data/models/success_model.dart';
import 'package:course_dashboard/features/sections/posts/business/actions/endpoints_actions/base_posts_endpoints_actions.dart';
import 'package:course_dashboard/features/sections/posts/business/actions/methods_actions/base_posts_methods_actions.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpdart/src/either.dart';
import 'package:http/http.dart';
import 'dart:typed_data';

import '../../../../../../core/data/models/error_model.dart';
import '../../../../../../core/network/server/api_constance.dart';
import '../../../../../../core/values/pagination.dart';
import '../../../data/models/add_edit_post_model.dart';
import '../../../data/models/post_model.dart';

class PostsEndpointsActions implements BasePostsEndpointsActions {
  @override
  final BasePostsMethodsActions basePostsMethodsActions;
  PostsEndpointsActions({required this.basePostsMethodsActions}) ;

  @override
  Future<Either<ErrorModel, SuccessModel<PaginationModel<PostModel>>>> getPostsAsync({required String keywordSearch, int pageNumber = pageNumber, int pageSize = pageSize}) async {
    try{
      Response response = await ApiConstance.getData(
          url: ApiConstance.httpLinkGetAllPosts(pageNumber: pageNumber, pageSize: pageSize, keywordSearch: keywordSearch), accessToken: "");

      dynamic jsonData = jsonDecode(response.body);
      if(response.statusCode >= 200 && response.statusCode < 300) {
        List<PostModel> categories = List.from( (jsonData['data']['data'] as List).map((e) => PostModel.fromJson(json: e)) );
        PaginationModel<PostModel> paginationModel = PaginationModel.fromJson(json: jsonData['data'], data: categories);
        SuccessModel<PaginationModel<PostModel>> successModel = SuccessModel<PaginationModel<PostModel>>(statusCode: response.statusCode, message: jsonData['message'], data: paginationModel);
        return Right(successModel);
      }

      return otherReturnedResponsesPaginated(statusCode: 0, elseMessage: jsonData['message']);
    } on SocketException catch (_) {
      return const Left(ErrorModel(message: "تحقق من اتصالك بالإنترنت", statusCode: -1));
    } on FormatException catch (_) {
      return const Left(ErrorModel(message: "الرابط غير صحيح", statusCode: -1));
    } catch (ex) {
      return const Left(
          ErrorModel(message: "الخادم غير متوفر حاليًا", statusCode: -1));
    }
  }

  @override
  Future<Either<ErrorModel, SuccessModel<String>>> addEditPost({required Uint8List? image, required AddEditPostModel addEditPostModel}) async {
    try{
      Response response = addEditPostModel.id == null ?
      // add
        await ApiConstance.postAndPutForm(
          fileBytes: image!,
          fileFieldName: 'ImageFile',
          isPost: true,
          url: ApiConstance.httpLinkCreatePost,
          data: addEditPostModel.toJson(), accessToken: "",
        ) :
      // edit
      await ApiConstance.postAndPutForm(
          fileBytes: image,
          fileFieldName: 'ImageFile',
          isPost: false,
          url: ApiConstance.httpLinkUpdatePost, data: addEditPostModel.toJson(), accessToken: ""
      );

      dynamic jsonData = jsonDecode(response.body);
      if(response.statusCode >= 200 && response.statusCode < 300) {
        // PostModel categoryModel = PostModel.fromJson(json: jsonData['data']);
        SuccessModel<String> successModel = SuccessModel<String>(statusCode: response.statusCode, message: jsonData['message'], data: "");
        return Right(successModel);
      }

      return otherReturnedResponses(statusCode: 0, elseMessage: jsonData['message']);

    } on SocketException catch (_) {
      return const Left(ErrorModel(message: "تحقق من اتصالك بالإنترنت", statusCode: -1));
    } on FormatException catch (_) {
      return const Left(ErrorModel(message: "الرابط غير صحيح", statusCode: -1));
    } catch (ex) {
      return const Left(
          ErrorModel(message: "الخادم غير متوفر حاليًا", statusCode: -1));
    }
  }


  @override
  Future<Either<ErrorModel, SuccessModel<String>>> deletePostAsync({required int postId}) async {
    try{
      Response response = await ApiConstance.deleteData(
          url: ApiConstance.httpLinkDeletePost(postId: postId),
          accessToken: ""
      );

      dynamic jsonData = jsonDecode(response.body);
      if(response.statusCode >= 200 && response.statusCode < 300) {
        return Right(SuccessModel(data: "", message: jsonData['message'], statusCode: response.statusCode));
      }

      if(response.statusCode >= 300) {
        return Left(ErrorModel(message: jsonData['message'], statusCode: response.statusCode));
      }

      return otherReturnedResponsesForDelete(statusCode: 0, elseMessage: jsonData['message']);

    } on SocketException catch (_) {
      return const Left(ErrorModel(message: "تحقق من اتصالك بالإنترنت", statusCode: -1));
    } on FormatException catch (_) {
      return const Left(ErrorModel(message: "الرابط غير صحيح", statusCode: -1));
    } catch (ex) {
      return const Left(
          ErrorModel(message: "الخادم غير متوفر حاليًا", statusCode: -1));
    }
  }

  Either<ErrorModel, SuccessModel<String>> otherReturnedResponsesForDelete({required int statusCode, required String elseMessage}) {
    if (statusCode  >= 500) {
      return Left(ErrorModel(message: "الخادم غير متوفر حاليًا", statusCode: statusCode));
    }
    return Left(ErrorModel(message: elseMessage, statusCode: statusCode));
  }

  Either<ErrorModel, SuccessModel<PaginationModel<PostModel>>> otherReturnedResponsesPaginated({required int statusCode, required String elseMessage}) {
    if (statusCode  >= 500) {
      return Left(ErrorModel(message: "الخادم غير متوفر حاليًا", statusCode: statusCode));
    }
    return Left(ErrorModel(message: elseMessage, statusCode: statusCode));
  }

  Either<ErrorModel, SuccessModel<PaginationModel<PostModel>>> otherReturnedResponsesNoPaginated({required int statusCode, required String elseMessage}) {
    if (statusCode  >= 500) {
      return Left(ErrorModel(message: "الخادم غير متوفر حاليًا", statusCode: statusCode));
    }
    return Left(ErrorModel(message: elseMessage, statusCode: statusCode));
  }

  Either<ErrorModel, SuccessModel<String>> otherReturnedResponses({required int statusCode, required String elseMessage}) {
    if (statusCode  >= 500) {
      return Left(ErrorModel(message: "الخادم غير متوفر حاليًا", statusCode: statusCode));
    }
    return Left(ErrorModel(message: elseMessage, statusCode: statusCode));
  }


}