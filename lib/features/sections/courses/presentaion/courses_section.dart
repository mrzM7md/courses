import 'package:course_dashboard/core/values/images.dart';
import 'package:course_dashboard/features/sections/courses/business/cubit_controller/courses_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/components/widgets_components.dart';
import '../../../../core/values/colors.dart';
import '../../../../core/values/responsive_sizes.dart';
import '../../../../core/values/screen_responsive_sizes.dart';

class CoursesSection extends StatefulWidget {
  const CoursesSection({super.key});


  @override
  State<CoursesSection> createState() => _CoursesSectionState();
}

class _CoursesSectionState extends State<CoursesSection> {
  late TextEditingController searchController;
  late CoursesCubit coursesCubit;
  
  @override
  void initState() {
    super.initState();
    coursesCubit = CoursesCubit.get(context)..getCourses(keywordSearch: "") ;
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
              !(isMobileSize(context: context) ||
                  isTabletSize(context: context))
                  ? Row(
                children: addButtonWithSearchTextBox()
              )
                  : Column(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: addButtonWithSearchTextBox()
              ),
              SizedBox(
                height:
                smallVerticalPadding(context: context),
              ),
              Container(
                alignment: AlignmentDirectional.topStart,
                child: Column(
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
                            5,
                                (index) => DataRow(
                              color: WidgetStatePropertyAll(Colors.white),
                              // color: WidgetStatePropertyAll(Colors.red),
                              cells: <DataCell>[
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(onPressed: (){}, icon: Icon(Icons.edit),),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.delete),),
                                    ],
                                  ),
                                ),
                                appDataCellWidget(context: context, title: ""),
                                appDataCellWidget(context: context, title: "1"),
                                appDataCellWidget(context: context, title: "1 - 1 - 2024"),
                                appDataCellWidget(context: context, title: "1 - 1 - 2024"),
                                DataCell(
                                  Row(
                                    children: [
                                      Image.asset(lockImage, width: 30,),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Image.asset(downloadImage, width: 30,),
                                    ],
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
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {},
                            ),
                            Text('Page 1 / 22'),
                            IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  List<Widget> addButtonWithSearchTextBox() =>
      appButtonAndSearchTextBoxWidgets(context: context, title: "إضافة كورس جديد", searchController: searchController, labelText: "بحث عن كورس", hintText: "إضافة كورس جديد", onSearchTap: (v){
        // categoryCubit.getCategories(keywordSearch: searchController.text);
      }, onAddTap: (){
        // categoryDialog(context, null);
      });
}
