import 'package:course_dashboard/features/sections/categories/business/actions/endpoints_actions/base_categories_endpoints_actions.dart';
import 'package:course_dashboard/features/sections/categories/business/actions/endpoints_actions/categories_endpoints_actions.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

class SetupServiceLocator {
  void init() {
    /// ####################### Start Categories - Infos #######################  ///
    sl.registerLazySingleton(() => CategoriesEndpointsActions());
  }
}
