import 'package:course_dashboard/core/values/screen_responsive_sizes.dart';
import 'package:course_dashboard/courses_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        return ScreenUtilInit(
          designSize:getScreenSize(context: context),
          child: const CoursesApp(),
        );
  }
}

