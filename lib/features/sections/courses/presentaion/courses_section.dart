import 'package:course_dashboard/core/data/models/pagination_model.dart';
import 'package:course_dashboard/core/dialogs/delete_dialog.dart';
import 'package:course_dashboard/core/enums/operations_enum.dart';
import 'package:course_dashboard/features/business/app_cubit.dart';
import 'package:course_dashboard/features/sections/categories/business/cubit_controller/categories_cubit.dart';
import 'package:course_dashboard/features/sections/categories/data/models/category_model.dart';
import 'package:course_dashboard/features/sections/categories/presentaion/dialogs/category_dialog.dart';
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
  late AppCubit appCubit;
  late TextEditingController searchController;

  int? pageNumber, totalPages;

  @override
  void initState() {
    super.initState();
    categoryCubit = CategoriesCubit.get(context)..getCategories(keywordSearch: "");
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
            horizontal: smallHorizontalPadding(context: context)),
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
              BlocConsumer<CategoriesCubit, CategoriesState>(
                buildWhen: (previous, current) => current is AddEditDeleteCategoryState && current.operation == OperationsEnum.ADD,
                listenWhen: (previous, current) => current is AddEditDeleteCategoryState && current.operation == OperationsEnum.ADD,
                listener: (context, state) {
                  if(state is AddEditDeleteCategoryState && state.isLoaded){
                    if(state.isSuccess){
                      appCubit.runAnOption(operations: OperationsEnum.SUCCESS, successMessage: state.message);
                    } else {
                      appCubit.runAnOption(operations: OperationsEnum.FAIL, successMessage: state.message);
                    }
                  }
                },
                builder: (context, state) {
                  if(state is AddEditDeleteCategoryState && ! state.isLoaded){
                    return const CircularProgressIndicator();
                  }
                  return SizedBox(
                    child: !(isMobileSize(context: context) || isTabletSize(context: context))
                        ? Row(children: addButtonWithSearchTextBox(),)
                        : Column(crossAxisAlignment: CrossAxisAlignment.center, children: addButtonWithSearchTextBox()),
                  );
                },
              ),
              SizedBox(
                height:
                smallVerticalPadding(context: context),
              ),
              Container(
                alignment: AlignmentDirectional.topStart,
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
                    PaginationModel<CategoryModel> data = state.categoriesPaginated!;

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
                                            BlocConsumer<CategoriesCubit, CategoriesState>(
                                              buildWhen: (previous, current) => current is AddEditDeleteCategoryState && current.categoryId == data.data[index].id && current.operation == OperationsEnum.EDIT,
                                              listenWhen: (previous, current) => current is AddEditDeleteCategoryState && current.isLoaded && current.categoryId == data.data[index].id && current.operation == OperationsEnum.EDIT,
                                              listener: (context, state) {
                                                if(state is AddEditDeleteCategoryState && state.isLoaded){
                                                  if(state.isSuccess){
                                                    appCubit.runAnOption(operations: OperationsEnum.SUCCESS, successMessage: state.message);
                                                  } else {
                                                    appCubit.runAnOption(operations: OperationsEnum.FAIL, successMessage: state.message);
                                                  }
                                                }
                                              },
                                              builder: (context, state) {
                                                if (state is AddEditDeleteCategoryState && ! state.isLoaded) {
                                                  return const CircularProgressIndicator();
                                                }

                                                return IconButton(onPressed: (){
                                                  categoryDialog(context, data.data[index]);
                                                }, icon: const Icon(Icons.edit),);
                                              },
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),

                                            BlocConsumer<CategoriesCubit, CategoriesState>(
                                              buildWhen: (previous, current) => current is AddEditDeleteCategoryState && current.categoryId == data.data[index].id && current.operation == OperationsEnum.DELETE,
                                              listenWhen: (previous, current) => current is AddEditDeleteCategoryState && current.isLoaded && current.categoryId == data.data[index].id && current.operation == OperationsEnum.DELETE,
                                              listener: (context, state) {
                                                if(state is AddEditDeleteCategoryState && state.isLoaded){
                                                  if(state.isSuccess){
                                                    appCubit.runAnOption(operations: OperationsEnum.SUCCESS, successMessage: state.message);
                                                  } else {
                                                    appCubit.runAnOption(operations: OperationsEnum.FAIL, successMessage: state.message);
                                                  }
                                                }
                                              },
                                              builder: (context, state) {
                                                if(state is AddEditDeleteCategoryState && ! state.isLoaded){
                                                  return const CircularProgressIndicator();
                                                }

                                                return IconButton(onPressed: (){
                                                  deleteDialog(context: context, title: "حذف صنف", description: data.data[index].name, onClick: (){
                                                    categoryCubit.deleteCategory(categoryId: data.data[index].id!);
                                                  });
                                                }, icon: const Icon(CupertinoIcons.delete),);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      appDataCellWidget(context: context, title: ""),
                                      appDataCellWidget(context: context, title: "${data.data[index].id}"),
                                      appDataCellWidget(context: context, title: data.data[index].name),
                                    ],
                                  ),
                                ),
                              ),
                            )),
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
                                      categoryCubit.getCategories(keywordSearch: searchController.text, pageNumber: data.currentPage + 1);
                                    },
                                  ),
                                  Text('${data.totalPages} / ${data.currentPage}  الصفحة'),
                                  data.currentPage == 1 ? Container() : IconButton(
                                    icon: const Icon(Icons.arrow_forward),
                                    onPressed: () {
                                      categoryCubit.getCategories(keywordSearch: searchController.text, pageNumber: data.currentPage - 1);
                                    },
                                  ),
                                ],
                              )
                          ),
                        ),
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
      appButtonAndSearchTextBoxWidgets(context: context, title: "إضافة صنف جديد", searchController: searchController, labelText: "بحث عن ضنف", hintText: "إضافة صنف جديد", onSearchTap: (v){
        categoryCubit.getCategories(keywordSearch: searchController.text);
      }, onAddTap: (){
        categoryDialog(context, null);
      }
      );

}
