import 'package:course_dashboard/core/enums/dashboard_sections_enum.dart';
import 'package:course_dashboard/core/values/colors.dart';
import 'package:course_dashboard/features/business/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/values/images.dart';
import '../../../core/values/responsive_sizes.dart';
import 'navigation_item_widget.dart';

class NavigationItemsWidget extends StatefulWidget {
  const NavigationItemsWidget({super.key});

  @override
  State<NavigationItemsWidget> createState() => _NavigationItemsWidgetState();
}

class _NavigationItemsWidgetState extends State<NavigationItemsWidget> {
  late AppCubit appCubit;

  @override
  void initState() {
    super.initState();
    appCubit = AppCubit.get(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (previous, current) => current is ChangeDashboardSectionsState,
      builder: (context, state) {
        Color selectedColor = Colors.black54;
        return Material(
          color: Color(appBlueColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: smallVerticalPadding(context: context),
              ),
              NavigationItemWidget(
                navigationImage: categoriesImage,
                navigationName: "الأصناف",
                bgColor: state is ChangeDashboardSectionsState &&
                        state.section == DashboardSectionsEnum.CATEGORIES
                    ? selectedColor
                    : null,
                onTap: () {
                  appCubit.changeDashboardSection(
                      section: DashboardSectionsEnum.CATEGORIES);
                },
              ),
              const Divider(),
              NavigationItemWidget(
                navigationImage: coursesImage,
                navigationName: "الكورسات",
                bgColor: state is ChangeDashboardSectionsState &&
                        state.section == DashboardSectionsEnum.COURSES
                    ? selectedColor
                    : null,
                onTap: () {
                  appCubit.changeDashboardSection(
                      section: DashboardSectionsEnum.COURSES);
                },
              ),
              const Divider(),
              NavigationItemWidget(
                navigationImage: postImage,
                navigationName: "المنشورات",
                bgColor: state is ChangeDashboardSectionsState &&
                        state.section == DashboardSectionsEnum.POSTS
                    ? selectedColor
                    : null,
                onTap: () {
                  appCubit.changeDashboardSection(
                      section: DashboardSectionsEnum.POSTS);
                },
              ),
              const Divider(),
              NavigationItemWidget(
                navigationImage: surveysImage,
                navigationName: "الاستبيانات",
                bgColor: state is ChangeDashboardSectionsState &&
                        state.section == DashboardSectionsEnum.SURVEYS
                    ? selectedColor
                    : null,
                onTap: () {
                  appCubit.changeDashboardSection(
                      section: DashboardSectionsEnum.SURVEYS);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
