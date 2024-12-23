import 'dart:convert';
import 'dart:io';

import 'package:course_dashboard/core/data/models/error_model.dart';
import 'package:course_dashboard/core/data/models/pagination_model.dart';
import 'package:course_dashboard/core/data/models/success_model.dart';
import 'package:course_dashboard/features/sections/courses/business/actions/endpoints_actions/base_courses_endpoints_actions.dart';
import 'package:course_dashboard/features/sections/courses/business/actions/methods_actions/base_courses_methods_actions.dart';
import 'package:course_dashboard/features/sections/courses/data/models/course_model.dart';
import 'package:fpdart/src/either.dart';
import 'package:http/http.dart';

import '../../../../../../core/network/server/api_constance.dart';
import '../../../../../../core/values/pagination.dart';

class CoursesEndpointsActions implements BaseCoursesEndpointsActions {
  @override
  final BaseCoursesMethodsActions baseCoursesMethodsActions;
  CoursesEndpointsActions({required this.baseCoursesMethodsActions}) ;

  @override
  Future<Either<ErrorModel, SuccessModel<PaginationModel<CourseModel>>>> getCoursesAsync({required String keywordSearch, int pageNumber = pageNumber, int pageSize = pageSize}) async {
    try{
      Response response = await ApiConstance.getData(
          url: ApiConstance.httpLinkGetAllCourses(pageNumber: pageNumber, pageSize: pageSize, keywordSearch: keywordSearch), accessToken: "");

      dynamic jsonData = jsonDecode(response.body);
      if(response.statusCode >= 200 && response.statusCode < 300) {
        List<CourseModel> categories = List.from( (jsonData['data']['data'] as List).map((e) => CourseModel.fromJson(json: e)) );
        PaginationModel<CourseModel> paginationModel = PaginationModel.fromJson(json: jsonData['data'], data: categories);
        SuccessModel<PaginationModel<CourseModel>> successModel = SuccessModel<PaginationModel<CourseModel>>(statusCode: response.statusCode, message: jsonData['message'], data: paginationModel);
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
  Either<ErrorModel, SuccessModel<PaginationModel<CourseModel>>> otherReturnedResponsesPaginated({required int statusCode, required String elseMessage}) {
    if (statusCode  >= 500) {
      return Left(ErrorModel(message: "الخادم غير متوفر حاليًا", statusCode: statusCode));
    }
    return Left(ErrorModel(message: elseMessage, statusCode: statusCode));
  }

  Either<ErrorModel, SuccessModel<PaginationModel<CourseModel>>> otherReturnedResponsesNoPaginated({required int statusCode, required String elseMessage}) {
    if (statusCode  >= 500) {
      return Left(ErrorModel(message: "الخادم غير متوفر حاليًا", statusCode: statusCode));
    }
    return Left(ErrorModel(message: elseMessage, statusCode: statusCode));
  }

  Either<ErrorModel, SuccessModel<CourseModel>> otherReturnedResponses({required int statusCode, required String elseMessage}) {
    if (statusCode  >= 500) {
      return Left(ErrorModel(message: "الخادم غير متوفر حاليًا", statusCode: statusCode));
    }
    return Left(ErrorModel(message: elseMessage, statusCode: statusCode));
  }

  Either<ErrorModel, SuccessModel<String>> otherReturnedResponsesForDelete({required int statusCode, required String elseMessage}) {
    if (statusCode  >= 500) {
      return Left(ErrorModel(message: "الخادم غير متوفر حاليًا", statusCode: statusCode));
    }
    return Left(ErrorModel(message: elseMessage, statusCode: statusCode));
  }

}