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
          nameController.text = category.name;
        }

        void submit() {
          if(category == null){
            categoryCubit.addCategory(categoryModel: CategoryModel(name: nameController.text.trim(), id: null));
          }else{
            categoryCubit.updateCategory(categoryModel: CategoryModel(name: nameController.text.trim(), id: category.id));
          }
          Navigator.of(context).pop();
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
                  Expanded(child: Text(textAlign: TextAlign.end, category == null ? "إضافة صنف جديد" : category.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)),
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
                    getAppTextField(text: "اسم الصنف", onChange: (value){}, validator: (value){
                      if(value == null || value.toString().isEmpty){
                        return "يجب أن تدخل اسم الصنف";
                      }
                    }, controller: nameController, fillColor: Color(appColorGrey), obscureText: false,
                        direction: TextDirection.rtl, suffixIconButton: null,
                        onSubmitted:(value) => submit()
                    ),

                    const SizedBox(height: 5,),

                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: getAppButton(color: Colors.transparent, textColor: Colors.black,
                            text: category == null ? "إضافة" : "حفظ التغييرات",
                            onClick: (){
                              if(formKey.currentState!.validate()){
                                submit();
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
