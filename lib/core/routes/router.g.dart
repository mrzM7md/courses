// This file is part of the 'router.dart' file

part of 'router.dart';

// This is a generated file by the GoRouterGenerator
// **************************************************************************
// GoRouterGenerator
// **************************************************************************
// Define a getter method for the app routes
List<RouteBase> get $appRoutes => [
  // Return a list of RouteBase objects, with the $shellRouteData object as the only element
  $shellRouteData,
];

// Define a getter method for the shell route data
RouteBase get $shellRouteData => GoRoute(
          path: '/',
          // name: AppRoutes.splashScreenRouter,
          builder: (context, state) {
            return $DashboardRouteExtension._fromState(state);
          }
      );



/// THIS EXTENSION IS FOR HELP YOU TO GET ANY METHODS OF EACH PAGE ROUTE


// Define an extension method for the DashboardRoute class
extension $DashboardRouteExtension on DashboardRoute {
  // Define a static method to create a DashboardRoute object from a state
  static DashboardPage _fromState(GoRouterState state) => const DashboardPage();

  String get location => GoRouteData.$location('/',);

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
