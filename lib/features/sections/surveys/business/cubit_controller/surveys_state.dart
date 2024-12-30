part of 'surveys_cubit.dart';

@immutable
sealed class SurveysState {}

final class SurveysInitial extends SurveysState {}

final class GetSurveysState extends SurveysState {
  final bool isLoaded;
  final int statusCode;
  final bool isSuccess;
  final String message;
  final PaginationModel<SurveyModel>? surveysPaginated;
  GetSurveysState({required this.statusCode, required this.isLoaded, required this.isSuccess, required this.message, required this.surveysPaginated,});
}

final class AddEditDeleteSurveyState extends SurveysState {
  final int? surveyId;
  final bool isLoaded;
  final int statusCode;
  final bool isSuccess;
  final String message;
  final OperationsEnum operation;
  AddEditDeleteSurveyState({required this.statusCode, required this.isLoaded, required this.isSuccess, required this.message, this.surveyId, required this.operation});
}

final class ChangeSurveyUnitSelectedState extends SurveysState {
  final int selectedUnitId;
  ChangeSurveyUnitSelectedState({required this.selectedUnitId,});
}