import 'package:flutter/material.dart';

class CScrollablePanel extends StatelessWidget {
  final List<Widget> children;
  final double minWidth;
  final bool isVerticalScroll;

  const CScrollablePanel({
    super.key,
    required this.children,
    this.minWidth = 800,
    this.isVerticalScroll = false,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController _contr = ScrollController();
    final ScrollController _contr2 = ScrollController();
    return LayoutBuilder(builder: (context, c) {
      double parentWidth = c.maxWidth;

      Widget columnWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
      Widget horizontalScroll = Expanded(
        child: Scrollbar(
          controller: _contr,
          child: SingleChildScrollView(
            controller: _contr,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: minWidth),
              child: SizedBox(
                width: minWidth,
                child: columnWidget,
              ),
            ),
          ),
        ),
      );

      Widget mainWidget = Row(
        children: [
          parentWidth <= minWidth
              ? horizontalScroll
              : Expanded(
                  child: columnWidget,
                ),
        ],
      );

      return !isVerticalScroll
          ? mainWidget
          : Scrollbar(
              controller: _contr2,
              child: SingleChildScrollView(
                controller: _contr2,
                child: mainWidget,
              ),
            );
    });
  }
}
