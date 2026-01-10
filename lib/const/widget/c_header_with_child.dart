
import 'package:flutter/material.dart';

import '../c_helper.dart';
class CHeaderWithChild extends StatelessWidget {
  const CHeaderWithChild({
    super.key,
    required this.caption,
    required this.child,
    this.capWidth,
    this.minChildWidth = 0,
    this.backgroundColor,
    this.expandChild = false,
  });

  final String caption;
  final Widget child;
  final double? capWidth;
  final double minChildWidth;
  final Color? backgroundColor;
  final bool expandChild;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sBorder = safeOutlineBorder(context);
    final borderColor = sBorder.borderSide.color;

    Widget childWidget = Container(
      constraints: BoxConstraints(minWidth: minChildWidth),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topRight: sBorder.borderRadius.topRight,
          bottomRight: sBorder.borderRadius.bottomRight,
        ),
      ),
      child: ClipRRect(borderRadius: BorderRadius.zero, child: child),
    );

    // Wrap with Flexible/Tight if expandChild = true
    if (expandChild) {
      childWidget = Flexible(fit: FlexFit.tight, child: childWidget);
    }

    return 
    
    IntrinsicHeight(
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// Caption area
        Container(
          width: capWidth,
       //   constraints: const BoxConstraints(maxHeight: 28),
          padding: const EdgeInsets.symmetric(horizontal: 6,),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: backgroundColor ?? theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.only(
              topLeft: sBorder.borderRadius.topLeft,
              bottomLeft: sBorder.borderRadius.bottomLeft,
            ),
            border: Border.all(color: borderColor, width: 0.8),
          ),
          child: Text(
            caption,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
        ),

        /// Child area
        childWidget,
      ],
    ));
  }
}
