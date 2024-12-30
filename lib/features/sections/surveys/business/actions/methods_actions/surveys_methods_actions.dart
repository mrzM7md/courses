import 'package:course_dashboard/features/sections/posts/business/actions/methods_actions/base_posts_methods_actions.dart';
import 'package:course_dashboard/features/sections/surveys/business/actions/methods_actions/base_surveys_methods_actions.dart';

class SurveysMethodsActions implements BaseSurveysMethodsActions {
  int? _surveyUnitSelectedId;
  @override
  int? get surveyUnitSelectedId => _surveyUnitSelectedId;

  @override
  set surveyUnitSelectedId(int? value) { _surveyUnitSelectedId = value;}
}