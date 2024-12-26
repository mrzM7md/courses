import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_dashboard/core/components/widgets_components.dart';
import 'package:course_dashboard/core/values/responsive_sizes.dart';
import 'package:course_dashboard/features/sections/courses/data/models/course_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../../../../core/values/images.dart';
import '../../sections/units/presentaion/dialogs/deleete_unit_dialog.dart';
import '../../sections/units/presentaion/dialogs/unit_dialog.dart';

courseDetailDialog(BuildContext mainContext, CourseModel course) {
  showDialog(
      context: mainContext,
      barrierDismissible: false, // منع الإغلاق عند الضغط خارج النافذة
      builder: (BuildContext context) {

        QuillController contentController = QuillController.basic()..formatSelection(Attribute.rtl);

        try {
          // محاولة تعيين المستند من JSON
          contentController = QuillController(
            readOnly: true,
            document: Document.fromJson(jsonDecode(course.description ?? "")),
            selection: const TextSelection.collapsed(offset: 0),
          );
        } catch (e) {
          // إذا كانت هناك مشكلة (مثلاً النص العادي) قم بتحويل النص العادي إلى مستند Quill
          contentController = QuillController(
            readOnly: true,
            document: Document()..insert(0, course.description ?? ''),
            selection: const TextSelection.collapsed(offset: 0),
          );
          contentController.formatSelection(Attribute.rtl);
        }

        // goals
        StringBuffer goalText = StringBuffer("");
        if(course.goals!.isNotEmpty) {
          for (int i = 0; i < course.goals!.length; i++) {
            if (i == course.goals!.length - 1) {
              goalText.write("${course.goals![i].name}");
              break;
            }
            goalText.write("${course.goals![i].name} - ");
          }
        }

        // // units
        // StringBuffer unitsText = StringBuffer("");
        // if(course.units!.isNotEmpty) {
        //   for (int i = 0; i < course.units!.length; i++) {
        //     if (i == course.units!.length - 1) {
        //       unitsText.write("${course.units![i].name}");
        //       break;
        //     }
        //     unitsText.write("${course.units![i].name} - ");
        //   }
        // }

        // // lessons
        // StringBuffer lessonsText = StringBuffer("");
        // if(course.lessons!.isNotEmpty) {
        //   for (int i = 0; i < course.lessons!.length; i++) {
        //     if (i == course.lessons!.length - 1) {
        //       lessonsText.write("${course.lessons![i].name}");
        //       break;
        //     }
        //     lessonsText.write("${course.lessons![i].name} - ");
        //   }
        // }

        return AlertDialog(
          backgroundColor: Colors.white,
          title: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close)),
                  const Expanded(child: Text(textAlign: TextAlign.end, "تفاصيل الكورس", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)),
                ],
              )
          ),
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: const EdgeInsetsDirectional.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("العنوان", style: TextStyle(fontSize:mediumFontSize(context: context) )),
                    Text("${course.title}", style: TextStyle(fontSize:smallFontSize(context: context) )),
                    const Divider(),
                    Text("الوصف", style: TextStyle(fontSize:mediumFontSize(context: context) )),
                    QuillEditor.basic(
                      configurations: QuillEditorConfigurations(
                        controller: contentController,
                        checkBoxReadOnly: true,
                        padding: const EdgeInsetsDirectional.all(15),
                      ),
                    ),
                    const Divider(),

                    Text("صورة الغلاف", style: TextStyle(fontSize: mediumFontSize(context: context) )),
                    CachedNetworkImage(
                      imageUrl: '${course.imageUrl}',
                      placeholder: (context, url) =>  Image.asset(tempPictureImage),
                      errorWidget: (context, url, error) => Image.asset(unAvailableFileImage),
                    ),

                    const Divider(),
                    Text("هل له شهادة؟", style: TextStyle(fontSize:mediumFontSize(context: context) )),
                    Text(course.hasCertificate! ? "نعم" : "لا", style: TextStyle(fontSize:smallFontSize(context: context) )),

                    const Divider(),
                    Text("سؤال", style: TextStyle(fontSize:mediumFontSize(context: context) )),
                    Text(course.question ?? "", style: TextStyle(fontSize:smallFontSize(context: context) )),

                    const Divider(),
                    Text("جواب", style: TextStyle(fontSize:mediumFontSize(context: context) )),
                    Text(course.answer ?? "", style: TextStyle(fontSize:smallFontSize(context: context) )),

                    const Divider(),
                    Text("اسم الصنف", style: TextStyle(fontSize:mediumFontSize(context: context) )),
                    Text(course.categoryName ?? "", style: TextStyle(fontSize:smallFontSize(context: context) )),

                    const Divider(),
                    Text("قابل للتنزيل؟", style: TextStyle(fontSize:mediumFontSize(context: context) )),
                    Text(course.allowDownload! ? "نعم" : "لا", style: TextStyle(fontSize:smallFontSize(context: context) )),

                    const Divider(),
                    Text("مقفل؟", style: TextStyle(fontSize:mediumFontSize(context: context) )),
                    Text(course.isLocked! ? "نعم" : "لا", style: TextStyle(fontSize:smallFontSize(context: context) )),

                    const Divider(),
                    Text("الأهداف", style: TextStyle(fontSize:mediumFontSize(context: context) )),
                    Text("$goalText", style: TextStyle(fontSize:smallFontSize(context: context) )),

                    const Divider(),
                    Text("الوحدات", style: TextStyle(fontSize:mediumFontSize(context: context) )),

                    CupertinoButton(onPressed: (){
                      Navigator.of(context).pop();
                      unitDialog(mainContext: mainContext, unit: null, course: course);
                    },
                        child: const Text("إضافة وحدة جديدة")),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        // headingRowColor: WidgetStatePropertyAll(Colors.red),
                        dividerThickness: 0,
                        columnSpacing: 100,
                        dataRowColor: WidgetStateProperty.all(
                            Colors.white),
                        columns: <DataColumn>[
                          appDataColumnWidget(context: context, title: "#"),
                          appDataColumnWidget(context: context, title: "خيارات"),
                          appDataColumnWidget(context: context, title: "اسم الوحدة"),
                          appDataColumnWidget(context: context, title: "الترتيب"),
                          appDataColumnWidget(context: context, title: "هل الوحدة مقفلة"),
                        ],
                        rows: List<DataRow>.generate(
                          course.units!.length,
                              (index) => DataRow(
                            color: const WidgetStatePropertyAll(
                                Colors.white),
                            // color: WidgetStatePropertyAll(Colors.red),
                            cells: <DataCell>[
                              appDataCellWidget(context: context, title: "${index+1}"),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(onPressed: (){
                                      Navigator.of(context).pop();
                                      unitDialog(mainContext: mainContext, unit: course.units![index], course: course);
                                    }, icon: const Icon(Icons.edit),),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(onPressed: (){
                                      Navigator.of(context).pop();
                                      deleteUnitDialog(baseContext: mainContext, unit: course.units![index], course: course);
                                   }, icon: const Icon(CupertinoIcons.delete),),
                                  ],
                                ),
                              ),
                              appDataCellWidget(context: context, title: "${course.units![index].name}"),
                              appDataCellWidget(context: context, title: "${course.units![index].order}"),
                              appDataCellWidget(context: context, title: course.units![index].isLocked! ? "نعم" : "لا"),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const Divider(),

                    CupertinoButton(onPressed: (){

                    },
                        child: const Text("وحدة جديدة")),
                  Text("الدروس", style: TextStyle(fontSize:mediumFontSize(context: context) )),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        // headingRowColor: WidgetStatePropertyAll(Colors.red),
                        dividerThickness: 0,
                        columnSpacing: 100,
                        dataRowColor: WidgetStateProperty.all(
                            Colors.white),
                        columns: <DataColumn>[
                          appDataColumnWidget(context: context, title: "#"),
                          appDataColumnWidget(context: context, title: " خيارات"),
                          appDataColumnWidget(context: context, title: "اسم الدرس"),
                          appDataColumnWidget(context: context, title: "الوحدة"),
                          appDataColumnWidget(context: context, title: "الترتيب"),
                          appDataColumnWidget(context: context, title: "هل الدرس مقفل"),
                        ],
                        rows: List<DataRow>.generate(
                          course.lessons!.length,
                              (index) => DataRow(
                            color: const WidgetStatePropertyAll(
                                Colors.white),
                            // color: WidgetStatePropertyAll(Colors.red),
                            cells: <DataCell>[
                              appDataCellWidget(context: context, title: "${index+1}"),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(onPressed: (){}, icon: const Icon(Icons.edit),),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.delete),),
                                  ],
                                ),
                              ),
                              appDataCellWidget(context: context, title: "${course.lessons![index].name}"),
                              appDataCellWidget(context: context, title: "${course.lessons![index].unitName}"),
                              appDataCellWidget(context: context, title: "${course.lessons![index].order}"),
                              appDataCellWidget(context: context, title: course.lessons![index].isLocked! ? "نعم" : "لا"),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
