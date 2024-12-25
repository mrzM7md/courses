import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_dashboard/core/data/models/pagination_model.dart';
import 'package:course_dashboard/core/values/colors.dart';
import 'package:course_dashboard/features/sections/categories/business/cubit_controller/categories_cubit.dart';
import 'package:course_dashboard/features/sections/categories/data/models/category_model.dart';
import 'package:course_dashboard/features/sections/courses/business/cubit_controller/courses_cubit.dart';
import 'package:course_dashboard/features/sections/courses/data/models/course_model.dart';
import 'package:course_dashboard/features/sections/courses/data/models/goal_model.dart';
import 'package:course_dashboard/features/sections/courses/presentaion/widgets/category_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker_web/image_picker_web.dart';

import '../../../../../core/components/widgets_components.dart';
import '../../../../../core/dialogs/delete_dialog.dart';
import '../../../../../core/values/images.dart';
import '../../data/models/add_course_model.dart';

import 'dart:typed_data';

courseDialog(BuildContext mainContext, CourseModel? course) {
  Uint8List? imageUrl;

  late DropzoneViewController dropzoneViewController;
  CategoriesCubit categoriesCubit = CategoriesCubit.get(mainContext)..getCategories(keywordSearch: "", pageSize: 20);

  CoursesCubit coursesCubit = CoursesCubit.get(mainContext)
    ..baseCoursesEndpointsActions.baseCoursesMethodsActions.courseCategorySelectedId = null
    ..baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseAllowDownload =false
    ..baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseLock = false
    ..baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseHasCertificate = false;


  void pickImage() async {
    Uint8List? pickedImage = await ImagePickerWeb.getImageAsBytes();

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
          StringBuffer goalText = StringBuffer("");
          if(course.goals!.isNotEmpty){
            for(int i = 0; i < course.goals!.length; i++){
              if(i == course.goals!.length - 1){
                goalText.write("${course.goals![i].name}");
                break;
              }
              goalText.write("${course.goals![i].name} - ");
            }
          }

          titleController.text = course.title ?? "";
          questionController.text = course.question?? "";
          answerController.text = course.answer?? "";
          goalsController.text = goalText.toString();
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
            courseCubit.addCourse(addEditCourseModel: AddEditCourseModel(
                id: null,
                title: titleController.text,
                description: jsonEncode(contentController.document.toDelta()),
                hasCertificate: courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseHasCertificate,
                question: questionController.text,
                answer: answerController.text,
                categoryId: courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.courseCategorySelectedId ?? -1,
                allowDownload: courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseAllowDownload,
                goals: goalsController.text,
                isLocked: courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseLock,
            ),
                fileBytes: imageUrl
            );
          }
          // edit
          else{
            courseCubit.updateCourse(addEditCourseModel: AddEditCourseModel(
            id: course.id,
            title: titleController.text,
            description: jsonEncode(contentController.document.toDelta()),
            hasCertificate: courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseHasCertificate,
            question: questionController.text,
            answer: answerController.text,
            categoryId: courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.courseCategorySelectedId ?? -1,
            allowDownload: courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseAllowDownload,
            goals: goalsController.text,
            isLocked: courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.isCourseLock,
            ),
              fileBytes: imageUrl
          );}
          // Navigator.of(context).pop();
        }


        return AlertDialog(
          backgroundColor: Colors.white,
          title: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  BlocBuilder<CoursesCubit, CoursesState>(
                    buildWhen: (previous, current) => current is AddEditDeleteCourseState,
                    builder: (context, state) {
                      if(state is AddEditDeleteCourseState && ! state.isLoaded){
                        return const CircularProgressIndicator();
                      }

                      return IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close));
  },
),
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
                      onSubmitted:(value) {}
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
                            imageUrl!,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          );
                        }

                        if(course != null && course.imageUrl != null){
                          return CachedNetworkImage(
                            width: 200,
                            height: 200,
                            imageUrl: '${course.imageUrl}',
                            placeholder: (context, url) =>  Image.asset(tempPictureImage),
                            errorWidget: (context, url, error) => Image.asset(unAvailableFileImage),
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

                    const SizedBox(height: 50,),

                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: BlocConsumer<CoursesCubit, CoursesState>(
                          buildWhen: (previous, current) => current is AddEditDeleteCourseState,
                          listenWhen: (previous, current) => current is AddEditDeleteCourseState,
                          builder: (context, state) {
                            if(state is AddEditDeleteCourseState && ! state.isLoaded){
                              return const CircularProgressIndicator();
                            }
                            return getAppButton(color: Colors.transparent, textColor: Colors.black,
                            text: course == null ? "إضافة" : "حفظ التغييرات",
                            onClick: (){
                              if(formKey.currentState!.validate()){
                                if(course == null){
                                  if(imageUrl == null){
                                    getToast(message: "يجب أن تدخل صورة", isSuccess: false);
                                    return;
                                  }
                                  if(contentController.document.isEmpty()){
                                    getToast(message: "يجب أن تدخل وصف", isSuccess: false);
                                    return;
                                  }
                                  if(courseCubit.baseCoursesEndpointsActions.baseCoursesMethodsActions.courseCategorySelectedId == null){
                                    getToast(message: "يجب أن تختار صنف", isSuccess: false);
                                    return;
                                  }
                                }
                                submit();
                              }
                            }
                        );
                            },
                          listener: (context, state) {
                            if(state is AddEditDeleteCourseState && state.isLoaded) {
                              if(! state.isSuccess) {
                                getToast(message: state.message, isSuccess: false);
                              } else{

                                Navigator.pop(context);
                              }
                            }
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
