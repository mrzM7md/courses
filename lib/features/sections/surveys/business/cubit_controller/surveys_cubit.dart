import 'package:bloc/bloc.dart';
import 'package:course_dashboard/core/data/models/pagination_model.dart';
import 'package:course_dashboard/core/enums/operations_enum.dart';
import 'package:course_dashboard/core/values/pagination.dart';
import 'package:course_dashboard/features/sections/surveys/business/actions/endpoints_actions/base_surveys_endpoints_actions.dart';
import 'package:course_dashboard/features/sections/surveys/data/models/survey_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';

import '../../../../../core/data/models/error_model.dart';
import '../../../../../core/data/models/success_model.dart';

part 'surveys_state.dart';

class SurveysCubit extends Cubit<SurveysState>{
  SurveysCubit({required this.baseSurveysEndpointsActions}) : super(SurveysInitial());

  static SurveysCubit get(context) => BlocProvider.of(context);
  final BaseSurveysEndpointsActions baseSurveysEndpointsActions;

  Future<void> getSurveys({required String keywordSearch, pageNumber = pageNumber, int pageSize = pageSize}) async {
    emit(GetSurveysState(isLoaded: false, isSuccess: false, message: "", surveysPaginated: null, statusCode: 0));
    Either<ErrorModel, SuccessModel<PaginationModel<SurveyModel>>> x = await baseSurveysEndpointsActions.getSurveysAsync(keywordSearch: keywordSearch, pageNumber: pageNumber, pageSize: pageSize);
    x.match((l){
      emit(GetSurveysState(isLoaded: true, isSuccess: false, message: l.message, surveysPaginated: null, statusCode: l.statusCode));
    }, (r){
      emit(GetSurveysState(isLoaded: true, isSuccess: true, message: r.message, surveysPaginated: r.data, statusCode: r.statusCode));
    });
  }

  Future<void> addSurvey({required SurveyModel survey}) async {
    emit(AddEditDeleteSurveyState(isLoaded: false, isSuccess: false, message: "", statusCode: 0,
      operation: OperationsEnum.ADD,
    ));
    Either<ErrorModel, SuccessModel<SurveyModel>> x = await baseSurveysEndpointsActions.addEditSurveyAsync(survey: survey);
    x.match((l){
      emit(AddEditDeleteSurveyState(isLoaded: true, isSuccess: false, message: l.message, statusCode: l.statusCode,
        operation: OperationsEnum.ADD,
      ));
    }, (r){
      emit(AddEditDeleteSurveyState(isLoaded: true, isSuccess: true, message: r.message, statusCode: r.statusCode,
        operation: OperationsEnum.ADD,
      ));
      getSurveys(keywordSearch: "");
    });
  }

  Future<void> updateSurvey({required SurveyModel surveyModel}) async {
    emit(AddEditDeleteSurveyState(isLoaded: false, isSuccess: false, message: "", statusCode: 0, surveyId: surveyModel.id,
      operation: OperationsEnum.EDIT,
    ));
    Either<ErrorModel, SuccessModel<SurveyModel>> x = await baseSurveysEndpointsActions.addEditSurveyAsync(survey: surveyModel);
    x.match((l){
      emit(AddEditDeleteSurveyState(isLoaded: true, isSuccess: false, message: l.message, statusCode: l.statusCode, surveyId: surveyModel.id,
        operation: OperationsEnum.EDIT,
              ));
    }, (r){
      emit(AddEditDeleteSurveyState(isLoaded: true, isSuccess: true, message: r.message, statusCode: r.statusCode, surveyId: surveyModel.id,
        operation: OperationsEnum.EDIT,
      ));
      getSurveys(keywordSearch: "");
    });
  }

  // make deleteSurvey method
  Future<void> deleteSurvey({required int surveyId}) async {
    emit(AddEditDeleteSurveyState(isLoaded: false,
        isSuccess: false,
        message: "",
        statusCode: 0,
        surveyId: surveyId,
      operation: OperationsEnum.DELETE,
    ));
    Either<ErrorModel, SuccessModel<String?>> x = await baseSurveysEndpointsActions
        .deleteSurveyAsync(surveyId: surveyId);
    x.match((l) {
      emit(AddEditDeleteSurveyState(isLoaded: true,
          isSuccess: false,
          message: l.message,
          statusCode: l.statusCode,
          surveyId: surveyId,
        operation: OperationsEnum.DELETE,
      ));
    }, (r) {
      emit(AddEditDeleteSurveyState(isLoaded: true,
          isSuccess: true,
          message: r.message,
          statusCode: r.statusCode,
          surveyId: surveyId,
        operation: OperationsEnum.DELETE,
      ));
      getSurveys(keywordSearch: "");
    });
  }

  void changeSurveyUnitSelected({required int unitIdSelected}){
    baseSurveysEndpointsActions.baseSurveysMethodsActions.surveyUnitSelectedId = unitIdSelected;
    emit(ChangeSurveyUnitSelectedState(selectedUnitId: unitIdSelected));
  }

}
