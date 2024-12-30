import 'dart:convert';
import 'dart:io';

import 'package:course_dashboard/core/data/models/error_model.dart';
import 'package:course_dashboard/core/data/models/pagination_model.dart';
import 'package:course_dashboard/core/data/models/success_model.dart';
import 'package:course_dashboard/core/network/server/api_constance.dart';
import 'package:course_dashboard/features/sections/surveys/business/actions/endpoints_actions/base_surveys_endpoints_actions.dart';
import 'package:course_dashboard/features/sections/surveys/business/actions/endpoints_actions/base_surveys_endpoints_actions.dart';
import 'package:course_dashboard/features/sections/surveys/business/actions/methods_actions/base_surveys_methods_actions.dart';
import 'package:fpdart/src/either.dart';
import 'package:http/http.dart';

import '../../../../../../core/values/pagination.dart';
import '../../../data/models/survey_model.dart';
 
class SurveysEndpointsActions implements BaseSurveysEndpointsActions {
  @override
  BaseSurveysMethodsActions baseSurveysMethodsActions;
  SurveysEndpointsActions({required this.baseSurveysMethodsActions});

  @override
  Future<Either<ErrorModel, SuccessModel<PaginationModel<SurveyModel>>>> getSurveysAsync({required String keywordSearch, int pageNumber = pageNumber, int pageSize = pageSize}) async {
    try{
      Response response = await ApiConstance.getData(
          url: ApiConstance.httpLinkGetAllSurveys(pageNumber: pageNumber, pageSize: pageSize, keywordSearch: keywordSearch), accessToken: "");

        dynamic jsonData = jsonDecode(response.body);
        if(response.statusCode >= 200 && response.statusCode < 300) {
          List<SurveyModel> surveys = List.from( (jsonData['data']['data'] as List).map((e) => SurveyModel.fromJson(json: e)) );
          PaginationModel<SurveyModel> paginationModel = PaginationModel.fromJson(json: jsonData['data'], data: surveys);
          SuccessModel<PaginationModel<SurveyModel>> successModel = SuccessModel<PaginationModel<SurveyModel>>(statusCode: response.statusCode, message: jsonData['message'], data: paginationModel);
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
  Future<Either<ErrorModel, SuccessModel<SurveyModel>>> addEditSurveyAsync({required SurveyModel survey}) async {
    try{
      Response response = survey.id == null ? await ApiConstance.postData(
          url: ApiConstance.httpLinkCreateSurvey, data: survey.toJson(), accessToken: ""
      ) :
      await ApiConstance.putData(url: ApiConstance.httpLinkUpdateSurvey, accessToken: "", data: survey.toJson());

      dynamic jsonData = jsonDecode(response.body);
      print("JsonData: $jsonData");
      if(response.statusCode >= 200 && response.statusCode < 300) {
        SurveyModel surveyModel = SurveyModel.fromJson(json: jsonData['data']);
        SuccessModel<SurveyModel> successModel = SuccessModel<SurveyModel>(statusCode: response.statusCode, message: jsonData['message'], data: surveyModel);
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
  Future<Either<ErrorModel, SuccessModel<String?>>> deleteSurveyAsync({required int surveyId}) async {
    try{
      Response response = await ApiConstance.deleteData(
          url: ApiConstance.httpLinkDeleteSurvey(surveyId: surveyId),
        accessToken: ""
      );


      dynamic jsonData = jsonDecode(response.body);


      if(response.statusCode >= 200 && response.statusCode < 300) {
        return Right(SuccessModel(data: null, message: jsonData['message'], statusCode: response.statusCode));
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

  Either<ErrorModel, SuccessModel<PaginationModel<SurveyModel>>> otherReturnedResponsesPaginated({required int statusCode, required String elseMessage}) {
    if (statusCode  >= 500) {
      return Left(ErrorModel(message: "الخادم غير متوفر حاليًا", statusCode: statusCode));
    }
      return Left(ErrorModel(message: elseMessage, statusCode: statusCode));
  }





  Either<ErrorModel, SuccessModel<PaginationModel<SurveyModel>>> otherReturnedResponsesNoPaginated({required int statusCode, required String elseMessage}) {
    if (statusCode  >= 500) {
      return Left(ErrorModel(message: "الخادم غير متوفر حاليًا", statusCode: statusCode));
    }
    return Left(ErrorModel(message: elseMessage, statusCode: statusCode));
  }

  Either<ErrorModel, SuccessModel<SurveyModel>> otherReturnedResponses({required int statusCode, required String elseMessage}) {
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