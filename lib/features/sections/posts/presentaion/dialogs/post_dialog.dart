import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_dashboard/core/values/colors.dart';
import 'package:course_dashboard/features/sections/posts/business/cubit_controller/posts_state.dart';
import 'package:course_dashboard/features/sections/posts/data/models/add_edit_post_model.dart';
import 'package:course_dashboard/features/sections/posts/presentaion/widgets/post_category_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker_web/image_picker_web.dart';

import '../../../../../core/components/widgets_components.dart';
import '../../../../../core/data/models/pagination_model.dart';
import '../../../../../core/dialogs/delete_dialog.dart';
import '../../../../../core/values/images.dart';

import 'dart:typed_data';

import '../../../categories/business/cubit_controller/categories_cubit.dart';
import '../../../categories/data/models/category_model.dart';
import '../../business/cubit_controller/posts_cubit.dart';
import '../../data/models/post_model.dart';

postDialog(BuildContext mainContext, PostModel? post) {
  Uint8List? imageUrl;

  late DropzoneViewController dropzoneViewController;

  CategoriesCubit.get(mainContext).getCategories(keywordSearch: "", pageSize: 20);

  PostsCubit postCubit = PostsCubit.get(mainContext)
    ..basePostsEndpointsActions.basePostsMethodsActions.postCategorySelectedId = null;


  void pickImage() async {
    Uint8List? pickedImage = await ImagePickerWeb.getImageAsBytes();

    if (pickedImage != null) {
      postCubit.changePostImageSelected();
      imageUrl = pickedImage;
    }
  }


  showDialog(
      context: mainContext,
      barrierDismissible: false, // منع الإغلاق عند الضغط خارج النافذة
      builder: (BuildContext context) {
        TextEditingController titleController = TextEditingController();

        QuillController descriptionController = QuillController.basic()..formatSelection(Attribute.rtl);

        GlobalKey<FormState> formKey = GlobalKey<FormState>();

        PostsCubit postCubit = PostsCubit.get(mainContext);

        if(post != null){


          titleController.text = post.title ?? "";
          if(post.description != null && post.description!.isNotEmpty){
            try {
              // محاولة تعيين المستند من JSON
              descriptionController.document = Document.fromJson(jsonDecode(post.description ?? ''));
            } catch (e) {
              // إذا كانت هناك مشكلة (مثلاً النص العادي) قم بتحويل النص العادي إلى مستند Quill
              descriptionController.document = Document()..insert(0, post.description ?? '');
              descriptionController.formatSelection(Attribute.rtl);
            }
          }

          postCubit.basePostsEndpointsActions.basePostsMethodsActions.postCategorySelectedId = post.categoryId;
        }

        void submit() {
          // add
          if(post == null){
            postCubit.addPost(addEditPostModel: AddEditPostModel(
              id: null,
              title: titleController.text,
              description: jsonEncode(descriptionController.document.toDelta()),
              categoryId: postCubit.basePostsEndpointsActions.basePostsMethodsActions.postCategorySelectedId ?? -1,
            ),
                fileBytes: imageUrl
            );
          }
          // edit
          else{
            postCubit.updatePost(addEditPostModel: AddEditPostModel(
              id: post.id,
              title: titleController.text,
              description: jsonEncode(descriptionController.document.toDelta()),
              categoryId: postCubit.basePostsEndpointsActions.basePostsMethodsActions.postCategorySelectedId ?? -1,
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
                  BlocBuilder<PostsCubit, PostsState>(
                    buildWhen: (previous, current) => current is AddEditDeletePostState,
                    builder: (context, state) {
                      if(state is AddEditDeletePostState && ! state.isLoaded){
                        return const CircularProgressIndicator();
                      }

                      return IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close));
                    },
                  ),
                  Expanded(child: Text(textAlign: TextAlign.end, post == null ? "إضافة منشور جديد" : post.title ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)),
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
                    getAppTextField(text: "عنوان المنشور", onChange: (value){}, validator: (value){
                      if(value == null || value.toString().isEmpty){
                        return "يجب أن تدخل اسم المنشور";
                      }
                    }, controller: titleController, fillColor: Color(appColorGrey), obscureText: false,
                        direction: TextDirection.rtl, suffixIconButton: null,
                        onSubmitted:(value) {}
                    ),

                    const SizedBox(height: 15,),
                    const Divider(),

                    const Text("وصف المنشور", style: TextStyle(fontWeight: FontWeight.bold),),

                    QuillToolbar.simple(
                      configurations:
                      QuillSimpleToolbarConfigurations(
                          controller: descriptionController,
                          showDirection: true),
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.grey.withOpacity(0.2),
                      child: QuillEditor.basic(
                        configurations: QuillEditorConfigurations(
                          controller: descriptionController,
                          checkBoxReadOnly: false,
                          minHeight: 100,
                          padding: const EdgeInsetsDirectional.all(15),
                        ),
                      ),
                    ),

                    const Divider(),
                    const Text("صورة المنشور", style: TextStyle(fontWeight: FontWeight.bold),),
                    const SizedBox(height: 10,),
                    const SizedBox(height: 20),
                    getAppButton(color: Color(appColorGrey), textColor: Colors.black, text: "اختر صورة", onClick:  pickImage),
                    const SizedBox(height: 10,),
                    BlocBuilder<PostsCubit, PostsState>(
                      buildWhen: (previous, current) => current is ChangePostImageSelectedState,
                      builder: (context, state) {
                        if(state is ChangePostImageSelectedState){
                          return Image.memory(
                            imageUrl!,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          );
                        }

                        if(post != null && post.imageUrl != null){
                          return CachedNetworkImage(
                            width: 200,
                            height: 200,
                            imageUrl: '${post.imageUrl}',
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
                              postCubit.changePostImageSelected();
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
                          children: catsPaginated.data.map((category) => PostCategoryItemWidget(category: category, onTap: (){
                            postCubit.changePostCategorySelected(categoryIdSelected: category.id!);
                          },)).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 50,),

                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: BlocConsumer<PostsCubit, PostsState>(
                          buildWhen: (previous, current) => current is AddEditDeletePostState,
                          listenWhen: (previous, current) => current is AddEditDeletePostState,
                          builder: (context, state) {
                            if(state is AddEditDeletePostState && ! state.isLoaded){
                              return const CircularProgressIndicator();
                            }
                            return getAppButton(color: Colors.transparent, textColor: Colors.black,
                                text: post == null ? "إضافة" : "حفظ التغييرات",
                                onClick: (){
                                  if(formKey.currentState!.validate()){
                                    if(post == null){
                                      if(imageUrl == null){
                                        getToast(message: "يجب أن تدخل صورة", isSuccess: false);
                                        return;
                                      }
                                      if(descriptionController.document.isEmpty()){
                                        getToast(message: "يجب أن تدخل وصف", isSuccess: false);
                                        return;
                                      }
                                      if(postCubit.basePostsEndpointsActions.basePostsMethodsActions.postCategorySelectedId == null){
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
                            if(state is AddEditDeletePostState && state.isLoaded) {
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
