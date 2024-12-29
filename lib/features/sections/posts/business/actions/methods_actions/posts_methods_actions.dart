import 'package:course_dashboard/features/sections/posts/business/actions/methods_actions/base_posts_methods_actions.dart';

class PostsMethodsActions implements BasePostsMethodsActions {
  int? _postCategorySelectedId;

  @override
  set postCategorySelectedId(int? value) => _postCategorySelectedId = value;

  @override
  int? get postCategorySelectedId => _postCategorySelectedId;
}