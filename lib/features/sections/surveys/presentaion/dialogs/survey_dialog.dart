import 'package:course_dashboard/core/components/widgets_components.dart';
import 'package:course_dashboard/core/dialogs/delete_dialog.dart';
import 'package:course_dashboard/core/enums/operations_enum.dart';
import 'package:course_dashboard/core/values/colors.dart';
import 'package:course_dashboard/features/sections/courses/business/cubit_controller/courses_cubit.dart';
import 'package:course_dashboard/features/sections/surveys/business/cubit_controller/surveys_cubit.dart';
import 'package:course_dashboard/features/sections/surveys/data/models/survey_model.dart';
import 'package:course_dashboard/features/sections/surveys/presentaion/widgets/survey_unit_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../business/app_cubit.dart';

surveyDialog(
    {required BuildContext mainContext,
      required SurveyModel? survey,}) {
  showDialog(
      context: mainContext,
      barrierDismissible: false, // منع الإغلاق عند الضغط خارج النافذة
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController orderController = TextEditingController();
        TextEditingController unitController = TextEditingController();

        // CoursesCubit.get(mainContext).getCategories(keywordSearch: "", pageSize: 20);

        GlobalKey<FormState> formKey = GlobalKey<FormState>();

        SurveysCubit surveyCubit = SurveysCubit.get(mainContext);

        AppCubit appCubit = AppCubit.get(mainContext);

        surveyCubit.baseSurveysEndpointsActions.baseSurveysMethodsActions.surveyUnitSelectedId = null;

        if(orderController.text == "0" || orderController.text == ''){
          orderController.text = "1";
        }

        if(unitController.text == "0" || unitController.text == ''){
          unitController.text = "1";
        }

        if(survey !=  null){
          nameController.text = survey.name ?? '';
          orderController.text = survey.order.toString();
          unitController.text = survey.unitId.toString();
          surveyCubit.baseSurveysEndpointsActions.baseSurveysMethodsActions.surveyUnitSelectedId = survey.unitId;
        }

        void submit() {
          if (survey == null) {
            surveyCubit.addSurvey(
                survey: SurveyModel(
                  name: nameController.text.trim(),
                  id: null,
                  courseTitle: "",
                  order: int.parse(orderController.text),
                  // unitId: surveyCubit.baseSurveysEndpointsActions.baseSurveysMethodsActions.surveyUnitSelectedId,
                  unitId: int.parse(unitController.text),
                  unitName: "",
                ));
          } else {
            surveyCubit.updateSurvey(
                surveyModel: SurveyModel(
                  name: nameController.text.trim(),
                  id: survey.id,
                  order: int.parse(orderController.text),
                  // unitId: surveyCubit.baseSurveysEndpointsActions.baseSurveysMethodsActions.surveyUnitSelectedId,
                  unitName: "",
                  unitId: int.parse(unitController.text),
                  courseTitle: "",
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
                  BlocBuilder<SurveysCubit, SurveysState>(
                    buildWhen: (previous, current) =>
                    current is AddEditDeleteSurveyState,
                    builder: (context, state) {
                      if (state is AddEditDeleteSurveyState && !state.isLoaded) {
                        return const CircularProgressIndicator();
                      }
                      return IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close));
                    },
                  ),
                  Expanded(
                      child: Text(
                        textAlign: TextAlign.end,
                        survey == null ? "إضافة استبيان جديدة" : survey.name ?? "",
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
                        text: "اسم الاستبيان",
                        onChange: (value) {},
                        validator: (value) {
                          if (value == null || value.toString().isEmpty) {
                            return "يجب أن تدخل اسم الاستبيان";
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

                    const SizedBox(
                      height: 5,
                    ),
                    getAppTextField(
                        text: "ترتيب الاستبيان",
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
                            return "يجب أن تدخل ترتيب الاستبيان";
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
                    getAppTextField(
                        text: "معرف الوحدة",
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
                            return "يجب أن تدخل معرف الوحدة";
                          }
                        },
                        controller: unitController,
                        fillColor: Color(appColorGrey),
                        obscureText: false,
                        direction: TextDirection.rtl,
                        suffixIconButton: null,
                        inputType: TextInputType.number,
                        onSubmitted: (value) {}),


                    // const SizedBox(
                    //   height: 5,
                    // ),
                    //
                    // Wrap(
                    //     children: survey.units!.map((unit) => SurveyUnitItemWidget(unit: unit, onTap: (){
                    //       surveyCubit.changeSurveyUnitSelected(unitIdSelected: unit.id!);
                    //     },)).toList()),

                    const SizedBox(
                      height: 5,
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: BlocConsumer<SurveysCubit, SurveysState>(
                          buildWhen: (previous, current) =>
                          current is AddEditDeleteSurveyState &&
                              (current.operation == OperationsEnum.ADD ||
                                  current.operation == OperationsEnum.EDIT),
                          listenWhen: (previous, current) =>
                          current is AddEditDeleteSurveyState &&
                              (current.operation == OperationsEnum.ADD ||
                                  current.operation == OperationsEnum.EDIT) &&
                              current.isLoaded,
                          listener: (context, state) {
                            if (state is AddEditDeleteSurveyState) {
                              if (state.isSuccess) {
                                appCubit.runAnOption(operations: OperationsEnum.SUCCESS, successMessage: state.message);
                                Navigator.of(context).pop();
                              } else {
                                appCubit.runAnOption(
                                    operations: OperationsEnum.FAIL,
                                    errorMessage: state.message);
                              }
                            }
                          },
                          builder: (context, state) {
                            if (state is AddEditDeleteSurveyState &&
                                !state.isLoaded) {
                              return const CircularProgressIndicator();
                            }
                            return appButton(
                                context: mainContext,
                                icon: survey == null ? Icons.add : Icons.edit,
                                title: survey == null ? "إضافة" : "حفظ التغييرات",
                                onAddTap: () {
                                  if(formKey.currentState!.validate()){
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
