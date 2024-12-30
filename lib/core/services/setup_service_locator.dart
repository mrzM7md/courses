import 'package:course_dashboard/features/sections/categories/business/actions/endpoints_actions/base_categories_endpoints_actions.dart';
import 'package:course_dashboard/features/sections/categories/business/actions/endpoints_actions/categories_endpoints_actions.dart';
import 'package:course_dashboard/features/sections/courses/business/actions/endpoints_actions/courses_endpoints_actions.dart';
import 'package:course_dashboard/features/sections/courses/business/actions/methods_actions/courses_methods_actions.dart';
import 'package:course_dashboard/features/sections/posts/business/actions/endpoints_actions/posts_endpoints_actions.dart';
import 'package:course_dashboard/features/sections/posts/business/actions/methods_actions/posts_methods_actions.dart';
import 'package:course_dashboard/features/sections/surveys/business/actions/endpoints_actions/surveys_endpoints_actions.dart';
import 'package:course_dashboard/features/sections/surveys/business/actions/methods_actions/surveys_methods_actions.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

class SetupServiceLocator {
  void init() {
    // ####################### Start Categories - Infos #######################  ///
    sl.registerLazySingleton(() => CategoriesEndpointsActions());
    // ####################### End Categories - Infos #######################  ///

    // ####################### Start Courses - Base #######################  ///
    sl.registerLazySingleton(() => CoursesMethodsActions());
    sl.registerLazySingleton(() => CoursesEndpointsActions(
      baseCoursesMethodsActions: sl<CoursesMethodsActions>()
    ),);
    // ####################### End Courses - Base #######################  ///

    // ####################### Start Posts - Infos #######################  ///
    sl.registerLazySingleton(() => PostsMethodsActions());
    sl.registerLazySingleton(() => PostsEndpointsActions(basePostsMethodsActions: sl<PostsMethodsActions>()));
    // ####################### End Posts - Infos #######################  ///

    // ####################### Start Categories - Infos #######################  ///
    sl.registerLazySingleton(() => SurveysMethodsActions());
    sl.registerLazySingleton(() => SurveysEndpointsActions(baseSurveysMethodsActions: sl<SurveysMethodsActions>()));

    // ####################### End Categories - Infos #######################  ///



  }
}
