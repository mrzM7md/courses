import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_dashboard/core/values/responsive_sizes.dart';
import 'package:course_dashboard/features/sections/courses/data/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../../../../core/values/images.dart';

courseDetailDialog(BuildContext mainContext, CourseModel course) {
  showDialog(
      context: mainContext,
      barrierDismissible: false, // منع الإغلاق عند الضغط خارج النافذة
      builder: (BuildContext context) {

        TextEditingController titleController = TextEditingController();
        TextEditingController questionController = TextEditingController();
        TextEditingController answerController = TextEditingController();
        TextEditingController goalsController = TextEditingController();

        QuillController contentController = QuillController(
            readOnly: true,
            document: Document.fromJson(jsonDecode(course.description ?? ""),
            ), selection: const TextSelection.collapsed(offset: 0)
        );

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

        StringBuffer unitsText = StringBuffer("");
        if(course.units!.isNotEmpty) {
          for (int i = 0; i < course.goals!.length; i++) {
            if (i == course.units!.length - 1) {
              unitsText.write("${course.units![i].name}");
              break;
            }
            unitsText.write("${course.units![i].name} - ");
          }
        }

        StringBuffer lessonsText = StringBuffer("");
        if(course.lessons!.isNotEmpty) {
          for (int i = 0; i < course.lessons!.length; i++) {
            if (i == course.lessons!.length - 1) {
              lessonsText.write("${course.lessons![i].name}");
              break;
            }
            lessonsText.write("${course.lessons![i].name} - ");
          }
        }

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
                    Text("$unitsText", style: TextStyle(fontSize:smallFontSize(context: context) )),

                    const Divider(),
                    Text("الدروس", style: TextStyle(fontSize:mediumFontSize(context: context) )),
                    Text("$lessonsText", style: TextStyle(fontSize:smallFontSize(context: context) )),


                  ],
                ),
              ),
            ),
          ),
        );
      });
}
