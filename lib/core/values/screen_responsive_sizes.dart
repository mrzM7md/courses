import 'package:flutter/cupertino.dart';

bool isMobileSize({required BuildContext context}) => MediaQuery.sizeOf(context).width >= minMobileSize && MediaQuery.sizeOf(context).width <= maxMobileSize;
bool isTabletSize({required BuildContext context}) => MediaQuery.sizeOf(context).width >= minTabletSize && MediaQuery.sizeOf(context).width <= maxTabletSize;
bool isDesktopSize({required BuildContext context}) => MediaQuery.sizeOf(context).width >= minDesktopSize && MediaQuery.sizeOf(context).width <= maxDesktopSize;

const double minMobileSize = 220;
const double maxMobileSize = 480;

const double minTabletSize = 481;
const double maxTabletSize = 960;

const double minDesktopSize = 961;
const double maxDesktopSize = double.infinity;

Size getScreenSize({required BuildContext context}){
  if(isMobileSize(context: context)){
    return const Size(minMobileSize, maxMobileSize);
  }else if(isTabletSize(context: context)){
    return const Size(minTabletSize, maxTabletSize);
  }else{
    return const Size(minDesktopSize, maxDesktopSize);;
  }
}