 

import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CTabButton extends StatefulWidget {
  final bool isCrossButton;
  final String text;
  final Function() buttonClick;
  final Function()? crossButtonClick;
  final Color? color;
  final Color? textColor;
  final bool isSelected;

  const CTabButton({
    super.key,
    required this.isCrossButton,
    required this.text,
    required this.buttonClick,
      this.crossButtonClick,
    this.color,
    this.isSelected = false,
    this.textColor,
  });

  @override
  State<CTabButton> createState() => _CTabButtonState();
}

class _CTabButtonState extends State<CTabButton> {
  bool isHover = false;
  bool isCrossHover = false;

  @override
  Widget build(BuildContext context) {
  //  AppThemeColors theme = AppThemeColors(context);
    final enabledBorderColor = context.color.borderColor ;

    final Color hoverBg = (Theme.of(context).brightness == Brightness.dark)
        ? Colors.grey[500]!
        : Colors.white;
    final Color selectedBg =
        Theme.of(context).colorScheme.surfaceVariant.withOpacity(.1);
    final Color normalBg = context.color.normalBg;
    final Color hoverText = context.color.normalText;
    final Color normalText = context.color.hoverText;
    final Color crossNormal = context.color.crossNormal;
    final Color crossHover = context.color.crossHover;

    // ------------------- USE ClipRRect TO AVOID BORDER ERROR -------------------
    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            // topRight:
            //     widget.isSelected ? Radius.circular(6) : Radius.circular(0),
            bottomRight:
                Radius.circular(12),
          ),
          color: widget.isSelected
              ? Theme.of(context).brightness == Brightness.dark? normalBg: Colors.white
              : isHover
                  ? hoverBg.withOpacity(0.2)
                  : normalBg,
          // USE uniform border
          border: widget.isSelected
              ? Border(
                  top: BorderSide(
                    width:  context.style.borderWidth() * .05,
                    color: enabledBorderColor,
                  ),
                  left: BorderSide(
                    width: context.style.borderWidth() * .1,
                    color: enabledBorderColor,
                  ),
                  right: BorderSide(
                    width: context.style.borderWidth()  * .7,
                    color: enabledBorderColor,
                  ),
                )
              : Border(
                  top: BorderSide(
                    width:  context.style.borderWidth() * .05,
                    color: enabledBorderColor,
                  ),
                  left: BorderSide(
                    width: context.style.borderWidth() * .3,
                    color: enabledBorderColor,
                  ),
                  right: BorderSide(
                    width: context.style.borderWidth()  * .4,
                    color: enabledBorderColor,
                  ),
                ),
          boxShadow: isHover && !widget.isSelected
              ? [
                  BoxShadow(
                    color: hoverBg.withOpacity(0.05),
                    spreadRadius: -1,
                    blurRadius: 0,
                  )
                ]
              : [
                //BoxShadow(color: Colors.white)
              ],
        ),
        child: AnimatedContainer(
          decoration: BoxDecoration(color: Colors.transparent),
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.only(left: 6, right: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // MAIN TEXT
              InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: widget.buttonClick,
                child: Row(
                  children: [
                    Text(
                      widget.text,
                      style: context.style.bodySmall.style .copyWith(
                        fontStyle: FontStyle.italic,
                        fontSize:
                            (context.style.bodySmall.style.fontSize ?? 9) *
                                .8,
                        fontWeight: isHover || widget.isSelected
                            ? FontWeight.w500
                            : FontWeight.w400,
                            height: 0.6,
                        color:
                            isHover || widget.isSelected ? hoverText : widget.textColor ?? normalText,
                      ),
                    ),
                  ],
                ),
              ),

              // CROSS BUTTON
              if (widget.isCrossButton)
                Padding(
                  padding: const EdgeInsets.only(left: 6,bottom: 1),
                  child: MouseRegion(
                    onEnter: (_) => setState(() => isCrossHover = true),
                    onExit: (_) => setState(() => isCrossHover = false),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: ()=>widget.crossButtonClick?.call(),
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.close_outlined,
                          size: (context.style.bodyLarge.style .fontSize ??
                                  12) *
                              .9,
                          color: isCrossHover || widget.isSelected
                              ? crossHover
                              : crossNormal,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
