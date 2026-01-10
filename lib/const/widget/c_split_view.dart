import 'dart:math';
import 'package:flutter/material.dart';
class CSplitView extends StatefulWidget {
  final Widget first;
  final Widget second;
  final Axis axis;
  final double initialFraction;
  final double dividerThickness;
  final Color dividerColor;
  final double? minFirstPanelSize;
  final double? maxFirstPanelSize;
  final bool isShowLeftPanel;

  const CSplitView({
    super.key,
    required this.first,
    required this.second,
    this.axis = Axis.horizontal,
    this.initialFraction = 0.3,
    this.dividerThickness = 4.0,
    this.dividerColor = const Color(0xFFCCCCCC),
    this.minFirstPanelSize,
    this.maxFirstPanelSize,
    this.isShowLeftPanel = true,
  });

  @override
  State<CSplitView> createState() => _CSplitViewState();
}

class _CSplitViewState extends State<CSplitView> {
  double? fixedFirstSize; // Locked size after drag
  double currentFirstSize = 0;
  bool isMenu = false;
   

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final total = widget.axis == Axis.horizontal
            ? constraints.maxWidth
            : constraints.maxHeight;
        final divider = widget.dividerThickness;

        // Determine left panel size
        double firstSize;

        if (!widget.isShowLeftPanel) {
          // Panel hidden
          firstSize = 0;
        } else {
          // Panel visible: either fixed size or initial fraction
          if (fixedFirstSize == null) {
            firstSize = widget.initialFraction * (total - divider);
          } else {
            firstSize = fixedFirstSize!;
          }

          // Apply min/max
          if (widget.minFirstPanelSize != null) {
            firstSize = max(firstSize, widget.minFirstPanelSize!);
          }
          if (widget.maxFirstPanelSize != null) {
            firstSize = min(firstSize, widget.maxFirstPanelSize!);
          }
        }

        currentFirstSize = firstSize;

        final cursor = widget.axis == Axis.horizontal
            ? SystemMouseCursors.resizeLeftRight
            : SystemMouseCursors.resizeUpDown;

        return Flex(
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: widget.axis,
          children: [
            // LEFT PANEL
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: SizedBox(
                width: widget.axis == Axis.horizontal ? firstSize : null,
                height: widget.axis == Axis.vertical ? firstSize : null,
                child: firstSize == 0 ? null : widget.first,
              ),
            ),

            // DIVIDER
            if (widget.isShowLeftPanel)
              MouseRegion(
                cursor: cursor,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragUpdate: widget.axis == Axis.horizontal
                      ? (d) => _updateDrag(d.delta.dx)
                      : null,
                  onVerticalDragUpdate: widget.axis == Axis.vertical
                      ? (d) => _updateDrag(d.delta.dy)
                      : null,
                  child: Container(
                    width: widget.axis == Axis.horizontal
                        ? divider
                        : double.infinity,
                    height: widget.axis == Axis.vertical
                        ? divider
                        : double.infinity,
                    color: widget.dividerColor,
                  ),
                ),
              ),

            // RIGHT PANEL
            Expanded(child: widget.second),
          ],
        );
      },
    );
  }

  void _updateDrag(double delta) {
    if (!widget.isShowLeftPanel) return; // Prevent dragging if hidden

    setState(() {
      fixedFirstSize = (fixedFirstSize ?? currentFirstSize) + delta;

      if (widget.minFirstPanelSize != null) {
        fixedFirstSize = max(fixedFirstSize!, widget.minFirstPanelSize!);
      }
      if (widget.maxFirstPanelSize != null) {
        fixedFirstSize = min(fixedFirstSize!, widget.maxFirstPanelSize!);
      }
    });
  }
}
