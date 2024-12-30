import 'package:bloc/bloc.dart';
import 'package:course_dashboard/core/services/setup_service_locator.dart';
import 'package:course_dashboard/core/values/screen_responsive_sizes.dart';
import 'package:course_dashboard/courses_app.dart';
import 'package:course_dashboard/features/sections/categories/business/actions/endpoints_actions/categories_endpoints_actions.dart';
import 'package:course_dashboard/features/sections/categories/business/cubit_controller/categories_cubit.dart';
import 'package:course_dashboard/features/sections/courses/business/actions/endpoints_actions/courses_endpoints_actions.dart';
import 'package:course_dashboard/features/sections/courses/business/cubit_controller/courses_cubit.dart';
import 'package:course_dashboard/features/sections/posts/business/actions/endpoints_actions/posts_endpoints_actions.dart';
import 'package:course_dashboard/features/sections/posts/business/cubit_controller/posts_cubit.dart';
import 'package:course_dashboard/features/sections/surveys/business/actions/endpoints_actions/surveys_endpoints_actions.dart';
import 'package:course_dashboard/features/sections/surveys/business/cubit_controller/surveys_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'block_observer.dart';

void main() {
  usePathUrlStrategy();

  Bloc.observer = MyBlocObserver();

  SetupServiceLocator().init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        return ScreenUtilInit(
          designSize:getScreenSize(context: context),
          child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => CategoriesCubit(baseCategoriesEndpointsActions: sl<CategoriesEndpointsActions>()),),
                BlocProvider(create: (context) => CoursesCubit(baseCoursesEndpointsActions: sl<CoursesEndpointsActions>()),),
                BlocProvider(create: (context) => PostsCubit(basePostsEndpointsActions: sl<PostsEndpointsActions>()),),
                BlocProvider(create: (context) => SurveysCubit(baseSurveysEndpointsActions: sl<SurveysEndpointsActions>()),),
              ],
              child: const CoursesApp()),
        );
  }
}

