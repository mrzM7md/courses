import 'package:course_dashboard/core/data/models/pagination_model.dart';
import 'package:course_dashboard/features/sections/categories/business/cubit_controller/categories_cubit.dart';
import 'package:course_dashboard/features/sections/categories/data/models/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/widgets_components.dart';
import '../../../../core/values/colors.dart';
import '../../../../core/values/responsive_sizes.dart';
import '../../../../core/values/screen_responsive_sizes.dart';

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({super.key});

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  late CategoriesCubit categoryCubit;
  @override
  void initState() {
    super.initState();
    categoryCubit = CategoriesCubit.get(context)..getCategories(keywordSearch: "");
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
                  children:
                  appButtonAndSearchTextBoxWidgets(context: context, title: "إضافة صنف جديد", onTap: (){}, labelText: "بحث عن ضنف", hintText: "إضافة صنف جديد", onSubmit: (){}),
                )
                    : Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.center,
                  children:
                  appButtonAndSearchTextBoxWidgets(context: context, title: "إضافة صنف جديد", onTap: (){}, labelText: "بحث عن ضنف", hintText: "إضافة صنف جديد", onSubmit: (){}),
                ),
                SizedBox(
                  height:
                  smallVerticalPadding(context: context),
                ),
                Container(
                  alignment: AlignmentDirectional.topStart,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.all(
                          smallVerticalPadding(
                              context: context)),
                      child: BlocBuilder<CategoriesCubit, CategoriesState>(
                        buildWhen: (previous, current) => current is GetCategoriesState,
                        builder: (context, state) {
                          if(state is ! GetCategoriesState || ! state.isLoaded){
                            return const CircularProgressIndicator();
                          }

                          if(! state.isSuccess){
                            if(state.statusCode == 404){
                              return appNoDataWidget();
                            }
                            return ElevatedButton(onPressed: (){
                              categoryCubit.getCategories(keywordSearch: "");
                            }, child: Text("${state.message}: إعادة المحاولة", style: const TextStyle(color: Colors.redAccent),));
                          }

                          PaginationModel<CategoryModel> data = state.pagination!;

                          if(data.data.isEmpty){
                            return appNoDataWidget();
                          }

                          return DataTable(
                          // headingRowColor: WidgetStatePropertyAll(Colors.red),
                          dividerThickness: 0,
                          columnSpacing: 10,
                          dataRowColor: WidgetStateProperty.all(Colors.white),
                          columns: <DataColumn>[
                            appDataColumnWidget(
                                context: context, title: "خيارات"),
                            appDataColumnWidget(
                                context: context, title: "        "),
                            appDataColumnWidget(
                                context: context, title: "المعرف"),
                            appDataColumnWidget(
                                context: context, title: "الاسم"),
                          ],
                          rows: List<DataRow>.generate(
                            data.data.length,
                            (index) => DataRow(
                              color: const WidgetStatePropertyAll(
                                Colors.white),
                            // color: WidgetStatePropertyAll(Colors.red),
                            cells: <DataCell>[
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(onPressed: (){}, icon: Icon(Icons.edit),),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.delete),),
                                  ],
                                ),
                              ),
                              appDataCellWidget(context: context, title: ""),
                              appDataCellWidget(context: context, title: "${data.data[index].id}"),
                              appDataCellWidget(context: context, title: data.data[index].name),
                            ],
                          ),
                        ),
                      );
  },
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
        ),
      );
  }
}
