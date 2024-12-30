import 'package:course_dashboard/core/values/colors.dart';
import 'package:course_dashboard/features/sections/courses/business/cubit_controller/courses_cubit.dart';
import 'package:course_dashboard/features/sections/courses/data/models/unit_model.dart';
import 'package:course_dashboard/features/sections/surveys/business/cubit_controller/surveys_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SurveyUnitItemWidget extends StatelessWidget {
  final UnitModel unit;
  final GestureTapCallback? onTap;

  const SurveyUnitItemWidget(
      {super.key, required this.unit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: BlocBuilder<SurveysCubit, SurveysState>(
        buildWhen: (previous, current) => current is ChangeSurveyUnitSelectedState,
        builder: (context, state) {
          Color color = SurveysCubit.get(context).baseSurveysEndpointsActions.baseSurveysMethodsActions.surveyUnitSelectedId != unit.id ? Color(appColorGrey) : Colors.lightBlue;
          if(state is ChangeSurveyUnitSelectedState && state.selectedUnitId == unit.id){
            color = SurveysCubit.get(context).baseSurveysEndpointsActions.baseSurveysMethodsActions.surveyUnitSelectedId == null ? Color(appColorGrey) : Colors.lightBlue;
          }

          return Container(
            margin: const EdgeInsetsDirectional.all(5),
            color: color,
            padding: const EdgeInsetsDirectional.all(8),
            child: Text(
              unit.name ?? "", style: const TextStyle(color: Colors.black),),
          );
        },
      ),
    );
  }
}
