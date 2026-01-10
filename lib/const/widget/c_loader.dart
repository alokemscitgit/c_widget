import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CBusyLoader {
  BuildContext context;
  CBusyLoader({required this.context});
  bool b = false;
  Future<void> show() async {
    b = true;
    //print("object");
    return showDialog<void>(
      context: context,
      barrierColor:  
        Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.4),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CupertinoActivityIndicator(
            color: Colors.black,
          ),
        );
      },
    );
  }
  void close() {
    if (b) {
      b = false;
      Navigator.pop(context);
    }
  }
}
