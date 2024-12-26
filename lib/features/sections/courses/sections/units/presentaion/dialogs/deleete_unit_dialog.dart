import 'package:course_dashboard/core/components/widgets_components.dart';
import 'package:course_dashboard/features/sections/courses/business/cubit_controller/courses_cubit.dart';
import 'package:course_dashboard/features/sections/courses/data/models/course_model.dart';
import 'package:course_dashboard/features/sections/courses/data/models/unit_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/dialogs/delete_dialog.dart';
import '../../../../../../../core/enums/operations_enum.dart';
import '../../../../../../business/app_cubit.dart';
import '../../../../presentaion/dialogs/course_detail_dialog.dart';

void deleteUnitDialog({required BuildContext baseContext, required UnitModel unit, required CourseModel course}){
  showDialog(
      context: baseContext,
      barrierDismissible: false, // منع الإغلاق عند الضغط خارج النافذة
      builder: (dialogContext){

        AppCubit appCubit = AppCubit.get(baseContext);
        CoursesCubit courseCubit = CoursesCubit.get(baseContext);

    return AlertDialog(
      backgroundColor: Colors.white,
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 24.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<CoursesCubit, CoursesState>(
                  buildWhen: (previous, current) => current is AddEditDeleteUnitState && current.operation == OperationsEnum.DELETE,
                  builder: (context, state) {
                    if(state is AddEditDeleteUnitState && !state.isLoaded){
                      return const CircularProgressIndicator();
                    }
                    return IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    courseDetailDialog(baseContext, course);                    },
                  icon: const Icon(Icons.close),
                );
  },
),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "حذف وحدة",
                  style: TextStyle(
                    fontSize:
                    MediaQuery.sizeOf(baseContext).width <= 400 ? 14 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "هل تريد حذف الوحدة '${unit.name}'?",
                  style: TextStyle(
                    fontSize:
                    MediaQuery.sizeOf(baseContext).width <= 400 ? 12 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocConsumer<CoursesCubit, CoursesState>(
                  listenWhen: (previous, current) => current is AddEditDeleteUnitState && current.operation == OperationsEnum.DELETE && current.isLoaded,
                  buildWhen: (previous, current) => current is AddEditDeleteUnitState && current.operation == OperationsEnum.DELETE,
                  listener: (context, state) {
                    if(state is AddEditDeleteUnitState){
                      if(state.isSuccess){
                        appCubit.runAnOption(operations: OperationsEnum.SUCCESS, successMessage: state.message);
                        CourseModel updatedCourseByDeleteUnit = courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.deleteUnitFromCourse(course, unit!);

                        Navigator.of(dialogContext).pop();
                        courseDetailDialog(baseContext, updatedCourseByDeleteUnit);
                      } else {
                        appCubit.runAnOption(operations: OperationsEnum.FAIL, errorMessage: state.message);
                      }
                      getToast(message: state.message, isSuccess: state.isSuccess);
                    }
                  },
                  builder: (context, state) {
                    if(state is AddEditDeleteUnitState && !state.isLoaded){
                      return const CircularProgressIndicator();
                    }
                    return getAppButton(
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      text: 'حذف',
                      onClick: () {
                        courseCubit.deleteUnit(unitId: unit.id!);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  });
}