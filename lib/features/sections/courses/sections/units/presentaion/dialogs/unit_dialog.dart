import 'package:course_dashboard/core/components/widgets_components.dart';
import 'package:course_dashboard/core/dialogs/delete_dialog.dart';
import 'package:course_dashboard/core/enums/operations_enum.dart';
import 'package:course_dashboard/core/values/colors.dart';
import 'package:course_dashboard/features/sections/courses/business/cubit_controller/courses_cubit.dart';
import 'package:course_dashboard/features/sections/courses/data/models/course_model.dart';
import 'package:course_dashboard/features/sections/courses/data/models/unit_model.dart';
import 'package:course_dashboard/features/sections/courses/presentaion/dialogs/course_detail_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../business/app_cubit.dart';

unitDialog(
    {required BuildContext mainContext,
    required UnitModel? unit,
    required CourseModel course}) {
  showDialog(
      context: mainContext,
      barrierDismissible: false, // منع الإغلاق عند الضغط خارج النافذة
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController orderController = TextEditingController();
        GlobalKey<FormState> formKey = GlobalKey<FormState>();

        CoursesCubit courseCubit = CoursesCubit.get(mainContext)
          ..baseCoursesEndpointsActions.baseCoursesMethodsActions.isUnitLock =
              false;

        AppCubit appCubit = AppCubit.get(mainContext);

        if (unit != null) {
          nameController.text = unit.name ?? "";
          orderController.text = unit.order?.toString() ?? "";
          courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions
              .isUnitLock = unit.isLocked ?? false;
        }

        if(orderController.text == "0" || orderController.text == ''){
          orderController.text = "1";
        }

        void submit() {
          if (unit == null) {
            courseCubit.addUnit(
                unitModel: UnitModel(
                    name: nameController.text.trim(),
                    id: null,
                    isLocked: courseCubit.baseCoursesEndpointsActions
                        .baseCoursesMethodsActions.isUnitLock,
                    order: int.parse(orderController.text),
                    courseId: course.id));
          } else {
            courseCubit.editUnit(
                unitModel: UnitModel(
                    name: nameController.text.trim(),
                    id: unit.id,
                    isLocked: courseCubit.baseCoursesEndpointsActions
                        .baseCoursesMethodsActions.isUnitLock,
                    order: int.parse(orderController.text),
                    courseId: course.id));
          }
          // Navigator.of(context).pop();
        }

        return AlertDialog(
          backgroundColor: Colors.white,
          title: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  BlocBuilder<CoursesCubit, CoursesState>(
                    buildWhen: (previous, current) =>
                        current is AddEditDeleteUnitState,
                    builder: (context, state) {
                      if (state is AddEditDeleteUnitState && !state.isLoaded) {
                        return const CircularProgressIndicator();
                      }
                      return IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            courseDetailDialog(mainContext, course);
                          },
                          icon: const Icon(Icons.close));
                    },
                  ),
                  Expanded(
                      child: Text(
                    textAlign: TextAlign.end,
                    unit == null ? "إضافة وحدة جديدة" : unit.name ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  )),
                ],
              )),
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getAppTextField(
                        text: "اسم الوحدة",
                        onChange: (value) {},
                        validator: (value) {
                          if (value == null || value.toString().isEmpty) {
                            return "يجب أن تدخل اسم الوحدة";
                          }
                        },
                        controller: nameController,
                        fillColor: Color(appColorGrey),
                        obscureText: false,
                        direction: TextDirection.rtl,
                        suffixIconButton: null,
                        onSubmitted: (value) {}),
                    const SizedBox(
                      height: 5,
                    ),
                    getAppTextField(
                        text: "ترتيب الوحدة",
                        onChange: (value) {
                          if (!RegExp(r'^\d*$').hasMatch(value)) {
                            orderController.text =
                                value.replaceAll(RegExp(r'[^0-9]'), '');
                            orderController.selection =
                                TextSelection.fromPosition(
                              TextPosition(offset: orderController.text.length),
                            );
                          }
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            if (newValue.text.isEmpty) {
                              return oldValue.copyWith(text: '1');
                            }
                            final intValue = int.tryParse(newValue.text);
                            if (intValue != null && intValue < 1) {
                              return oldValue.copyWith(text: '1');
                            }
                            return newValue;
                          }),
                        ],
                        validator: (value) {
                          if (value == null || value.toString().isEmpty) {
                            return "يجب أن تدخل ترتيب الوحدة";
                          }
                        },
                        controller: orderController,
                        fillColor: Color(appColorGrey),
                        obscureText: false,
                        direction: TextDirection.rtl,
                        suffixIconButton: null,
                        inputType: TextInputType.number,
                        onSubmitted: (value) {}),
                    const SizedBox(
                      height: 5,
                    ),
                    BlocBuilder<CoursesCubit, CoursesState>(
                      buildWhen: (previous, current) =>
                          current is IsUnitLockState,
                      builder: (context, state) {
                        return InkWell(
                          onTap: () => courseCubit.changeUnitAllowLock(),
                          child: Wrap(
                            children: [
                              Checkbox(
                                value: courseCubit.baseCoursesEndpointsActions
                                    .baseCoursesMethodsActions.isUnitLock,
                                activeColor: Colors.blueAccent,
                                onChanged: (value) {
                                  courseCubit.changeUnitAllowLock();
                                },
                              ),
                              const Text(
                                "هل الوحدة مقفلة",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: BlocConsumer<CoursesCubit, CoursesState>(
                          buildWhen: (previous, current) =>
                              current is AddEditDeleteUnitState &&
                              (current.operation == OperationsEnum.ADD ||
                                  current.operation == OperationsEnum.EDIT),
                          listenWhen: (previous, current) =>
                              current is AddEditDeleteUnitState &&
                              (current.operation == OperationsEnum.ADD ||
                                  current.operation == OperationsEnum.EDIT) &&
                              current.isLoaded,
                          listener: (context, state) {
                            if (state is AddEditDeleteUnitState) {
                              if (state.isSuccess) {
                                appCubit.runAnOption(
                                    operations: OperationsEnum.SUCCESS,
                                    successMessage: state.message);
                                CourseModel updatedCourseByUnit;
                                if (state.operation == OperationsEnum.ADD) {
                                  updatedCourseByUnit = courseCubit
                                      .baseCoursesEndpointsActions
                                      .baseCoursesMethodsActions
                                      .concatCourseWithNewUnit(
                                          course, state.unitModel!);
                                } else {
                                  updatedCourseByUnit = courseCubit
                                      .baseCoursesEndpointsActions
                                      .baseCoursesMethodsActions
                                      .concatCourseWithUpdatedUnit(
                                          course, state.unitModel!);
                                }
                                Navigator.of(context).pop();
                                courseDetailDialog(
                                    mainContext, updatedCourseByUnit);
                              } else {
                                appCubit.runAnOption(
                                    operations: OperationsEnum.FAIL,
                                    errorMessage: state.message);
                              }
                              getToast(
                                  message: state.message,
                                  isSuccess: state.isSuccess);
                            }
                          },
                          builder: (context, state) {
                            if (state is AddEditDeleteUnitState &&
                                !state.isLoaded) {
                              return const CircularProgressIndicator();
                            }
                            return appButton(
                              context: mainContext,
                                icon: unit == null ?  Icons.add : Icons.edit,
                                title: unit == null ? "إضافة" : "حفظ التغييرات",
                                onAddTap: () {
                                  if (formKey.currentState!.validate()) {
                                    submit();
                                  }
                                });
                          },
                        )

                        // getAppButton(
                        //   text: unit == null ? "إضافة" : "حفظ التغييرات",
                        //   color: AppColors.appLightBlueColor,
                        //   textColor: Colors.black, onClick: (){
                        //   if(formKey.currentState!.validate()){
                        //     // submit();
                        //     Navigator.of(context).pop();
                        //   }},
                        // ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
