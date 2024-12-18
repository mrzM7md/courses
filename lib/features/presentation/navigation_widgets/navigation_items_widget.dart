
import 'package:flutter/material.dart';

import '../../../core/values/images.dart';
import '../../../core/values/responsive_sizes.dart';
import 'navigation_item_widget.dart';

class NavigationItemsWidget extends StatefulWidget {
  const NavigationItemsWidget({super.key});

  @override
  State<NavigationItemsWidget> createState() => _NavigationItemsWidgetState();
}

class _NavigationItemsWidgetState extends State<NavigationItemsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: smallVerticalPadding(context: context),),
        NavigationItemWidget(navigationImage: dashboardImage, navigationName: "لوحة التحكم", onTap: (){

        },),
        NavigationItemWidget(navigationImage: categoriesImage, navigationName: "الأصناف", onTap: (){

        },),
      ],
    );
  }
}
