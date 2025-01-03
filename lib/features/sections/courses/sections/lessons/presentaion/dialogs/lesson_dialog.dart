import 'dart:convert';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:course_dashboard/core/components/method_components.dart';
import 'package:course_dashboard/core/components/widgets_components.dart';
import 'package:course_dashboard/core/dialogs/delete_dialog.dart';
import 'package:course_dashboard/core/enums/operations_enum.dart';
import 'package:course_dashboard/core/values/colors.dart';
import 'package:course_dashboard/features/sections/courses/business/cubit_controller/courses_cubit.dart';
import 'package:course_dashboard/features/sections/courses/data/models/course_model.dart';
import 'package:course_dashboard/features/sections/courses/data/models/lesson_model.dart';
import 'package:course_dashboard/features/sections/courses/presentaion/dialogs/course_detail_dialog.dart';
import 'package:course_dashboard/features/sections/courses/sections/lessons/presentaion/widgets/lesson_unit_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../../../../../business/app_cubit.dart';

lessonDialog(
    {required BuildContext mainContext,
      required LessonModel? lesson,
      required CourseModel course}) {
  showDialog(
      context: mainContext,
      barrierDismissible: false, // منع الإغلاق عند الضغط خارج النافذة
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController orderController = TextEditingController();
        TextEditingController urlController = TextEditingController();

        GlobalKey<FormState> formKey = GlobalKey<FormState>();

        QuillController scriptController = QuillController.basic()..formatSelection(Attribute.rtl);

        CoursesCubit courseCubit = CoursesCubit.get(mainContext)
          ..baseCoursesEndpointsActions.baseCoursesMethodsActions.isLessonLock =
          false;

        AppCubit appCubit = AppCubit.get(mainContext);

        courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.lessonUnitSelectedId = null;

          try {
            // محاولة تعيين المستند من JSON
            scriptController.document = Document.fromJson(jsonDecode(lesson != null ? lesson.script ?? '' : ''));
          } catch (e) {
            // إذا كانت هناك مشكلة (مثلاً النص العادي) قم بتحويل النص العادي إلى مستند Quill
            scriptController.document = Document()..insert(0, lesson != null ? lesson.script ?? '' : '');
            scriptController.formatSelection(Attribute.rtl);
          }

        if (lesson != null) {
          nameController.text = lesson.name ?? "";
          orderController.text = lesson.order?.toString() ?? "";
          courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions
              .isLessonLock = lesson.isLocked ?? false;

          courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.lessonUnitSelectedId = lesson.unitId;
        }

        if(orderController.text == "0" || orderController.text == ''){
          orderController.text = "1";
        }

        void submit() {
          if (lesson == null) {
            courseCubit.addLesson(
                lesson: LessonModel(
                name: nameController.text.trim(),
                id: null,
                isLocked: courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.isLessonLock,
                order: int.parse(orderController.text),
                unitId: courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.lessonUnitSelectedId,
                unitName: "",
                script: jsonEncode(scriptController.document.toDelta()),
                videoUrl: urlController.text,
                ));
          } else {
            courseCubit.editLesson(
                lessonModel: LessonModel(
                  name: nameController.text.trim(),
                  id: lesson.id,
                  isLocked: courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.isLessonLock,
                  order: int.parse(orderController.text),
                  unitId: courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.lessonUnitSelectedId,
                  unitName: "",
                  script: jsonEncode(scriptController.document.toDelta()),
                  videoUrl: urlController.text,
                ));
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
                    current is AddEditDeleteLessonState,
                    builder: (context, state) {
                      if (state is AddEditDeleteLessonState && !state.isLoaded) {
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
                        lesson == null ? "إضافة درس جديدة" : lesson.name ?? "",
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
                        text: "اسم الدرس",
                        onChange: (value) {},
                        validator: (value) {
                          if (value == null || value.toString().isEmpty) {
                            return "يجب أن تدخل اسم الدرس";
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
                    const Text("نص منسق لعنوان للفيديو", style: TextStyle(fontWeight: FontWeight.bold),),

                    QuillToolbar.simple(
                      configurations:
                      QuillSimpleToolbarConfigurations(
                          controller: scriptController,
                          showDirection: true),
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.grey.withOpacity(0.2),
                      child: QuillEditor.basic(
                        configurations: QuillEditorConfigurations(
                          controller: scriptController,
                          checkBoxReadOnly: false,
                          minHeight: 100,
                          padding: const EdgeInsetsDirectional.all(15),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    getAppTextField(
                        text: "رابط فيديو الدرس",
                        onChange: (value) {},
                        inputType: TextInputType.url,
                        validator: (value) {
                          if (value == null || value.toString().isEmpty) {
                            return "يجب أن تدخل رابط";
                          }
                          return urlValidation(value);
                        },
                        controller: urlController,
                        fillColor: Color(appColorGrey),
                        obscureText: false,
                        direction: TextDirection.rtl,
                        suffixIconButton: null,
                        onSubmitted: (value) {}),
                    const SizedBox(
                      height: 5,
                    ),
                    getAppTextField(
                        text: "ترتيب الدرس",
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
                            return "يجب أن تدخل ترتيب الدرس";
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

                    ConditionalBuilder(
                        condition: course.units != null,
                        builder: (context) => Wrap(
                            children: course.units!.map((unit) => LessonUnitItemWidget(unit: unit, onTap: (){
                              courseCubit.changeLessonUnitSelected(unitIdSelected: unit.id!);
                            },)).toList()),
                        fallback: (context) => Container(),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    BlocBuilder<CoursesCubit, CoursesState>(
                      buildWhen: (previous, current) => current is IsLessonLockState,
                      builder: (context, state) {
                        return InkWell(
                          onTap: () => courseCubit.changeLessonAllowLock(),
                          child: Wrap(
                            children: [
                              Checkbox(
                                value: courseCubit.baseCoursesEndpointsActions
                                    .baseCoursesMethodsActions.isLessonLock,
                                activeColor: Colors.blueAccent,
                                onChanged: (value) {
                                  courseCubit.changeLessonAllowLock();
                                },
                              ),
                              const Text(
                                "هل الدرس مقفل",
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
                          current is AddEditDeleteLessonState &&
                              (current.operation == OperationsEnum.ADD ||
                                  current.operation == OperationsEnum.EDIT),
                          listenWhen: (previous, current) =>
                          current is AddEditDeleteLessonState &&
                              (current.operation == OperationsEnum.ADD ||
                                  current.operation == OperationsEnum.EDIT) &&
                              current.isLoaded,
                          listener: (context, state) {
                            if (state is AddEditDeleteLessonState) {
                              if (state.isSuccess) {
                                appCubit.runAnOption(operations: OperationsEnum.SUCCESS, successMessage: state.message);
                                CourseModel updatedCourseByLesson;
                                if (state.operation == OperationsEnum.ADD) {
                                  updatedCourseByLesson = courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions
                                      .concatCourseWithNewLesson(course, state.lessonModel!);
                                } else {
                                  updatedCourseByLesson = courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions
                                      .concatCourseWithUpdatedLesson(course, state.lessonModel!);
                                }
                                Navigator.of(context).pop();
                                courseDetailDialog(
                                    mainContext, updatedCourseByLesson);
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
                            if (state is AddEditDeleteLessonState &&
                                !state.isLoaded) {
                              return const CircularProgressIndicator();
                            }
                            return appButton(
                                context: mainContext,
                                icon: lesson == null ? Icons.add : Icons.edit,
                                title: lesson == null ? "إضافة" : "حفظ التغييرات",
                                onAddTap: () {
                                  if(formKey.currentState!.validate()){
                                    if(scriptController.document.isEmpty()){
                                      getToast(message: "يجب أن تدخل وصف", isSuccess: false);
                                      return;
                                    }
                                    if(courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.lessonUnitSelectedId == null){
                                      getToast(message: "يجب أن تختار صنف", isSuccess: false);
                                      return;
                                    }

                                    submit();
                                  }
                                });
                          },
                        )
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
