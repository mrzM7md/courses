import 'package:course_dashboard/core/values/colors.dart';
import 'package:course_dashboard/features/sections/categories/data/models/category_model.dart';
import 'package:course_dashboard/features/sections/posts/business/cubit_controller/posts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business/cubit_controller/posts_state.dart';

class PostCategoryItemWidget extends StatelessWidget {
  final CategoryModel category;
  final GestureTapCallback? onTap;

  const PostCategoryItemWidget(
      {super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: BlocBuilder<PostsCubit, PostsState>(
        buildWhen: (previous, current) => current is ChangePostCategorySelectedState,
        builder: (context, state) {
          Color color = PostsCubit.get(context).basePostsEndpointsActions.basePostsMethodsActions.postCategorySelectedId != category.id ? Color(appColorGrey) : Colors.lightBlue;
          if(state is ChangePostCategorySelectedState && state.selectedCategoryId == category.id){
            color = PostsCubit.get(context).basePostsEndpointsActions.basePostsMethodsActions.postCategorySelectedId == null ? Color(appColorGrey) : Colors.lightBlue;
          }

          return Container(
            margin: const EdgeInsetsDirectional.all(5),
            color: color,
            padding: const EdgeInsetsDirectional.all(8),
            child: Text(
              category.name, style: const TextStyle(color: Colors.black),),
          );
        },
      ),
    );
  }
}
