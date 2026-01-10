import 'package:flutter/material.dart';

class CResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final double screenWidth;
  final RB breakpoints;
  const CResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 10,
    this.runSpacing = 10,
    required this.screenWidth,
    this.breakpoints = RB.defaultRB, // now allowed in const
  });

  @override
  Widget build(BuildContext context) {
    double w = screenWidth;
    int count = breakpoints.getCount(w); // use RB for responsive count

    return LayoutBuilder(
      builder: (context, constraints) {
        double itemWidth =
            (constraints.maxWidth - (spacing * (count - 1))) / count;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((widget) {
            return SizedBox(
              width: itemWidth,
              child: widget,
            );
          }).toList(),
        );
      },
    );
  }
}

class RB {
  final Map<int, double> _bp;

  /// Create custom breakpoints
  const RB(this._bp);

  /// Default breakpoints
  static const RB defaultRB = RB({
    1: 0,
    2: 601,
    3: 1001,
    4: 1321,
    5: 1501,
    6: 1621,
    7: 1921,
    8: 2161,
  });

  /// Returns column count based on device width
  int getCount(double w) {
    int count = 1;

    _bp.forEach((c, minWidth) {
      if (w >= minWidth) count = c;
    });

    return count;
  }
}
