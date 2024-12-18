import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../core/values/colors.dart';
import '../../../core/values/responsive_sizes.dart';

class NavigationItemWidget extends StatelessWidget {
  final String navigationImage, navigationName;
  final Function onTap;
  const NavigationItemWidget({super.key, required this.navigationImage, required this.navigationName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      hoverColor: Color(appColorGrey),
      focusColor: Colors.black,
      leading: Image.asset(navigationImage ,width: mediumFontSize(context: context),),
      title: Text(navigationName,
        style: TextStyle(
            fontSize: mediumFontSize(context: context),
            color: Colors.black
        ),
      ),
    );
  }
}
