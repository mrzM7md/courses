import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../components/widgets_components.dart';

void deleteDialog({required BuildContext context,
  required String title, required String description, required Function onClick, String buttonTitle = "حذف"}
    ){
  showDialog(context: context, builder: (context) =>
      AlertDialog(
        backgroundColor: Colors.white,
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize:
                      MediaQuery.sizeOf(context).width <= 400 ? 14 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize:
                      MediaQuery.sizeOf(context).width <= 400 ? 12 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  getAppButton(
                    color: Colors.redAccent,
                    textColor: Colors.white,
                    text: buttonTitle,
                    onClick: () {
                      Navigator.of(context).pop();
                      onClick();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
}

void getToast({
  required String message,
  required bool isSuccess
}){
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG, // seconds for android.. // 5 seconds for LONG, 1 for SHORT
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 3, // seconds for web
    backgroundColor: isSuccess ? CupertinoColors.systemGreen : Colors.redAccent,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}