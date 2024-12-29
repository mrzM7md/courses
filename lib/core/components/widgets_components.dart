import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../values/images.dart';
import '../values/responsive_sizes.dart';
import '../values/screen_responsive_sizes.dart';
import '../values/style.dart';

List<Widget> appButtonAndSearchTextBoxWidgets({required BuildContext context, required String title, required TextEditingController searchController, required String labelText, required String hintText, required VoidCallback? onAddTap, required VoidCallback? Function(dynamic value) onSearchTap}) => [
  CupertinoButton(onPressed: onAddTap, child: Text(title)),
  SizedBox(
    width: isDesktopSize(context: context)
        ? MediaQuery.sizeOf(context).width / 4
        : isTabletSize(context: context)
        ? MediaQuery.sizeOf(context).width / 1.8
        : 100.w,
    child: TextField(
      onSubmitted: onSearchTap,
      controller: searchController,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: labelText,
          hintText: "مثال 'الرياضيات'",
          suffixIcon: IconButton(
              onPressed:(){
                onSearchTap(searchController.text);
              }, icon: const Icon(CupertinoIcons.search))),
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

TextFormField getAppTextField({
  required String text,
  required Function(dynamic value) onChange,
  required validator,
  required TextEditingController controller,
  required Color fillColor,
  required bool obscureText,
  required TextDirection? direction,
  ValueChanged? onSubmitted,
  TextInputType? inputType,
  bool readOnly = false,
  List<TextInputFormatter>? inputFormatters,
  required Widget? suffixIconButton,
}) =>
    TextFormField(
      textAlign: TextAlign.start,
      onChanged: (value) => onChange(value),
      controller: controller,
      textDirection: direction,
      style: getGlobalTextStyle(),
      obscureText: obscureText,
      keyboardType: inputType,
      validator: validator,
      readOnly: readOnly,
      inputFormatters: inputFormatters,
      // mouseCursor: MouseCursor.defer,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        // hintText: "",
        labelText: text,
        hintTextDirection: direction,
        suffixIcon: suffixIconButton,
        contentPadding: const EdgeInsetsDirectional.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        filled: true,
        fillColor: fillColor,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(19)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: fillColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: fillColor),
        ),
      ),
    );

Widget getAppButton(
    {required Color color,
      required Color textColor,
      required String text,
      required onClick,
      IconData? icon}) =>
    Row(
      children: [
        MaterialButton(
          onPressed: onClick,
          elevation: 0,
          color: color,
          height: 46,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 30),
          child: ConditionalBuilder(
            condition: icon == null,
            builder: (context) => Text(
              text,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            fallback: (context) {
              return Row(
                children: [
                  Icon(
                    icon,
                    color: textColor,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
