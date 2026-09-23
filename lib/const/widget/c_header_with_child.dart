import 'package:flutter/material.dart';

import '../c_helper.dart';

class CHeaderWithChild extends StatelessWidget {
  const CHeaderWithChild(
      {super.key,
      required this.caption,
      required this.child,
      this.capWidth,
      this.minChildWidth = 0,
      this.backgroundColor,
      this.expandChild = false,
      this.borderWidth,
      this.borderColor,
      this.isCloneSymbole = false,
      this.capColor,
      this.isDeepBg = true,this.isToolTrip=false});

  final String caption;
  final Widget child;
  final double? capWidth;
  final double minChildWidth;
  final Color? backgroundColor;
  final bool expandChild;
  final double? borderWidth;
  final Color? borderColor;
  final Color? capColor;
  final bool isCloneSymbole;
  final bool isDeepBg;
  final bool isToolTrip;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sBorder = safeOutlineBorder(context);
    final borderColor1 = sBorder.borderSide.color;

    Widget childWidget = Container(
      constraints: BoxConstraints(minWidth: minChildWidth),
      decoration: BoxDecoration(
        //color: theme.colorScheme.surface,
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

    var text = Text(
      caption,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: theme.textTheme.bodySmall!.copyWith(
          color: capColor,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w600),
    );

    return IntrinsicHeight(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// Caption area
        Container(
          width: capWidth,
          //   constraints: const BoxConstraints(maxHeight: 28),
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
          ),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: backgroundColor ??
                (isDeepBg
                    ? theme.colorScheme.surfaceVariant.withOpacity(0.6)
                    : theme.colorScheme.surfaceVariant.withOpacity(0.35)),
            borderRadius: BorderRadius.only(
              topLeft: sBorder.borderRadius.topLeft,
              bottomLeft: sBorder.borderRadius.bottomLeft,
            ),
            border: Border.all(
                color: borderColor ?? borderColor1, width: borderWidth ?? 0.8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: isToolTrip? Tooltip(
                  message: caption,
                  waitDuration: const Duration(milliseconds: 400),
                  preferBelow: false,
                  child: text,
                ):text,
              ),
              if (isCloneSymbole)
                Text(
                  ': ',
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: capColor, fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ),

        /// Child area
        childWidget,
      ],
    ));
  }
}
