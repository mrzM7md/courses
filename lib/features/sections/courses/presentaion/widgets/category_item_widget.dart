import 'package:course_dashboard/core/values/colors.dart';
import 'package:course_dashboard/features/sections/categories/data/models/category_model.dart';
import 'package:course_dashboard/features/sections/courses/business/cubit_controller/courses_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryItemWidget extends StatelessWidget {
  final CategoryModel category;
  final GestureTapCallback? onTap;

  const CategoryItemWidget(
      {super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: BlocBuilder<CoursesCubit, CoursesState>(
        buildWhen: (previous, current) => current is ChangeCourseCategorySelectedState,
        builder: (context, state) {
          Color color = CoursesCubit.get(context).baseCoursesEndpointsActions.baseCoursesMethodsActions.courseCategorySelectedId != category.id ? Color(appColorGrey) : Colors.lightBlue;
          if(state is ChangeCourseCategorySelectedState && state.selectedCategoryId == category.id){
            color = CoursesCubit.get(context).baseCoursesEndpointsActions.baseCoursesMethodsActions.courseCategorySelectedId == null ? Color(appColorGrey) : Colors.lightBlue;
          }

          return Container(
            margin: const EdgeInsetsDirectional.all(5),
            color: color,
            padding: const EdgeInsetsDirectional.all(8),
            child: Text(
              category.name, style: const TextStyle(color: Colors.black),),
          );
        },
      ),
    );
  }
}
