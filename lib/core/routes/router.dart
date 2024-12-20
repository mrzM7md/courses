import 'package:course_dashboard/features/business/app_cubit.dart';
import 'package:course_dashboard/features/presentation/dashboard_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'router.g.dart';

// _rootNavigatorKey: This is a GlobalKey that is used to access the root navigator of the app.
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

// router: This is an instance of GoRouter that is used to manage navigation between different screens.
final router = GoRouter(
  routes: $appRoutes,
  // $appRoutes: This is a list of routes that are defined using the go_router package.
  debugLogDiagnostics: kDebugMode,
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
);

class DashboardRoute extends StatefulWidget {
  const DashboardRoute({super.key});

  @override
  State<DashboardRoute> createState() => _DashboardRouteState();
}

class _DashboardRouteState extends State<DashboardRoute> {
  @override
  Widget build(BuildContext context) {
    return const DashboardPage();
  }
}
