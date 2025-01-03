import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

int appColorGrey = 0xffF8F8F8;
int appColorLightYellow = 0xfff9f4ef;
int appWhiteColor = 0xffffffff;
// int appBlueColor = 0xff497ed8;
int appBlueColor = Colors.blueAccent.value;

MaterialStateProperty<Color?>? appTableHeaderBackgroundColor = const WidgetStatePropertyAll(Colors.black54);
Color appTableHeaderColorText = Colors.white60;

MaterialStateProperty<Color?>? breakDataTableColor = const WidgetStatePropertyAll(CupertinoColors.systemGrey4);