import 'package:course_dashboard/core/data/models/pagination_model.dart';
import 'package:course_dashboard/core/data/models/success_model.dart';
import 'package:course_dashboard/features/sections/surveys/business/actions/methods_actions/base_surveys_methods_actions.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../../core/data/models/error_model.dart';
import '../../../../../../core/values/pagination.dart';
import '../../../data/models/survey_model.dart';

abstract class BaseSurveysEndpointsActions {
  BaseSurveysMethodsActions baseSurveysMethodsActions;
  BaseSurveysEndpointsActions({required this.baseSurveysMethodsActions});

  Future<Either<ErrorModel, SuccessModel<SurveyModel>>> addEditSurveyAsync({required SurveyModel survey});
  Future<Either<ErrorModel, SuccessModel<PaginationModel<SurveyModel>>>> getSurveysAsync({required String keywordSearch, int pageNumber = pageNumber, int pageSize = pageSize});
  Future<Either<ErrorModel, SuccessModel<String?>>> deleteSurveyAsync({required int surveyId});
}