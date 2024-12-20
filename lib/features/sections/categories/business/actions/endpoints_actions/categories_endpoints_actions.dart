import 'dart:convert';
import 'dart:io';

import 'package:course_dashboard/core/data/models/error_model.dart';
import 'package:course_dashboard/core/data/models/pagination_model.dart';
import 'package:course_dashboard/core/data/models/success_model.dart';
import 'package:course_dashboard/core/network/server/api_constance.dart';
import 'package:course_dashboard/features/sections/categories/business/actions/endpoints_actions/base_categories_endpoints_actions.dart';
import 'package:fpdart/src/either.dart';
import 'package:http/http.dart';

import '../../../../../../core/values/pagination.dart';
import '../../../data/models/category_model.dart';

class CategoriesEndpointsActions implements BaseCategoriesEndpointsActions {
  @override
  Future<Either<ErrorModel, SuccessModel<PaginationModel<CategoryModel>>>> getCategoriesAsync({required String keywordSearch, int pageNumber = pageNumber, int pageSize = pageSize}) async {
    try{
      Response response = await ApiConstance.getData(
          url: ApiConstance.httpLinkGetAllCategories(pageNumber: pageNumber, pageSize: pageSize, keywordSearch: keywordSearch), accessToken: "");

        dynamic jsonData = jsonDecode(response.body);
        if(response.statusCode >= 200 && response.statusCode < 300) {
          List<CategoryModel> categories = List.from( (jsonData['data']['data'] as List).map((e) => CategoryModel.fromJson(json: e)) );
          PaginationModel<CategoryModel> paginationModel = PaginationModel.fromJson(json: jsonData['data'], data: categories);
          SuccessModel<PaginationModel<CategoryModel>> successModel = SuccessModel<PaginationModel<CategoryModel>>(statusCode: response.statusCode, message: jsonData['message'], data: paginationModel);
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
  Future<Either<ErrorModel, SuccessModel<CategoryModel>>> addEditCategoryAsync({required CategoryModel category}) async {
    try{
      Response response = await ApiConstance.postData(
          url: ApiConstance.httpLinkCreateCategory, data: category.toJson(), accessToken: "");

      print("Response: ${response.body}");

      dynamic jsonData = jsonDecode(response.body);
      if(response.statusCode >= 200 && response.statusCode < 300) {
        CategoryModel categoryModel = CategoryModel.fromJson(json: jsonData['data']);
        SuccessModel<CategoryModel> successModel = SuccessModel<CategoryModel>(statusCode: response.statusCode, message: jsonData['message'], data: categoryModel);
        return Right(successModel);
      }

      return otherReturnedResponses(statusCode: 0, elseMessage: jsonData['message']);

    } on SocketException catch (_) {
      return const Left(ErrorModel(message: "تحقق من اتصالك بالإنترنت", statusCode: -1));
    } on FormatException catch (_) {
      return const Left(ErrorModel(message: "الرابط غير صحيح", statusCode: -1));
    } catch (ex) {
      print("Ex:::: $ex");
      return const Left(
          ErrorModel(message: "الخادم غير متوفر حاليًا", statusCode: -1));
    }
  }

  @override
  Future<Either<ErrorModel, SuccessModel<String?>>> deleteCategoryAsync({required String categoryId}) {
    throw UnimplementedError();
  }

  Either<ErrorModel, SuccessModel<PaginationModel<CategoryModel>>> otherReturnedResponsesPaginated({required int statusCode, required String elseMessage}) {
    if (statusCode  >= 500) {
      return Left(ErrorModel(message: "الخادم غير متوفر حاليًا", statusCode: statusCode));
    }
      return Left(ErrorModel(message: elseMessage, statusCode: statusCode));
  }





  Either<ErrorModel, SuccessModel<PaginationModel<CategoryModel>>> otherReturnedResponsesNoPaginated({required int statusCode, required String elseMessage}) {
    if (statusCode  >= 500) {
      return Left(ErrorModel(message: "الخادم غير متوفر حاليًا", statusCode: statusCode));
    }
    return Left(ErrorModel(message: elseMessage, statusCode: statusCode));
  }

  Either<ErrorModel, SuccessModel<CategoryModel>> otherReturnedResponses({required int statusCode, required String elseMessage}) {
    if (statusCode  >= 500) {
      return Left(ErrorModel(message: "الخادم غير متوفر حاليًا", statusCode: statusCode));
    }
    return Left(ErrorModel(message: elseMessage, statusCode: statusCode));
  }

}