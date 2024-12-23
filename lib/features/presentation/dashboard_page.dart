import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:course_dashboard/core/components/widgets_components.dart';
import 'package:course_dashboard/core/enums/dashboard_sections_enum.dart';
import 'package:course_dashboard/core/enums/operations_enum.dart';
import 'package:course_dashboard/core/values/responsive_sizes.dart';
import 'package:course_dashboard/core/values/screen_responsive_sizes.dart';
import 'package:course_dashboard/features/business/app_cubit.dart';
import 'package:course_dashboard/features/sections/categories/business/cubit_controller/categories_cubit.dart';
import 'package:course_dashboard/features/sections/categories/presentaion/categories_section.dart';
import 'package:course_dashboard/features/sections/courses/business/actions/endpoints_actions/courses_endpoints_actions.dart';
import 'package:course_dashboard/features/sections/courses/business/cubit_controller/courses_cubit.dart';
import 'package:course_dashboard/features/sections/courses/presentaion/courses_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/setup_service_locator.dart';
import '../sections/categories/business/actions/endpoints_actions/categories_endpoints_actions.dart';
import 'navigation_widgets/navigation_items_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late AppCubit appCubit;
  @override
  void initState() {
    super.initState();

    appCubit = AppCubit.get(context);
    appCubit.changeDashboardSection(section: DashboardSectionsEnum.COURSES);
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            drawer: isMobileSize(context: context) ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: const <Widget>[
                  NavigationItemsWidget()
                ],
              ),
            ) : null,
            appBar: AppBar(
              leading: Builder(builder: (context) {
                return isMobileSize(context: context) ? IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ) : Container();
              }),
              actions: [
                Text(
                  "تسجيل الخروج",
                  style: TextStyle(
                      fontSize: smallFontSize(context: context),
                      color: Colors.white),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ))
              ],
              title: Text(
                'Courses',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: mediumFontSize(context: context),
                  // color: Colors.white
                ),
              ),
            ),
            body: Row(
              children: [
                ConditionalBuilder(
                  condition: isMobileSize(context: context),
                  builder: (context) => Container(),
                  fallback: (context) =>
                      SizedBox(
                          width: navigationWidth(context: context),
                          child: const NavigationItemsWidget()),
                ),
                Expanded(
                    child: Column(
                      children: [
                        BlocBuilder<AppCubit, AppState>(
                          buildWhen: (previous,
                              current) => current is RunOperationsState,
                          builder: (context, state) {
                            if (state is! RunOperationsState) {
                              return Container();
                            }
                            return appSuccessFailWidget(context: context,
                                isSuccess: state.operation ==
                                    OperationsEnum.SUCCESS,
                                message: state.message);
                          },
                        ),
                        Expanded(
                          child: BlocBuilder<AppCubit, AppState>(
                            buildWhen: (previous, current) => current is ChangeDashboardSectionsState || current is AppInitial,
                            builder: (context, state) {
                              if(state is AppInitial){
                                return Container(
                                  alignment: Alignment.center,
                                  child: const SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator()),
                                );
                              }

                              if(state is ChangeDashboardSectionsState && state.section == DashboardSectionsEnum.COURSES) {
                                return const CoursesSection();
                              }

                              if(state is ChangeDashboardSectionsState && state.section == DashboardSectionsEnum.CATEGORIES) {
                                return const CategoriesSection();
                              }

                              return const CoursesSection();

                            },
                          ),
                        ),
                      ],
                    ))
              ],
            )),
      ),
    );
  }
}
