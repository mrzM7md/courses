import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:course_dashboard/core/data/models/pagination_model.dart';
import 'package:course_dashboard/core/enums/operations_enum.dart';
import 'package:course_dashboard/core/values/images.dart';
import 'package:course_dashboard/features/business/app_cubit.dart';
import 'package:course_dashboard/features/sections/courses/business/cubit_controller/courses_cubit.dart';
import 'package:course_dashboard/features/sections/courses/data/models/course_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/widgets_components.dart';
import '../../../../core/values/colors.dart';
import '../../../../core/values/responsive_sizes.dart';
import '../../../../core/values/screen_responsive_sizes.dart';
import 'dialogs/course_dialog.dart';

class CoursesSection extends StatefulWidget {
  const CoursesSection({super.key});


  @override
  State<CoursesSection> createState() => _CoursesSectionState();
}

class _CoursesSectionState extends State<CoursesSection> {
  late TextEditingController searchController;
  late CoursesCubit courseCubit;
  late AppCubit appCubit;

  @override
  void initState() {
    super.initState();
    courseCubit = CoursesCubit.get(context)..getCourses(keywordSearch: "") ;
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
              BlocConsumer<CoursesCubit, CoursesState>(
                listenWhen: (previous, current) => current is AddEditDeleteCourseState,
                listener: (context, state) {
                  if(state is AddEditDeleteCourseState && state.isLoaded){
                    if(state.isSuccess){
                      appCubit.runAnOption(operations: OperationsEnum.SUCCESS, successMessage: state.message);
                    } else {
                      appCubit.runAnOption(operations: OperationsEnum.FAIL, successMessage: state.message);
                    }
                  }
                },
                  builder: (context, state) {
                    return SizedBox(
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
              );
  },
),
              SizedBox(
                height:
                smallVerticalPadding(context: context),
              ),
              Container(
                alignment: AlignmentDirectional.topStart,
                child: BlocBuilder<CoursesCubit, CoursesState>(
                  buildWhen: (previous, current) => current is GetCoursesState,
                  builder: (context, state) {
                    if(state is ! GetCoursesState || ! state.isLoaded){
                      return const CircularProgressIndicator();
                    }

                    if(! state.isSuccess){
                      if(state.statusCode == 404){
                        return appNoDataWidget();
                      }
                      return ElevatedButton(onPressed: (){
                        courseCubit.getCourses(keywordSearch: "");
                      }, child: Text("${state.message}: إعادة المحاولة", style: const TextStyle(color: Colors.redAccent),));
                    }
                    PaginationModel<CourseModel> data = state.coursesPaginated!;

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
                                appDataColumnWidget(context: context, title: "صورة العنوان"),
                                appDataColumnWidget(context: context, title: "العنوان"),
                                appDataColumnWidget(context: context, title: "الحالات"),
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
                                      IconButton(onPressed: (){
                                        courseDialog(context, data.data[index]);
                                      }, icon: const Icon(Icons.edit),),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.delete),),
                                      IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.eye),),
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
                                ),                                appDataCellWidget(context: context, title: "${data.data[index].title}"),
                                DataCell(
                                  Row(
                                    children: [
                                      ConditionalBuilder(
                                          condition: data.data[index].isLocked ?? false,
                                          builder: (context) => Image.asset(lockImage, width: 20,),
                                          fallback: (context) => Container()),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      ConditionalBuilder(
                                          condition: data.data[index].allowDownload ?? false,
                                          builder: (context) => Image.asset(downloadImage, width: 20,),
                                          fallback: (context) => Container()),                                    ],
                                  ),
                                ),
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
                                  courseCubit.getCourses(keywordSearch: searchController.text, pageNumber: data.currentPage + 1);
                                },
                              ),
                              Text('${data.totalPages} / ${data.currentPage}  الصفحة'),
                              data.currentPage == 1 ? Container() : IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: () {
                                  courseCubit.getCourses(keywordSearch: searchController.text, pageNumber: data.currentPage - 1);
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
          context: context, title: "إضافة كورس جديد", searchController: searchController, labelText: "بحث عن كورس", hintText: "إضافة كورس جديد", onSearchTap: (v){
        courseCubit.getCourses(keywordSearch: searchController.text);
      }, onAddTap: (){
        courseDialog(context, null);
        // courseDialog(context, null);
      });
}
