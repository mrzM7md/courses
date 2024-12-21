
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
        return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: smallVerticalPadding(context: context),),
        NavigationItemWidget(navigationImage: dashboardImage, navigationName: "لوحة التحكم",
          bgColor: state is ChangeDashboardSectionsState && state.section == DashboardSectionsEnum.DASHBOARD ? Color(appColorGrey) : null,
          onTap: (){
            appCubit.changeDashboardSection(section: DashboardSectionsEnum.DASHBOARD);
          },),
        NavigationItemWidget(navigationImage: categoriesImage, navigationName: "الأصناف",
          bgColor: state is ChangeDashboardSectionsState && state.section == DashboardSectionsEnum.CATEGORIES ? Color(appColorGrey) : null ,
          onTap: (){
          appCubit.changeDashboardSection(section: DashboardSectionsEnum.CATEGORIES);
        },),
        NavigationItemWidget(navigationImage: coursesImage, navigationName: "الكورسات",
          bgColor: state is ChangeDashboardSectionsState && state.section == DashboardSectionsEnum.COURSES ? Color(appColorGrey) : null,
          onTap: (){
          appCubit.changeDashboardSection(section: DashboardSectionsEnum.COURSES);
        },),
      ],
    );
  },
);
  }
}
