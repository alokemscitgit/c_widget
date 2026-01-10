import 'package:c_widget/const/c_helper.dart'; 
import 'package:flutter/material.dart';
class CAccordion extends StatefulWidget {
  final String header;
  final List<Widget> children;
  final bool isExpansion;
  final bool isInitiallyOpen;
  final double height;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final double width;
  final double verticalPadding;
  final bool isItalic;

  const CAccordion({
    super.key,
    required this.header,
    required this.children,
    this.isExpansion = true,
    this.isInitiallyOpen = false,
    this.height = 100,
    this.width = 150,
    this.padding = const EdgeInsets.all(8.0),
    this.backgroundColor,
    this.isItalic = false,
    this.verticalPadding = 4,
  });

  @override
  State<CAccordion> createState() => _CAccordionState();
}

class _CAccordionState extends State<CAccordion> {
  late bool isOpen;
  bool isHover = false;

  @override
  void initState() {
    super.initState();
    isOpen = !widget.isInitiallyOpen;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safeBorder = safeOutlineBorder(context);
    final buttonTheme = theme.elevatedButtonTheme.style;
    final headerBgColor =
        widget.backgroundColor ?? buttonTheme?.backgroundColor?.resolve({}) ?? theme.colorScheme.primary;
    final headerTextColor = buttonTheme?.foregroundColor?.resolve({}) ?? theme.colorScheme.onPrimary;
    final iconSize = (theme.textTheme.bodyMedium?.fontSize ?? 14) * 1.5;

    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: safeBorder.borderRadius,
        border: Border.all(color: safeBorder.borderSide.color, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with hover effect
          MouseRegion(
            onEnter: (_) => setState(() => isHover = true),
            onExit: (_) => setState(() => isHover = false),
            child: InkWell(
              onTap: widget.isExpansion ? () => setState(() => isOpen = !isOpen) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: widget.verticalPadding),
                decoration: BoxDecoration(
                  color: isHover ? headerBgColor.withOpacity(0.9) : headerBgColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(safeBorder.borderRadius.topLeft.x),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 1, spreadRadius: 0),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.header,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontStyle: widget.isItalic ? FontStyle.italic : null,
                        color: headerTextColor,
                      ),
                    ),
                    if (widget.isExpansion)
                      Icon(
                        !isOpen ? Icons.keyboard_arrow_down_sharp : Icons.keyboard_arrow_up_sharp,
                        size: iconSize,
                        color: headerTextColor,
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Body
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: isOpen ? widget.height : 0,
            width: double.infinity,
            padding: widget.padding,
            child: !isOpen
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.children,
                  ),
          ),
        ],
      ),
    );
  }
}
