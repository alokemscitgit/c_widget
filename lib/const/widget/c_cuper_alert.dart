import 'package:c_widget/const/c_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
CCupertinoAlertWithYesNo(
  BuildContext context,
  Widget title,
  Widget content, {
  void Function()? no,
  void Function()? yes,
  String? noButtonCap,
  String? yesButtonCap,
  bool isCloseOnClickYes = true,
}) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext ctx) {
      bool isPressed = false;
      final sBorder = safeOutlineBorder(ctx);
      return CupertinoAlertDialog(
        insetAnimationCurve: Curves.bounceInOut,
        title: title,
        content: Material(
          color: Colors.transparent,
          borderRadius: sBorder.borderRadius,
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: content,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(noButtonCap ?? 'No'),
            onPressed: () {
              if (isPressed) return;

              isPressed = true;
              Navigator.of(ctx).pop();
              no?.call();

              Future.delayed(const Duration(seconds: 1), () {
                isPressed = false;
              });
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(yesButtonCap ?? 'Yes'),
            onPressed: () {
              if (isPressed) return;

              isPressed = true;

              if (isCloseOnClickYes) {
                Navigator.of(ctx).pop();
              }

              yes?.call();

              Future.delayed(const Duration(seconds: 1), () {
                isPressed = false;
              });
            },
          ),
        ],
      );
    },
  );
}
