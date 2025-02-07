import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:course_dashboard/core/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../values/images.dart';
import '../values/responsive_sizes.dart';
import '../values/screen_responsive_sizes.dart';
import '../values/style.dart';


Widget appButton({required BuildContext context, required String title, required IconData? icon, required VoidCallback? onAddTap,}) => CupertinoButton(
    color: Color(appBlueColor),
    borderRadius: BorderRadius.circular(10),
    padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 10, vertical: 5),
    onPressed: onAddTap,
    child: Row(
      children: [
        Icon(icon, color: Colors.white,),
        Text(title, style: TextStyle(fontSize: mediumFontSize(context: context)),),
      ],
    ));


List<Widget> appButtonAndSearchTextBoxWidgets(
        {required BuildContext context,
        required String title,
        required TextEditingController searchController,
        required String labelText,
        required String hintText,
        required VoidCallback? onAddTap,
        required VoidCallback? Function(dynamic value) onSearchTap}) =>
    [
      Padding(
        padding: EdgeInsetsDirectional.only(start: 15, end: 5, bottom: isMobileSize(context: context) || isTabletSize(context: context) ? 5 : 0),
        child: appButton(context: context, title: title, icon: Icons.add, onAddTap: onAddTap)
      ),
      Padding(
        padding: EdgeInsetsDirectional.only(start: 15, end: 5, bottom: isMobileSize(context: context) || isTabletSize(context: context) ? 5 : 0),
        child: SizedBox(
          width: isDesktopSize(context: context)
              ? MediaQuery.sizeOf(context).width / 4
              : double.infinity,
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
                    onPressed: () {
                      onSearchTap(searchController.text);
                    },
                    icon: const Icon(CupertinoIcons.search))),
          ),
        ),
      ),
    ];

Widget appSuccessFailWidget(
        {required BuildContext context,
        required bool isSuccess,
        required String message,
        required VoidCallback? onClose
        }) =>
    Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.h),
      color: isSuccess ? Colors.green : Colors.redAccent,
      child: Row(
        children: [
          IconButton(
            onPressed: onClose,
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(0),
          ),
          Text(
            message,
            style: TextStyle(
                color: Colors.white, fontSize: smallFontSize(context: context)),
          ),
        ],
      ),
    );

DataColumn appDataColumnWidget(
        {required BuildContext context, required String title, Color textColor = Colors.black}) =>
    DataColumn(
      headingRowAlignment: MainAxisAlignment.center,
      label: Text(title,
          style: TextStyle(
            color: textColor,
              fontSize: smallFontSize(context: context),
              fontWeight: FontWeight.bold)),
    );

DataCell appDataCellWidget(
        {required BuildContext context, required String title}) =>
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
