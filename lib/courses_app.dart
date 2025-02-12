import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'core/routes/router.dart';

class CoursesApp extends StatelessWidget {
  const CoursesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Courses Dashboard App",
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
          fontFamily: "Amiri",
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(color: Colors.black),
    ));
  }
}
