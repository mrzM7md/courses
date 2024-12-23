import 'dart:convert';

import 'package:course_dashboard/core/data/models/pagination_model.dart';
import 'package:course_dashboard/core/values/colors.dart';
import 'package:course_dashboard/features/sections/categories/business/cubit_controller/categories_cubit.dart';
import 'package:course_dashboard/features/sections/categories/data/models/category_model.dart';
import 'package:course_dashboard/features/sections/courses/business/cubit_controller/courses_cubit.dart';
import 'package:course_dashboard/features/sections/courses/data/models/course_model.dart';
import 'package:course_dashboard/features/sections/courses/presentaion/widgets/category_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker_web/image_picker_web.dart';

import '../../../../../core/components/widgets_components.dart';

courseDialog(BuildContext mainContext, CourseModel? course) {
  dynamic imageUrl;

  late DropzoneViewController dropzoneViewController;
  CategoriesCubit categoriesCubit = CategoriesCubit.get(mainContext)..getCategories(keywordSearch: "", pageSize: 20);

  CoursesCubit coursesCubit = CoursesCubit.get(mainContext)
    ..baseCoursesEndpointsActions.baseCoursesMethodsActions.courseCategorySelectedId = null
    ..baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseAllowDownload =false
    ..baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseLock = false
    ..baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseHasCertificate = false;


  void pickImage() async {
    final pickedImage = await ImagePickerWeb.getImageAsBytes();

    if (pickedImage != null) {
      coursesCubit.changeCourseImageSelected();
      imageUrl = pickedImage;
    }

  }

  showDialog(
      context: mainContext,
      barrierDismissible: false, // منع الإغلاق عند الضغط خارج النافذة
      builder: (BuildContext context) {
        TextEditingController titleController = TextEditingController();
        TextEditingController questionController = TextEditingController();
        TextEditingController answerController = TextEditingController();
        TextEditingController goalsController = TextEditingController();

        QuillController contentController = QuillController.basic();

        GlobalKey<FormState> formKey = GlobalKey<FormState>();

        CoursesCubit courseCubit = CoursesCubit.get(mainContext);

        if(course != null){
          titleController.text = course.title ?? "";
          questionController.text = course.question?? "";
          answerController.text = course.answer?? "";
          goalsController.text = "${course.goals ?? ""}";
          if(course.description != null && course.description!.isNotEmpty){
            contentController.document = Document.fromJson(jsonDecode(course.description ?? ''));
          }

          courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.courseCategorySelectedId = course.categoryId;

          coursesCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseAllowDownload = course.allowDownload ?? false;
          coursesCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseLock = course.isLocked ?? false;
          coursesCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseHasCertificate = course.hasCertificate ?? false;
        }

        void submit() {
          // add
          if(course == null){

            // edit
          }else{

          }
          Navigator.of(context).pop();
        }

        return AlertDialog(
          backgroundColor: Colors.white,
          title: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close)),
                  Expanded(child: Text(textAlign: TextAlign.end, course == null ? "إضافة كورس جديد" : course.title ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)),
                ],
              )
          ),
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getAppTextField(text: "عنوان الكورس", onChange: (value){}, validator: (value){
                      if(value == null || value.toString().isEmpty){
                        return "يجب أن تدخل اسم الكورس";
                      }
                    }, controller: titleController, fillColor: Color(appColorGrey), obscureText: false,
                      direction: TextDirection.rtl, suffixIconButton: null,
                      onSubmitted:(value) => submit()
                    ),

                    const SizedBox(height: 15,),
                    const Divider(),

                    const Text("وصف الكورس", style: TextStyle(fontWeight: FontWeight.bold),),

                    QuillToolbar.simple(
                      configurations:
                      QuillSimpleToolbarConfigurations(
                          controller: contentController,
                          showDirection: true),
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.grey.withOpacity(0.2),
                      child: QuillEditor.basic(
                        configurations: QuillEditorConfigurations(
                          controller: contentController,
                          checkBoxReadOnly: false,
                          minHeight: 100,
                          padding: const EdgeInsetsDirectional.all(15),
                        ),
                      ),
                    ),

                    const Divider(),
                    const Text("صورة الكورس", style: TextStyle(fontWeight: FontWeight.bold),),
                    const SizedBox(height: 10,),
                    const SizedBox(height: 20),
                    getAppButton(color: Color(appColorGrey), textColor: Colors.black, text: "اختر صورة", onClick:  pickImage),
                    const SizedBox(height: 10,),
                    BlocBuilder<CoursesCubit, CoursesState>(
                      buildWhen: (previous, current) => current is ChangeCourseImageSelectedState,
                      builder: (context, state) {
                        if(state is ChangeCourseImageSelectedState){
                          return Image.memory(
                            imageUrl,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          );
                        }

                        if(course != null && course.imageUrl != null){
                          return Image.network(
                            course.imageUrl!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          );
                        }
                        return Container();
                      },
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Stack(
                        children: [
                          DropzoneView(
                            onCreated: (DropzoneViewController ctrl) => dropzoneViewController = ctrl,
                            onDropFile: (file) async {
                              final bytes = await dropzoneViewController.getFileData(file);
                              imageUrl = bytes;
                              courseCubit.changeCourseImageSelected();
                            },
                            // onHover: () => print('Zone Hover'),
                            // onLeave: () => print('Zone Leave'),
                          ),
                          const Center(
                            child: Text(
                              'أو اسخبها مباشرة',
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15,),
                    const Divider(),

                    BlocBuilder<CoursesCubit, CoursesState>(
                      buildWhen: (previous, current) => current is IsCourseHasCertificateState,
                    builder: (context, state) {
                      return InkWell(
                        onTap: () {
                          courseCubit.changeCourseHasCertificate();
                        },
                        child: Wrap(
                          children: [
                            Checkbox(
                            value: courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseHasCertificate,
                              activeColor: Colors.blueAccent,
                              onChanged: (value) {
                                courseCubit.changeCourseHasCertificate();
                              },
                            ),
                            const Text("هل هناك شهادة؟", style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                      );
                      },
                    ),

                    const SizedBox(height: 15,),
                    const Divider(),

                    getAppTextField(text: "سؤال", onChange: (value){}, validator: (value){
                      if(value == null || value.toString().isEmpty){
                        return "يجب أن تدخل سؤال الكورس";
                      }
                    }, controller: questionController, fillColor: Color(appColorGrey), obscureText: false,
                        direction: TextDirection.rtl, suffixIconButton: null,
                        onSubmitted:(value){}
                    ),

                    const SizedBox(height: 15,),
                    const Divider(),

                    getAppTextField(text: "جواب السؤال", onChange: (value){}, validator: (value){
                      if(value == null || value.toString().isEmpty){
                        return "يجب أن تدخل جواب سؤال الكورس";
                      }
                    }, controller: answerController, fillColor: Color(appColorGrey), obscureText: false,
                        direction: TextDirection.rtl, suffixIconButton: null,
                        onSubmitted:(value){}
                    ),

                    const SizedBox(height: 15,),
                    const Divider(),


                    BlocBuilder<CoursesCubit, CoursesState>(
                      buildWhen: (previous, current) => current is IsCourseAllowDownloadState,
                      builder: (context, state) {
                        return InkWell(
                          onTap: () {
                            courseCubit.changeCourseAllowDownload();
                          },
                          child: Wrap(
                            children: [
                              Checkbox(
                                value: courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseAllowDownload,
                                activeColor: Colors.blueAccent,
                                onChanged: (value) {
                                  courseCubit.changeCourseAllowDownload();
                                },
                              ),
                              const Text("السماح بالتنزيل", style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 15,),
                    const Divider(),

                    getAppTextField(text: "أهداف الكورس", onChange: (value){}, validator: (value){
                      if(value == null || value.toString().isEmpty){
                        return "يجب أن تدخل أهداف هذا الكورس";
                      }
                    }, controller: goalsController, fillColor: Color(appColorGrey), obscureText: false,
                        direction: TextDirection.rtl, suffixIconButton: null,
                        onSubmitted:(value){}
                    ),

                    const SizedBox(height: 15,),
                    const Divider(),

                    BlocBuilder<CoursesCubit, CoursesState>(
                      buildWhen: (previous, current) => current is IsCourseLockState,
                      builder: (context, state) {
                        return InkWell(
                          onTap: () {
                            courseCubit.changeCourseAllowLock();
                          },
                          child: Wrap(
                            children: [
                              Checkbox(
                                value: courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseLock,
                                activeColor: Colors.blueAccent,
                                onChanged: (value) {
                                  courseCubit.changeCourseAllowLock();
                                },
                              ),
                              const Text("هل الكورس مقفل", style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 15,),
                    const Divider(),


                    const Text("اختر صنفًا", style: TextStyle(fontWeight: FontWeight.bold),),
                    BlocBuilder<CategoriesCubit, CategoriesState>(
                    buildWhen: (previous, current) => current is GetCategoriesState,
                      builder: (context, state) {
                        if(state is !GetCategoriesState || ! state.isLoaded){
                          return const CircularProgressIndicator();
                        }

                        PaginationModel<CategoryModel>? catsPaginated = state.categoriesPaginated;
                        if(catsPaginated == null || catsPaginated.data.isEmpty){
                          return const Text("لا توجد أصناف");
                        }

                        return Wrap(
                          children: catsPaginated.data.map((category) => CategoryItemWidget(category: category, onTap: (){
                            coursesCubit.changeCourseCategorySelected(categoryIdSelected: category.id!);
                          },)).toList(),
                        );
                },
              ),


                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: getAppButton(color: Colors.transparent, textColor: Colors.black,
                          text: course == null ? "إضافة" : "حفظ التغييرات",
                          onClick: (){
                        if(formKey.currentState!.validate()){
                          submit();
                        }
                      }
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
