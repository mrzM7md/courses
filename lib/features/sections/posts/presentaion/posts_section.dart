import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:course_dashboard/core/data/models/pagination_model.dart';
import 'package:course_dashboard/core/dialogs/delete_dialog.dart';
import 'package:course_dashboard/core/enums/operations_enum.dart';
import 'package:course_dashboard/core/values/images.dart';
import 'package:course_dashboard/features/business/app_cubit.dart';
import 'package:course_dashboard/features/sections/posts/business/cubit_controller/posts_cubit.dart';
import 'package:course_dashboard/features/sections/posts/business/cubit_controller/posts_state.dart';
import 'package:course_dashboard/features/sections/posts/data/models/post_model.dart';
import 'package:course_dashboard/features/sections/posts/presentaion/dialogs/post_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/widgets_components.dart';
import '../../../../core/values/colors.dart';
import '../../../../core/values/responsive_sizes.dart';
import '../../../../core/values/screen_responsive_sizes.dart';

class PostsSection extends StatefulWidget {
  const PostsSection({super.key});


  @override
  State<PostsSection> createState() => _PostsSectionState();
}

class _PostsSectionState extends State<PostsSection> {
  late TextEditingController searchController;
  late PostsCubit postCubit;
  late AppCubit appCubit;

  @override
  void initState() {
    super.initState();
    postCubit = PostsCubit.get(context)..getPosts(keywordSearch: "") ;
    appCubit = AppCubit.get(context);
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Color(appColorLightYellow),
        padding: EdgeInsetsDirectional.symmetric(
            vertical: smallVerticalPadding(context: context),
            horizontal:
            smallHorizontalPadding(context: context)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SizedBox(
                height:
                smallVerticalPadding(context: context),
              ),
              BlocListener<PostsCubit, PostsState>(
                listenWhen: (previous, current) => current is AddEditDeletePostState && current.isLoaded && current.operation == OperationsEnum.ADD,
                listener: (context, state) {
                  if(state is AddEditDeletePostState){
                    if(state.isSuccess){
                      appCubit.runAnOption(operations: OperationsEnum.SUCCESS, successMessage: state.message);
                    } else {
                      appCubit.runAnOption(operations: OperationsEnum.FAIL, errorMessage: state.message);
                    }
                  }
                },
                child: SizedBox(
                  child: !(isMobileSize(context: context) ||
                      isTabletSize(context: context))
                      ? Row(
                      children: addButtonWithSearchTextBox()
                  )
                      : Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: addButtonWithSearchTextBox()
                  ),
                ),
              ),
              SizedBox(
                height:
                smallVerticalPadding(context: context),
              ),
              Container(
                alignment: AlignmentDirectional.topStart,
                child: BlocBuilder<PostsCubit, PostsState>(
                  buildWhen: (previous, current) => current is GetPostsState,
                  builder: (context, state) {
                    if(state is ! GetPostsState || ! state.isLoaded){
                      return const CircularProgressIndicator();
                    }

                    if(! state.isSuccess){
                      if(state.statusCode == 404){
                        return appNoDataWidget();
                      }
                      return ElevatedButton(onPressed: (){
                        postCubit.getPosts(keywordSearch: "");
                      }, child: Text("${state.message}: إعادة المحاولة", style: const TextStyle(color: Colors.redAccent),));
                    }
                    PaginationModel<PostModel> data = state.postsPaginated!;

                    if(data.data.isEmpty){
                      return appNoDataWidget();
                    }


                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: EdgeInsets.all(
                                smallVerticalPadding(
                                    context: context)),
                            child: DataTable(
                              // headingRowColor: WidgetStatePropertyAll(Colors.red),
                              dividerThickness: 0,
                              // columnSpacing: 10,
                              dataRowColor: WidgetStateProperty.all(
                                  Colors.white),
                              columns: <DataColumn>[
                                appDataColumnWidget(context: context, title: "خيارات"),
                                appDataColumnWidget(context: context, title: "        "),
                                appDataColumnWidget(context: context, title: "المعرف"),
                                appDataColumnWidget(context: context, title: "صورة المنشور"),
                                appDataColumnWidget(context: context, title: "العنوان"),
                                appDataColumnWidget(context: context, title: "الصنف"),
                              ],
                              rows: List<DataRow>.generate(
                                data.data.length,
                                    (index) => DataRow(
                                  color: const WidgetStatePropertyAll(Colors.white),
                                  // color: WidgetStatePropertyAll(Colors.red),
                                  cells: <DataCell>[
                                    DataCell(
                                      Row(
                                        children: [
                                          BlocListener<PostsCubit, PostsState>(
                                            listenWhen: (previous, current) => current is AddEditDeletePostState && current.isLoaded && current.postId == data.data[index].id && current.operation == OperationsEnum.EDIT,
                                            listener: (context, state) {
                                              if(state is AddEditDeletePostState){
                                                if(state.isSuccess){
                                                  appCubit.runAnOption(operations: OperationsEnum.SUCCESS, successMessage: state.message);
                                                } else {
                                                  appCubit.runAnOption(operations: OperationsEnum.FAIL, errorMessage: state.message);
                                                }
                                              }
                                            },
                                            child: IconButton(onPressed: (){
                                               postDialog(context, data.data[index]);
                                            }, icon: const Icon(Icons.edit),),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          BlocConsumer<PostsCubit, PostsState>(
                                            buildWhen: (previous, current) => current is AddEditDeletePostState && current.postId == data.data[index].id && current.operation == OperationsEnum.DELETE,
                                            listenWhen: (previous, current) => current is AddEditDeletePostState && current.isLoaded && current.postId == data.data[index].id && current.operation == OperationsEnum.DELETE,
                                            listener: (context, state) {
                                              if(state is AddEditDeletePostState && state.isLoaded){
                                                if(state.isSuccess){
                                                  appCubit.runAnOption(operations: OperationsEnum.SUCCESS, successMessage: state.message);
                                                } else {
                                                  appCubit.runAnOption(operations: OperationsEnum.FAIL, errorMessage: state.message);
                                                }
                                              }
                                            },
                                            builder: (context, state) {
                                              return IconButton(onPressed: (){
                                                deleteDialog(context: context, title: "حذف منشور", description: data.data[index].title ?? "", onClick: (){
                                                  postCubit.deletePost(postId: data.data[index].id!);
                                                });
                                              }, icon: const Icon(CupertinoIcons.delete),);
                                            },
                                          ),
                                          // IconButton(onPressed: (){
                                          //   // postDetailDialog(context, data.data[index]);
                                          // }, icon: const Icon(CupertinoIcons.eye),),
                                        ],
                                      ),
                                    ),
                                    appDataCellWidget(context: context, title: ""),
                                    appDataCellWidget(context: context, title: "${data.data[index].id}"),
                                    DataCell(
                                      CachedNetworkImage(
                                        width: 35,
                                        height: 35,
                                        imageUrl: '${data.data[index].imageUrl}',
                                        placeholder: (context, url) =>  Image.asset(tempPictureImage),
                                        errorWidget: (context, url, error) => Image.asset(unAvailableFileImage),
                                      ),
                                    ),
                                    appDataCellWidget(context: context, title: "${data.data[index].title}"),
                                    appDataCellWidget(context: context, title: "${data.data[index].categoryName}"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  data.currentPage == data.totalPages ? Container() : IconButton(
                                    icon: const Icon(Icons.arrow_back),
                                    onPressed: () {
                                      postCubit.getPosts(keywordSearch: searchController.text, pageNumber: data.currentPage + 1);
                                    },
                                  ),
                                  Text('${data.totalPages} / ${data.currentPage}  الصفحة'),
                                  data.currentPage == 1 ? Container() : IconButton(
                                    icon: const Icon(Icons.arrow_forward),
                                    onPressed: () {
                                      postCubit.getPosts(keywordSearch: searchController.text, pageNumber: data.currentPage - 1);
                                    },
                                  ),
                                ],
                              )
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  List<Widget> addButtonWithSearchTextBox() =>
      appButtonAndSearchTextBoxWidgets(
          context: context, title: "إضافة منشور جديد", searchController: searchController, labelText: "بحث عن منشور", hintText: "إضافة منشور جديد", onSearchTap: (v){
        postCubit.getPosts(keywordSearch: searchController.text);
      }, onAddTap: (){
        postDialog(context, null);
        // postDialog(context, null);
      });
}
