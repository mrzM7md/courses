import 'package:course_dashboard/core/values/colors.dart';
import 'package:course_dashboard/features/sections/courses/business/cubit_controller/courses_cubit.dart';
import 'package:course_dashboard/features/sections/courses/data/models/unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitItemWidget extends StatelessWidget {
  final UnitModel unit;
  final GestureTapCallback? onTap;

  const UnitItemWidget(
      {super.key, required this.unit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: BlocBuilder<CoursesCubit, CoursesState>(
        buildWhen: (previous, current) => current is ChangeLessonUnitSelectedState,
        builder: (context, state) {
          Color color = CoursesCubit.get(context).baseCoursesEndpointsActions.baseCoursesMethodsActions.lessonUnitSelectedId != unit.id ? Color(appColorGrey) : Colors.lightBlue;
          if(state is ChangeLessonUnitSelectedState && state.selectedUnitId == unit.id){
            color = CoursesCubit.get(context).baseCoursesEndpointsActions.baseCoursesMethodsActions.lessonUnitSelectedId == null ? Color(appColorGrey) : Colors.lightBlue;
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
