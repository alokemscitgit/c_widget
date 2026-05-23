import 'package:c_widget/const/theme/colors.dart';
import 'package:flutter/material.dart';

class CTreeLine extends StatelessWidget {
  final Widget child;
  final bool showVertical;
  final double indent;
  final double connectorTop;
  final bool isFirstNode;
  final bool isLastNode;
  final double lastLineHeight;
  final bool isAutoWidth;
  

  const CTreeLine(
      {super.key,
      required this.child,
      this.showVertical = true,
      this.indent = 16,
      this.connectorTop = 8,
      this.isFirstNode = false,
      this.isLastNode = false,
      this.lastLineHeight = 14 ,
      this.isAutoWidth = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Vertical line
        if (showVertical)
          Positioned(
            left: indent / 2,
            top: isFirstNode ? 12 : 0,
            bottom: 0,
            child: Container(
              width: 1,
              color: isLastNode
                  ? Colors.transparent
                  : AppThemeColors.secondary(context),
            ),
          ),

        // Content + horizontal line
        Stack(
          children: [
            isLastNode
                ? Positioned(
                    left: indent / 2,
                    top: 0,
                    child: Container(
                      width: 1,
                      height: lastLineHeight,
                      color:  AppThemeColors.secondary(context),
                    ))
                : Positioned(child: SizedBox.shrink()),
            Padding(
              padding: const EdgeInsets.only(left: 10.8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: isAutoWidth ? MainAxisSize.min : MainAxisSize.max,
                children: [
                  // Horizontal line
                  Padding(
                    padding: EdgeInsets.only(top: connectorTop),
                    child: Container(
                      width: 16,
                      height: 1,
                      color: AppThemeColors.secondary(context),
                    ),
                  ),
                  isAutoWidth
                      ? IntrinsicWidth(
                          child: child,
                        )
                      : Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
