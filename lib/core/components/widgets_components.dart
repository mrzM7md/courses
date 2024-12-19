import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../values/images.dart';
import '../values/responsive_sizes.dart';
import '../values/screen_responsive_sizes.dart';

List<Widget> appButtonAndSearchTextBoxWidgets({required BuildContext context, required String title, required VoidCallback? onTap, required String labelText, required String hintText, required VoidCallback? onSubmit}) => [
  CupertinoButton(onPressed: onTap, child: const Text("إضافة صنف جديد")),
  SizedBox(
    width: isDesktopSize(context: context)
        ? MediaQuery.sizeOf(context).width / 4
        : isTabletSize(context: context)
        ? MediaQuery.sizeOf(context).width / 1.8
        : 100.w,
    child: TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: "البحث عن صنف",
          hintText: "مثال 'الرياضيات'",
          suffixIcon: IconButton(
              onPressed: onSubmit, icon: const Icon(CupertinoIcons.search))),
    ),
  ),
];

Widget appSuccessFailWidget({required BuildContext context, required bool isSuccess, required String message}) =>
    Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.h),
      color: isSuccess ? Colors.green : Colors.red,
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(0),
          ),
          Text(
            message,
            style: TextStyle(
                color: Colors.white,
                fontSize: smallFontSize(context: context)),
          ),
        ],
      ),
    );

DataColumn appDataColumnWidget({required BuildContext context, required String title}) => DataColumn(
  headingRowAlignment:
  MainAxisAlignment.center,
  label: Text(title,
      style: TextStyle(
          fontSize: smallFontSize(context: context),
          fontWeight: FontWeight.bold)),
);

DataCell appDataCellWidget({required BuildContext context, required String title}) =>
    DataCell(Align(
        alignment: Alignment.center,
        child: Text(title,
            style: TextStyle(
                fontSize: smallFontSize(context: context),
                fontWeight: FontWeight.bold))));

Widget appNoDataWidget() => Column(
      children: [
        Image.asset(
          noDataImage,
          height: 100,
          width: 100,
        ),
        const SizedBox(
          height: 10,
        ),
        const Text("لا توجد بيانات")
      ],
    );