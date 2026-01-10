 

import 'package:flutter/material.dart';
import '../c_helper.dart';
import '../theme/colors.dart';

class CGroupBox extends StatelessWidget {
  const CGroupBox({
    super.key,
    this.headerText = '',
    this.children = const [SizedBox()],
    this.borderWidth,
    this.borderRadius = 8,
    this.height = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
  });

  final String headerText;
  final List<Widget> children;
  final double? borderWidth;
  final double borderRadius;
  final double height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final inputTheme = AppThemeColors.inputDecorationTheme(context);
    final sBordr = safeOutlineBorder(context);
    final borderColor = sBordr.borderSide.color;
    final labelStyle = clabelStyle(context, false);
    final labelFontSize = (labelStyle.fontSize ?? 10) * .8;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: height > 0 ? height : null,
          padding: padding,
          decoration: BoxDecoration(
            color: AppThemeColors.scaffoldBackground(context),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor,
              width: borderWidth ?? sBordr.borderSide.width * .8,
            ),
            boxShadow: [
              BoxShadow(
                color: AppThemeColors.primary(context),
                spreadRadius: -3,
                blurRadius: 3,
              ),
            ],
          ),
          child: FocusTraversalGroup(
            policy: WidgetOrderTraversalPolicy(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
        // Invisible header for spacing
        Positioned(
          top: -1,
          left: 8,
          child: Container(
            color: AppThemeColors.scaffoldBackground(context),
            height: 2,
            padding: const EdgeInsets.only(
              left: 2,
            ),
            child: Text(
              headerText,
              style: labelStyle.copyWith(
                color: Colors.transparent,
                fontSize: labelFontSize,
              ),
            ),
          ),
        ),
        // Visible header
        Positioned(
          top: -labelFontSize / 1.5,
          left: 6,
          child: Container(
            padding: const EdgeInsets.only(left: 6, right: 2),
            child: Text(
              headerText,
              style: labelStyle.copyWith(
                color: labelStyle.color!.withOpacity(.6),
                fontSize: labelFontSize,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
