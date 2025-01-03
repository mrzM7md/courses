import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../core/values/colors.dart';
import '../../../core/values/responsive_sizes.dart';

class NavigationItemWidget extends StatelessWidget {
  final String navigationImage, navigationName;
  final Function onTap;
  final Color? bgColor;
  const NavigationItemWidget({super.key, required this.navigationImage, required this.navigationName, required this.bgColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: ListTile(
        onTap: () => onTap(),
        hoverColor: Colors.black45,
        splashColor: Colors.black54,
        // focusColor: Colors.black,
        textColor: Colors.white,
        // leading: Image.asset(navigationImage ,width: mediumFontSize(context: context),),
        // selectedColor: Colors.black,
        title: Text(navigationName,
          style: TextStyle(
              fontSize: mediumFontSize(context: context),
              // color: Colors.black
          ),
        ),
      ),
    );
  }
}
