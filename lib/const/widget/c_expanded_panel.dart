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
      this.openIcon = Icons.indeterminate_check_box_outlined,
      this.closeIcon = Icons.add_box_outlined,
      this.isLeadingIcon = false,
      this.isSurfixIcon = true,
      this.isSelectedColor = true,
      this.iconColor,
      this.iconSize,
      this.selectedTitleColor,
      this.isExpandRow = true,
      this.onTap,
      this.isSplashColor = true,
      this.selecteIconColor,
      this.firstNodeGapFromTitle = 0,
      this.titlePadding});

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
  final Color? selecteIconColor;
  final double firstNodeGapFromTitle;
  final EdgeInsets? titlePadding;

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
                  ? widget.splashColor ??context.color.hoverBg
                  : Colors.transparent,
          child: Container(
            decoration: _isExpanded && widget.isSelectedColor
                ? BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 8),
                    color: widget.splashColor == null
                        ? widget.selectedTitleColor
                        : context.color.hoverBg,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 3,
                          spreadRadius: 0,
                          color: widget.selectedTitleColor ??
                             context.color.borderColor)
                    ],
                  )
                : null,
            padding: widget.titlePadding ??
                const EdgeInsets.only(
                  left: 4,
                ),
            child: Row(
              children: [
                if (widget.isLeadingIcon)
                  Row(
                    children: [
                      Icon(
                        _isExpanded ? widget.openIcon : widget.closeIcon,
                        size: widget.iconSize ?? 18,
                        color: _isExpanded
                            ? widget.selecteIconColor ?? iconColor
                            : iconColor,
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
                  children: [
                  widget.firstNodeGapFromTitle==0?SizedBox.shrink():  SizedBox(
                      height: widget.firstNodeGapFromTitle,
                    ),
                    ...widget.children
                  ],
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
  final Color? titleColor;
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
  final bool? isAnimatedSelected;
  final Color? animatedColor;
  final double spaseBetwwenTitleAndContectMenu;
  const CTreeNode(
      {super.key,
        this.leftPad=0,
      required this.title,
      this.titleColor,
      required this.children,
      this.textSize,
      this.isExpanded = false,
      this.isSurfix = false,
      this.isLeadingIcon = true,
      this.paddingBottom = 8,
      this.isSelectedColor = false,
      this.paddingTop = 0,
      this.trailing = const SizedBox(),
      this.openIcon = Icons.indeterminate_check_box_outlined,
      this.closeIcon = Icons.add_box_outlined,
      this.iconSize,
      this.isSpashColor,
      this.onRightClick,
      this.contextMenu,
      this.isAnimatedSelected = false,
      this.animatedColor,
      this.spaseBetwwenTitleAndContectMenu = 12});

  @override
  Widget build(BuildContext context) {
    Color tColor = titleColor ??
    Theme.of(context).textTheme.bodyMedium?.color ??
    Colors.black;

    return Padding(
      padding: EdgeInsets.only(
        left: leftPad,
        bottom: paddingBottom,
        top: paddingTop,
      ),
      child: CExpandedPanel(
        //firstNodeGapFromTitle: 10,
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
            child: Stack(
              children: [
                expanded && isAnimatedSelected == true
                    ? Positioned.fill(
                        child: AnimatedSlide(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutCubic,
                          offset: expanded
                              ? const Offset(0, 0)
                              : const Offset(-1, 0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            decoration: BoxDecoration(
                              color: expanded
                                  ? animatedColor ??
                                      context.color.selectedBg
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: CHoverMaskContainer(
                        hoverColor: isSpashColor == false
                            ? null
                            : context.color.primary.withAlpha(5),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                                style: !expanded
                                    ?  context.style.bodyMedium.style
                                        .copyWith(
                                          color: tColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: textSize ??
                                                context.style.fontSize ) 
                                    : context.style.bodyMedium.style
                                        .copyWith(
                                          color: tColor,
                                            // color: AppThemeColors.secondary(
                                            //     context),
                                            fontWeight: FontWeight.w600,
                                            fontSize: textSize ??
                                               context.style.fontSize),
                              ),
                            ),
                            contextMenu != null
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: spaseBetwwenTitleAndContectMenu,
                                      ),
                                      contextMenu!
                                    ],
                                  )
                                : SizedBox.shrink()
                          ],
                        ),
                      ),
                    ),
                    trailing,
                  ],
                ),
              ],
            ),
          );
        },
        children: children,
      ),
    );
  }
}
