import 'package:flutter/material.dart';
import '../c_helper.dart';
import '../theme/colors.dart';

class CGroupBox extends StatelessWidget {
  const CGroupBox(
      {super.key,
      this.headerText = '',
      this.children = const [SizedBox()],
      this.borderWidth,
      this.borderRadius = 8,
      this.height = 0,
      this.padding = const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
      this.bgColor,this.labelColor});

  final String headerText;
  final List<Widget> children;
  final double? borderWidth;
  final double borderRadius;
  final double height;
  final EdgeInsets padding;
  final Color? bgColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
     
    final sBordr = safeOutlineBorder(context);
    final borderColor = sBordr.borderSide.color;
    final labelStyle = clabelStyle(context, false);
    final labelFontSize =  9.6 * AppThemeColors.scale(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: height > 0 ? height : null,
          padding: padding,
          decoration: BoxDecoration(
            color: bgColor ?? AppThemeColors.scaffoldBackground(context).withAlpha(250).withOpacity(0.95) ,
            borderRadius: BorderRadius.circular(borderRadius),
            border: borderWidth==0?null:  Border.all(
              color: borderColor,
              width: borderWidth ?? 1,
            ),
            boxShadow:  borderWidth==0?[]:  bgColor==Colors.transparent?[]:  [
            BoxShadow(
                color: AppThemeColors.primary(context),
                spreadRadius: -4,
                blurRadius: 6,
              ),
            ],
          ),
          child: FocusTraversalGroup(
            policy: WidgetOrderTraversalPolicy(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(),
                ...children],
            ),
          ),
        ),
        // Invisible header for spacing
        Positioned(
          top: -1,
          left: 8,
          child: headerText.isEmpty
              ? SizedBox.shrink()
              : Container(
                  color: bgColor ?? AppThemeColors.scaffoldBackground(context),
                  height: 2,
                  padding: const EdgeInsets.only(
                    left: 2,
                  ),
                  child: Text(
                    headerText,
                    style: labelStyle.copyWith(
                      color: Colors.transparent,
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
        ),
        // Visible header
        Positioned(
          top: -labelFontSize / 1.48,
          left: 6,
          child: headerText.isEmpty
              ? SizedBox.shrink()
              : Container(
                  padding: const EdgeInsets.only(left: 6, right: 2),
                  child: Text(
                    headerText,
                    style: labelStyle.copyWith(
                      color:labelColor?? labelStyle.color!.withOpacity(.6),
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
