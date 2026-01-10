import 'package:c_widget/const/theme/colors.dart';
 
import 'package:flutter/material.dart';
import '../c_helper.dart';

// ignore: must_be_immutable
class CTool extends StatefulWidget {
  final ToolMenuSet? menu;
  bool isHovered, isDisable, isShowText;
  VoidCallback? onTap;
  final double borderRadius;
  final EdgeInsets padding;
  CTool({
    super.key,
    this.menu,
    this.isHovered = true,
    this.isDisable = false,
    this.onTap,
    this.isShowText = true,
    this.borderRadius = 4,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
  });

  CTool copyWith({
    bool? isDisable,
    bool? isHovered,
    bool? isShowText,
    VoidCallback? onTap,
  }) {
    return CTool(
      key: key,
      menu: menu,
      isDisable: isDisable ?? this.isDisable,
      isHovered: isHovered ?? this.isHovered,
      isShowText: isShowText ?? this.isShowText,
      onTap: onTap ?? this.onTap,
      borderRadius: borderRadius,
      padding: padding,
    );
  }

  @override
  State<CTool> createState() => _CToolState();
}

class _CToolState extends State<CTool> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final bool isDark = (Theme.of(context).brightness == Brightness.dark);
    if (widget.menu == ToolMenuSet.divider) {
      return _customHorizontalDivider(context);
    }
    if (widget.menu == ToolMenuSet.none) return const SizedBox.shrink();

    final isDisabled = widget.isDisable;
    final isHovering = _hover && !isDisabled;

    final buttonBg = theme.elevatedButtonTheme.style?.backgroundColor
            ?.resolve({MaterialState.focused}) ??
        cs.primary;

    final buttonFg = (theme.elevatedButtonTheme.style?.foregroundColor
            ?.resolve({MaterialState.focused}) ??
        cs.onPrimary);

    final bgColor = isDisabled
        ? isDark
            ? Color.fromRGBO(187, 187, 187, 1).withOpacity(0.5)
            : Color.fromARGB(255, 207, 207, 207) // cs.secondary.withOpacity(0.5).withValues(alpha: 255, red: 1,blue: 100,green: 10)
        : isHovering
            ? buttonBg
            : cs.primary.withOpacity(.92);

    final borderColor = safeOutlineBorder(context)
        .borderSide
        .color
        .withOpacity(isDisabled ? .5 : .8);

    final iconColor = isDisabled
        ? cs.onSurface.withOpacity(.4)
        : isHovering
            ? cs.onPrimary
            : buttonFg;

    final shadow = BoxShadow(
      color: AppThemeColors.scaffoldBackground(context),
      blurRadius: isHovering ? 3 : 2,
    );

    return MouseRegion(
      cursor:
          isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => widget.isHovered && !isDisabled
          ? setState(() => _hover = true)
          : null,
      onExit: (_) => widget.isHovered && !isDisabled
          ? setState(() => _hover = false)
          : null,
      child: GestureDetector(
        onTap: isDisabled ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          
          child: Tooltip(
          textStyle: AppThemeColors.bodySmall(context).copyWith(color: buttonFg),
           message: (widget.menu == ToolMenuSet.none ||
            widget.menu == ToolMenuSet.divider ||
            isDisabled)
      ? ''
      : _getText(widget.menu!),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  _getIcon(widget.menu!),
                  size: (theme.textTheme.bodyLarge?.fontSize ?? 16) * 1.5,
                  color:
                       bgColor,
                ),
                if (widget.isShowText && _getText(widget.menu!).isNotEmpty)
              isDisabled?SizedBox.shrink():   Row(children: [
                  SizedBox(width: 1,), Text(
                    _getText(widget.menu!),
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: bgColor,
                     // fontStyle: FontStyle.italic,
                      fontSize:
                          (theme.textTheme.bodySmall!.fontSize ?? 9.4) * .9,
                      fontWeight:
                          isHovering ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                 ],
                 )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum ToolMenuSet {
  file,
  save,
  update,
  delete,
  edit,
  close,
  show,
  print,
  search,
  undo,
  divider,
  none,
  approve,
  cancel,
  post,
  export,
  exit
}

IconData _getIcon(ToolMenuSet toolMenuSet) {
  switch (toolMenuSet) {
    case ToolMenuSet.save:
      return Icons.save;
    case ToolMenuSet.update:
      return Icons.update;
    case ToolMenuSet.delete:
      return Icons.delete;
    case ToolMenuSet.edit:
      return Icons.edit;
    case ToolMenuSet.close:
      return Icons.close;
    case ToolMenuSet.show:
      return Icons.visibility;
    case ToolMenuSet.print:
      return Icons.print;
    case ToolMenuSet.search:
      return Icons.search;
    case ToolMenuSet.file:
      return Icons.file_copy_sharp;
    case ToolMenuSet.undo:
      return Icons.undo;
    case ToolMenuSet.approve:
      return Icons.approval;
    case ToolMenuSet.post:
      return Icons.post_add;
    case ToolMenuSet.cancel:
      return Icons.cancel_rounded;
    case ToolMenuSet.export:
      return Icons.download;
    case ToolMenuSet.exit:
      return Icons.close;

    default:
      return Icons.help_outline; // Default icon
  }
}

// Function to map enum to text
String _getText(ToolMenuSet toolMenuSet) {
  switch (toolMenuSet) {
    case ToolMenuSet.save:
      return 'Save';
    case ToolMenuSet.update:
      return 'Update';
    case ToolMenuSet.delete:
      return 'Delete';
    case ToolMenuSet.edit:
      return 'Edit';
    case ToolMenuSet.close:
      return 'Close';
    case ToolMenuSet.show:
      return 'Show';
    case ToolMenuSet.print:
      return 'Print';
    case ToolMenuSet.search:
      return 'Search';
    case ToolMenuSet.file:
      return 'New';
    case ToolMenuSet.undo:
      return 'Undo';
    case ToolMenuSet.approve:
      return 'Approve';
    case ToolMenuSet.post:
      return 'Post';
    case ToolMenuSet.export:
      return 'Export';
    case ToolMenuSet.cancel:
      return 'Cancel';

    default:
      return ''; // Default text
  }
}

Widget _customHorizontalDivider(
  BuildContext context, [
  double height = 16,
]) {
  Color color = Theme.of(context).colorScheme.secondary;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5.5, vertical: 2),
    child: Container(
      height: height,
      width: 0.6,
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
      ),
    ),
  );
}
