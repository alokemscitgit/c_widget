import 'dart:ui';

import 'package:c_widget/const/widget/c_hover_container.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
//import 'dart:html' as html; // only for web

class CExpandedPanel extends StatefulWidget {
  const CExpandedPanel(
      {super.key,
      required this.titleBuilder,
      required this.children,
      this.isExpanded = true,
      this.borderRadius,
      this.splashColor,
      this.openIcon = Icons.folder_open_sharp,
      this.closeIcon = Icons.folder,
      this.isLeadingIcon = false,
      this.isSurfixIcon = true,
      this.isSelectedColor = true,
      this.iconColor,
      this.iconSize,
      this.selectedTitleColor,
      this.isExpandRow = true,
      this.onTap,
      this.isSplashColor = true});

  final Widget Function(bool expanded) titleBuilder;
  final List<Widget> children;
  final bool isExpanded;
  final double? borderRadius;
  final Color? splashColor;
  final IconData openIcon;
  final IconData closeIcon;
  final bool isLeadingIcon;
  final bool isSurfixIcon;
  final bool isSelectedColor;
  final Color? iconColor;
  final Color? selectedTitleColor;
  final double? iconSize;
  final bool isExpandRow;
  final void Function(bool b)? onTap;
  final bool isSplashColor;

  @override
  State<CExpandedPanel> createState() => _CExpandedPanelState();
}

class _CExpandedPanelState extends State<CExpandedPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() => _isExpanded = !_isExpanded);

    if (_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    if (widget.onTap != null) {
      widget.onTap!(_isExpanded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.iconColor ?? Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          hoverColor: !widget.isSplashColor ? Colors.transparent : null,
          highlightColor: !widget.isSplashColor ? Colors.transparent : null,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
          onTap: _toggleExpand,
          splashColor: !widget.isSplashColor
              ? Colors.transparent
              : widget.isSelectedColor
                  ? widget.splashColor ?? AppThemeColors(context).hoverBg
                  : Colors.transparent,
          child: Container(
            decoration: _isExpanded && widget.isSelectedColor
                ? BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 8),
                    color:
                        widget.splashColor ?? AppThemeColors(context).hoverBg,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 3,
                          spreadRadius: 1,
                          color: widget.selectedTitleColor ??
                              AppThemeColors(context).borderColor)
                    ],
                  )
                : null,
            padding: const EdgeInsets.only(left: 4, top: 1, bottom: 1),
            child: Row(
              children: [
                if (widget.isLeadingIcon)
                  Row(
                    children: [
                      Icon(
                        _isExpanded ? widget.openIcon : widget.closeIcon,
                        size: widget.iconSize ?? 18,
                        color: iconColor,
                      ),
                      const SizedBox(width: 6),
                    ],
                  ),

                // Title builder receives `_isExpanded`
                Expanded(child: widget.titleBuilder(_isExpanded)),

                if (widget.isSurfixIcon)
                  RotationTransition(
                    turns: _animation,
                    child: Icon(
                      !_isExpanded
                          ? Icons.arrow_drop_down
                          : Icons.arrow_drop_up,
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Children
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          child: _isExpanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.children,
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}

class CTreeNode extends StatelessWidget {
  final double leftPad;
  final String title;
  final List<Widget> children;

  final double? textSize;
  final bool isExpanded;
  final bool isSurfix;
  final bool isLeadingIcon;
  final double paddingBottom;
  final bool isSelectedColor;
  final double paddingTop;
  final Widget trailing;
  final IconData openIcon;
  final IconData closeIcon;
  final double? iconSize;
  final bool? isSpashColor;
  final void Function(BuildContext context, Offset position)? onRightClick;
  final Widget? contextMenu;

  const CTreeNode(
      {super.key,
      required this.leftPad,
      required this.title,
      required this.children,
      this.textSize,
      this.isExpanded = false,
      this.isSurfix = false,
      this.isLeadingIcon = true,
      this.paddingBottom = 8,
      this.isSelectedColor = false,
      this.paddingTop = 0,
      this.trailing = const SizedBox(),
      this.openIcon = Icons.folder_open_sharp,
      this.closeIcon = Icons.folder,
      this.iconSize,
      this.isSpashColor,
      this.onRightClick,this.contextMenu});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPad,
        bottom: paddingBottom,
        top: paddingTop,
      ),
      child: CExpandedPanel(
        openIcon: openIcon,
        closeIcon: closeIcon,
        isSelectedColor: isSelectedColor,
        isSurfixIcon: isSurfix,
        isLeadingIcon: isLeadingIcon,
        isExpanded: isExpanded,
        iconSize: iconSize,
        isSplashColor: isSpashColor ?? true,
        // selectedTitleColor: Colors.grey.shade300,
        titleBuilder: (expanded) {
          return Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (event) {
              if (event.kind == PointerDeviceKind.mouse &&
                  event.buttons == kSecondaryMouseButton) {
                onRightClick?.call(context, event.position);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: CHoverMaskContainer(
        
                    hoverColor:  isSpashColor==false?Colors.transparent:AppThemeColors.primary(context).withAlpha(5),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: !expanded
                                ? AppThemeColors.bodyMedium(context).copyWith(
                                    color: AppThemeColors.secondary(context),
                                    fontSize:
                                        textSize ?? AppThemeColors.fontSize(context))
                                : AppThemeColors.bodyMedium(context).copyWith(
                                    fontSize:
                                        textSize ?? AppThemeColors.fontSize(context)),
                          ),
                        ),
                        contextMenu!=null?Row(children: [SizedBox(width: 12,), contextMenu!],):SizedBox.shrink()
                      ],
                    ),
                  ),
                ),
                trailing,
              ],
            ),
          );
        },
        children: children,
      ),
    );
  }
}
