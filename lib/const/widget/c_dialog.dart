import 'package:flutter/material.dart';
import '../c_helper.dart';
import '../theme/colors.dart';
import 'c_hover_icon.dart';

Future<void> CDialog(
  BuildContext context,
  String title,
  Widget bodyContent, {
  Function()? onSave,
  double borderRadious = 12,
  bool isItalicTitle = false,
  bool scrollable = false,
  bool isSaveButton = true,
  Color? barrierColor,
  Color? backgroundColor,
  String? saveButtonText,
  Function()? onClose,
}) {
  final GlobalKey buttonKey = GlobalKey();
  bool isButtonDisabled = false;

  void disableButton() {
    isButtonDisabled = true;
    Future.delayed(const Duration(seconds: 1), () {
      if (buttonKey.currentContext != null) {
        isButtonDisabled = false;
      }
    });
  }

  void onButtonPressed() {
    if (!isButtonDisabled) {
      onSave?.call();
      disableButton();
    }
  }

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: barrierColor ??
        Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.4),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      final theme = Theme.of(context);
      final buttonTheme = theme.elevatedButtonTheme.style;

      final headerBgColor = buttonTheme?.backgroundColor?.resolve({}) ??
          theme.colorScheme.primary;

      final headerTextColor = buttonTheme?.foregroundColor?.resolve({}) ??
          theme.colorScheme.onPrimary;
      return Center(
        child: AlertDialog(
          elevation: 3,
          clipBehavior: Clip.none, // IMPORTANT
          scrollable: scrollable,
          backgroundColor:
              backgroundColor ?? theme.scaffoldBackgroundColor.withOpacity(0.9),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadious),
          ),
          contentPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,

          title: Stack(
            clipBehavior: Clip.none, // IMPORTANT
            children: [
              // Header background
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: headerBgColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(borderRadious),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4)
                          .copyWith(right: 28),
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          overflow: TextOverflow.ellipsis,
                          fontStyle: isItalicTitle ? FontStyle.italic : null,
                          color: headerTextColor, //fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Close button OUTSIDE dialog
              Positioned(
                right: -10,
                top: -3.5,
                child: InkWell(
                  //  behavior: HitTestBehavior.opaque, // FULL clickable area
                  onTap: () {
                    Navigator.of(context).pop();
                    onClose?.call();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5), // enlarge tap area
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // borderRadius: BorderRadius.only(topRight: Radius.circular(50),bottomRight: Radius.circular(50)),
                      color: AppThemeColors.secondary(context).withOpacity(0.5),
                      // border: Border.all(color:safeOutlineBorder(context).borderSide.color )
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2,
                          //  spreadRadius: -2,
                          color: safeOutlineBorder(context)
                              .borderSide
                              .color
                              .withOpacity(0.5),
                        )
                      ],
                    ),
                    child: CHoverIcon(
                        icon: Icons.close,
                        size: 20,
                        iconColor: AppThemeColors(context).normalText,
                        iconHoverColor: theme.colorScheme.error,
                        hoverSize: 20),
                  ),
                ),
              ),
            ],
          ),

          titlePadding: EdgeInsets.zero,

          content: bodyContent,

          actions: [
            if (isSaveButton)
              TextButton(
                key: buttonKey,
                onPressed: onButtonPressed,
                child: Text(saveButtonText ?? "Save",
                    style: theme.textTheme.bodySmall!
                        .copyWith(fontWeight: FontWeight.w600)),
              ),
            TextButton(
             
              onPressed: () {
                Navigator.of(context).pop();
                onClose?.call();
              },
              child: Text(
                "Close",
                style: theme.textTheme.bodySmall!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      );

      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}
