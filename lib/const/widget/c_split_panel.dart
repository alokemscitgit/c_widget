import 'package:flutter/material.dart';
import 'c_groupbox.dart';

class CSplitPanel extends StatelessWidget {
  final List<Widget> Function(bool expanded) rightchildren;
  //final List<Widget> leftchildren;
  final List<Widget> leftchildren;

  final double minWidth;
  final double leftPanelWidth; // Acts as the initial default width
  final String leftTitle;
  final String rightTitle;
  final double spaceBetween;
  final double drawerMenuSizeIcon;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final IconData? iconMenu;
  final Color? bgColor;
  const CSplitPanel(
      {super.key,
      required this.scaffoldKey,
      required this.leftchildren,
      required this.rightchildren,
      this.minWidth = 1050,
      this.leftPanelWidth = 450,
      this.leftTitle = '',
      this.rightTitle = '',
      this.spaceBetween = 0,
      this.drawerMenuSizeIcon = 24,
      this.iconMenu,
      this.bgColor});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrain) {
      final isDesktopLayout = constrain.maxWidth >= minWidth;

      if (isDesktopLayout) {
        return _ResizableDesktopLayout(
          initialLeftWidth: leftPanelWidth,
          leftchildren: leftchildren,
          rightchildren: rightchildren,
        );
      }

      // Mobile / Tablet Fallback Drawer Interface
      return Scaffold(
        key: scaffoldKey,
        drawer: Drawer(
          //backgroundColor:  Colors.transparent,
          child: Container(
            width: leftPanelWidth,
            height: double.infinity,
            color: bgColor ?? Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children:
                  leftchildren.isEmpty ? const [SizedBox()] : leftchildren,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    color: bgColor ?? Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // bgColor: Colors.white,
                      children: [
                        Row(
                          children: [],
                        ),
                        if (rightchildren(false).isNotEmpty) ...rightchildren(false),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 0,
                    child: InkWell(
                      onTap: () => scaffoldKey.currentState?.openDrawer(),
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Icon(
                          iconMenu ?? Icons.menu_rounded,
                          size: drawerMenuSizeIcon,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

/// Internal component to handle responsive drag limitations safely
class _ResizableDesktopLayout extends StatefulWidget {
  final double initialLeftWidth;
  final List<Widget> leftchildren;
  //final List<Widget> rightchildren;
  final List<Widget> Function(bool expanded) rightchildren;

  const _ResizableDesktopLayout({
    required this.initialLeftWidth,
    required this.leftchildren,
    required this.rightchildren,
  });

  @override
  State<_ResizableDesktopLayout> createState() =>
      _ResizableDesktopLayoutState();
}

class _ResizableDesktopLayoutState extends State<_ResizableDesktopLayout> {
  double? _leftWidth;
  final double _minPanelWidth = 250.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final parentWidth = constraints.maxWidth;
        final maxPanelWidth = parentWidth * 0.5; // Exactly 50% boundary line

        // Initialize or clamp initial configuration matching parent dimensions safely
        if (_leftWidth == null) {
          _leftWidth =
              widget.initialLeftWidth.clamp(_minPanelWidth, maxPanelWidth);
        } else if (_leftWidth! > maxPanelWidth) {
          // Live fallback protection during active screen resizing
          _leftWidth = maxPanelWidth;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Left Dynamic Panel
            SizedBox(
              width: _leftWidth,
              child: CGroupBox(
                bgColor: Colors.transparent,
                children: widget.leftchildren.isEmpty
                    ? const [SizedBox()]
                    : widget.leftchildren,
              ),
            ),

            // 2. Interactive Drag Splitter Handle bounded to max 50% parent
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _leftWidth = (_leftWidth! + details.delta.dx)
                      .clamp(_minPanelWidth, maxPanelWidth);
                });
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: Container(
                  width: 4,
                  height: double.infinity,
                  alignment: Alignment
                      .center, // Binds the 50-height element to the center vertical axis
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 0.5),
                    width: 3,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 3,
                              spreadRadius: 0,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2))
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                          5,
                          (_) => Container(
                                width: 2,
                                height: 2,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              )),
                    ),
                  ),
                ),
              ),
            ),

            // 3. Right Expanding Panel
            Expanded(
              child: CGroupBox(
                bgColor: Colors.transparent,
                children: widget.rightchildren(true).isEmpty
                    ? const [SizedBox()]
                    :   widget.rightchildren(true),
              ),
            ),
          ],
        );
      },
    );
  }
}
