import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                    child: DataTable(
                      // headingRowColor: WidgetStatePropertyAll(Colors.red),
                      dividerThickness: 0,
                      columnSpacing: 100,
                      dataRowColor: WidgetStateProperty.all(
                          Colors.white),
                      columns: <DataColumn>[
                        appDataColumnWidget(context: context, title: "خيارات"),
                        appDataColumnWidget(context: context, title: "الاسم"),
                        appDataColumnWidget(context: context, title: "الصنف"),
                        appDataColumnWidget(context: context, title: "تاريخ الإنشاء"),
                      ],
                      rows: List<DataRow>.generate(
                        100,
                            (index) => DataRow(
                          color: WidgetStatePropertyAll(
                              Colors.white),
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
                            appDataCellWidget(context: context, title: "محمد أحمد سعيد"),
                            appDataCellWidget(context: context, title: "الكهربائيات"),
                            appDataCellWidget(context: context, title: "1 - 1 - 2024"),
                          ],
                        ),
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
      ),
    );
  }
}
