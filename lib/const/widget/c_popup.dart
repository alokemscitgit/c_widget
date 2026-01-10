import 'package:c_widget/const/c_helper.dart';
import 'package:c_widget/const/theme/colors.dart';
import 'package:flutter/material.dart';

class CPoppUpMenu extends StatelessWidget {
  const CPoppUpMenu({required this.iconWidget, required this.menuList});
  final Widget? iconWidget;
  final List<Widget> menuList;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: safeOutlineBorder(context).borderRadius,
      ),
      color: Colors.transparent,
      menuPadding: EdgeInsets.zero,
      elevation: 0,
      itemBuilder: ((context) => [
            PopupMenuItem(
              padding: EdgeInsets.zero,
              child: _cPopUp(
                list: menuList,
              ),
            )
          ]),
      child: iconWidget,
    );
  }
}

class _cPopUp extends StatefulWidget {
  const _cPopUp({super.key, required this.list, this.onClick, this.hoverColor});
  final List<Widget> list;
  final Function()? onClick;
  final Color? hoverColor;
  @override
  State<_cPopUp> createState() => __cPopUpState();
}

class __cPopUpState extends State<_cPopUp> {
  bool hover = false;
  @override
  void initState() {
    setState(() {
      hover = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color color =
        widget.hoverColor ?? AppThemeColors.scaffoldBackground(context);
    return MouseRegion(
      onEnter: (_) => setState(() {
        hover = true;
      }),
      onExit: (_) => setState(() {
        hover = false;
      }),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              onTap: () {
                if (widget.onClick != null) {
                  widget.onClick!();
                }
                // Handle tap
              },
              child: Transform.scale(
                scale: hover ? 1.01 : 1.0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  // height: 150,
                  // width: 210,
                  decoration: BoxDecoration(
                    color: !hover
                        ? color.withOpacity(0.96)
                        : color.withOpacity(0.9),
                    borderRadius: safeOutlineBorder(context).borderRadius,
                    border: Border.all(
                        color: safeOutlineBorder(context).borderSide.color,
                        width: safeOutlineBorder(context).borderSide.width),
                  ),
                  child: Column(
                    children: [...widget.list],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
