import 'package:course_dashboard/core/values/colors.dart';
import 'package:course_dashboard/features/sections/categories/business/cubit_controller/categories_cubit.dart';
import 'package:course_dashboard/features/sections/categories/data/models/category_model.dart';
import 'package:flutter/material.dart';

import '../../../../../core/components/widgets_components.dart';

categoryDialog(BuildContext mainContext, CategoryModel? category) {
  showDialog(
      context: mainContext,
      barrierDismissible: false, // منع الإغلاق عند الضغط خارج النافذة
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();
        GlobalKey<FormState> formKey = GlobalKey<FormState>();

        CategoriesCubit categoryCubit = CategoriesCubit.get(mainContext);

        if(category != null){

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
                  Expanded(child: Text(textAlign: TextAlign.end, category == null ? "عملية شراء جديدة" : category.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)),
                ],
              )
          ),
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    getAppTextField(text: "إسم الصنف", onChange: (value){}, validator: (value){
                      if(value == null || value.toString().isEmpty){
                        return "يجب أن تدخل اسم الصنف";
                      }
                    }, controller: nameController, fillColor: Color(appColorGrey), obscureText: false, direction: TextDirection.rtl, suffixIconButton: null,),

                    const SizedBox(height: 5,),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: getAppButton(color: Colors.transparent, textColor: Colors.black, text: "إضافة", onClick: (){
                        if(formKey.currentState!.validate()){
                          // submit();
                          categoryCubit.addCategory(categoryModel: CategoryModel(name: nameController.text.trim(), id: null));
                          Navigator.of(context).pop();
                        }
                      }
                    )

                      // getAppButton(
                      //   text: category == null ? "إضافة" : "حفظ التغييرات",
                      //   color: AppColors.appLightBlueColor,
                      //   textColor: Colors.black, onClick: (){
                      //   if(formKey.currentState!.validate()){
                      //     // submit();
                      //     Navigator.of(context).pop();
                      //   }},
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
