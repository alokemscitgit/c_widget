 
import 'package:flutter/material.dart';
import '../c_helper.dart';
import '../theme/colors.dart';

class HeaderTextBuilder {
  final String text;
  Alignment _alignment = Alignment.centerLeft;
  Color _color = Colors.black;
  double _fontSize = 12;
  FontWeight _fontWeight = FontWeight.bold;
  Color _bgColor = Colors.transparent;
  EdgeInsets _padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 4);
  bool _showToolTip = false;
  HeaderTextBuilder(this.text);
  // -------- alignment shortcuts --------
  HeaderTextBuilder get center {
    _alignment = Alignment.center;
    return this;
  }

  HeaderTextBuilder get left {
    _alignment = Alignment.centerLeft;
    return this;
  }

  HeaderTextBuilder get right {
    _alignment = Alignment.centerRight;
    return this;
  }

  // -------- color shortcuts --------
  HeaderTextBuilder get red {
    _color = Colors.red;
    return this;
  }

  HeaderTextBuilder get blue {
    _color = Colors.blue;
    return this;
  }

  HeaderTextBuilder get green {
    _color = Colors.green;
    return this;
  }

  HeaderTextBuilder color(Color c) {
    _color = c;
    return this;
  }

  // -------- font size shortcuts --------
  HeaderTextBuilder size(double s) {
    _fontSize = s;
    return this;
  }

  HeaderTextBuilder get fs13 {
    _fontSize = 13;
    return this;
  }

  HeaderTextBuilder get fs14 {
    _fontSize = 14;
    return this;
  }

  // -------- font weight --------
  HeaderTextBuilder get bold {
    _fontWeight = FontWeight.bold;
    return this;
  }

  HeaderTextBuilder get normal {
    _fontWeight = FontWeight.normal;
    return this;
  }

  // -------- background color --------
  HeaderTextBuilder bg(Color c) {
    _bgColor = c;
    return this;
  }

  // -------- padding --------
  HeaderTextBuilder padding(EdgeInsets p) {
    _padding = p;
    return this;
  }

  // -------- tooltip flag --------
  HeaderTextBuilder get ShowToolTip {
    _showToolTip = true;
    return this;
  }

  HeaderTextBuilder asThemeM(BuildContext context) {
    _color = AppThemeColors.primary(context);
    _fontSize = AppThemeColors.bodyMedium(context).fontSize ?? 9.5;
    _fontWeight = AppThemeColors.bodyMedium(context).fontWeight!;
    return this;
  }

  HeaderTextBuilder asThemeL(BuildContext context) {
    _color = AppThemeColors.primary(context);
    _fontSize = AppThemeColors.bodyLarge(context).fontSize ?? 9.5;
    _fontWeight = AppThemeColors.bodyLarge(context).fontWeight!;
    return this;
  }

  HeaderTextBuilder asThemeS(BuildContext context) {
    _color = AppThemeColors.primary(context);
    _fontSize = AppThemeColors.bodySmall(context).fontSize ?? 9.5;
    _fontWeight = AppThemeColors.bodySmall(context).fontWeight!;
//       bgColor: _bgColor,
    return this;
  }

  // -------- build --------
  CustomTableColumnHeaderBlackNew build() {
    return CustomTableColumnHeaderBlackNew(
      text: text,
      alignment: _alignment,
      textColor: _color,
      fontSize: _fontSize,
      fontWeight: _fontWeight,
      bgColor: _bgColor,
      padding: _padding,
      IsShowToolTip: _showToolTip,
    );
  }

  CustomTableColumnHeaderBlackNew get widget => build();
}

/// ============================
/// Extension on String
/// ============================
extension HeaderStringExt on String {
  HeaderTextBuilder get tableCol => HeaderTextBuilder(this);
}

class TableCellTextBuilder {
  final String text;

  Alignment _alignment = Alignment.centerLeft;
  Color _fontColor = Colors.black;
  double _fontSize = 13;
  FontWeight _fontWeight = FontWeight.w500;
  Color _bgColor = Colors.transparent;
  EdgeInsets _padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  bool _isSelectable = false;
  bool _isTextTruncate = false;
  Color _borderColor = const Color(0xFFB0B0B0);
  double _borderWidth = 0.5;
  TextDecoration _decorationText = TextDecoration.none;
  Color? _decorationColor;
  VoidCallback? _onTap;
  VoidCallback? _onHover;
  VoidCallback? _onExit;
  TableCellVerticalAlignment _tableCellVerticalAlignment =
      TableCellVerticalAlignment.middle;

  TableCellTextBuilder(this.text);

  // ---------- alignment ----------
  TableCellTextBuilder get center {
    _alignment = Alignment.center;
    return this;
  }

  TableCellTextBuilder get left {
    _alignment = Alignment.centerLeft;
    return this;
  }

  TableCellTextBuilder get right {
    _alignment = Alignment.centerRight;
    return this;
  }

  // ---------- color ----------
  TableCellTextBuilder get red {
    _fontColor = Colors.red;
    return this;
  }

  TableCellTextBuilder get blue {
    _fontColor = Colors.blue;
    return this;
  }

  TableCellTextBuilder get green {
    _fontColor = Colors.green;
    return this;
  }

  TableCellTextBuilder color(Color c) {
    _fontColor = c;
    return this;
  }

  // ---------- font size ----------
  TableCellTextBuilder size(double s) {
    _fontSize = s;
    return this;
  }

  TableCellTextBuilder get fs13 {
    _fontSize = 13;
    return this;
  }

  TableCellTextBuilder get fs14 {
    _fontSize = 14;
    return this;
  }

  // ---------- font weight ----------
  TableCellTextBuilder get bold {
    _fontWeight = FontWeight.bold;
    return this;
  }

  TableCellTextBuilder get normal {
    _fontWeight = FontWeight.normal;
    return this;
  }

  TableCellTextBuilder get fontWeight600 {
    _fontWeight = FontWeight.w600;
    return this;
  }

  // ---------- background ----------
  TableCellTextBuilder bg(Color c) {
    _bgColor = c;
    return this;
  }

  // ---------- padding ----------
  TableCellTextBuilder padding(EdgeInsets p) {
    _padding = p;
    return this;
  }

  // ---------- text truncate ----------
  TableCellTextBuilder get truncate {
    _isTextTruncate = true;
    return this;
  }

  // ---------- selectable ----------
  TableCellTextBuilder get selectable {
    _isSelectable = true;
    return this;
  }

  // ---------- border ----------
  TableCellTextBuilder border(Color c, [double width = 0.5]) {
    _borderColor = c;
    _borderWidth = width;
    return this;
  }

  // ---------- decoration ----------
  TableCellTextBuilder underline([Color? color]) {
    _decorationText = TextDecoration.underline;
    _decorationColor = color;
    return this;
  }

  // ---------- events ----------
  TableCellTextBuilder onTap(VoidCallback cb) {
    _onTap = cb;
    return this;
  }

  TableCellTextBuilder onHover(VoidCallback cb) {
    _onHover = cb;
    return this;
  }

  TableCellTextBuilder onExit(VoidCallback cb) {
    _onExit = cb;
    return this;
  }

  // ---------- vertical alignment ----------
  TableCellTextBuilder valign(TableCellVerticalAlignment v) {
    _tableCellVerticalAlignment = v;
    return this;
  }

  TableCellTextBuilder asThemeM(BuildContext context) {
    _fontColor = (AppThemeColors.bodyMedium(context).color as Color);
    _fontSize = AppThemeColors.bodyMedium(context).fontSize ?? 9.5;
    _fontWeight = AppThemeColors.bodyMedium(context).fontWeight!;
   _borderColor = safeOutlineBorder(context).borderSide.color;
     _borderWidth =  safeOutlineBorder(context).borderSide.width;
    return this;
  }

  TableCellTextBuilder asThemeL(BuildContext context) {
    _fontColor = (AppThemeColors.bodyLarge(context).color as Color);
    _fontSize = AppThemeColors.bodyLarge(context).fontSize ?? 9.5;
    _fontWeight = AppThemeColors.bodyLarge(context).fontWeight!;
   _borderColor = safeOutlineBorder(context).borderSide.color;
     _borderWidth =  safeOutlineBorder(context).borderSide.width;
    return this;
  }

  TableCellTextBuilder asThemeS(BuildContext context) {
    _fontColor = (AppThemeColors.bodySmall(context).color as Color);
    _fontSize = AppThemeColors.bodySmall(context).fontSize ?? 9.5;
    _fontWeight = AppThemeColors.bodySmall(context).fontWeight!;
    _borderColor = safeOutlineBorder(context).borderSide.color;
     _borderWidth =  safeOutlineBorder(context).borderSide.width;
//       bgColor: _bgColor,
    return this;
  }

  // ---------- build ----------
  CustomTableCellx build() {
    return CustomTableCellx(
      text: text,
      alignment: _alignment,
      fontColor: _fontColor,
      fontSize: _fontSize,
      fontWeight: _fontWeight,
      bgColor: _bgColor,
      padding: _padding,
      isSelectable: _isSelectable,
      isTextTuncate: _isTextTruncate,
      borderColor: _borderColor,
      borderWidth: _borderWidth,
      decorationText: _decorationText,
      decorationColor: _decorationColor,
      onTap: _onTap,
      onHover: _onHover,
      onExit: _onExit,
      tableCellVerticalAlignment: _tableCellVerticalAlignment,
    );
  }

  /// Shortcut
  CustomTableCellx get widget => build();
}

extension TableCellStringExt on String {
  TableCellTextBuilder get tableCell => TableCellTextBuilder(this);
}

// ignore: must_be_immutable
class CustomTableColumnHeaderBlackNew extends StatelessWidget {
  String text;
  AlignmentGeometry alignment;
  double fontSize;
  FontWeight fontWeight;
  EdgeInsets padding;
  bool IsShowToolTip;
  Color bgColor;
  Color textColor;

  CustomTableColumnHeaderBlackNew({
    super.key,
    required this.text,
    this.IsShowToolTip = false,
    this.alignment = Alignment.centerLeft,
    this.fontSize = 12,
    this.fontWeight = FontWeight.bold,
    this.bgColor = Colors.transparent,
    this.textColor = Colors.black,
    this.padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: IsShowToolTip
          ? Tooltip(
              message: text,
              child: __headerContainer(text, alignment, fontSize, fontWeight,
                  padding, bgColor, textColor),
            )
          : __headerContainer(text, alignment, fontSize, fontWeight, padding,
              bgColor, textColor),
    );
  }
}

__headerContainer(String text, AlignmentGeometry alignment, double fontSize,
        FontWeight fontWeight, EdgeInsets padding,
        [Color bgColor = Colors.transparent, Color textColor = Colors.black]) =>
    Container(
      color: bgColor,
      alignment: alignment,
      padding: padding,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: fontWeight,
          // fontFamily: appFontLato,
          fontSize: fontSize,
          color: textColor,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

class CustomTableCellx extends StatelessWidget {
  final String text;
  final double fontSize;
  final Alignment alignment;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;
  final Color bgColor;
  final bool isSelectable;
  final Color fontColor;
  final Color borderColor;
  final double borderWidth;
  final bool isTextTuncate;
  final VoidCallback? onTap;
  final VoidCallback? onHover;
  final VoidCallback? onExit;
  final TextDecoration? decorationText;
  final Color? decorationColor;
  final TableCellVerticalAlignment tableCellVerticalAlignment;

  const CustomTableCellx({
    super.key,
    required this.text,
    this.fontSize = 13,
    this.alignment = Alignment.centerLeft,
    this.fontWeight = FontWeight.w500,
    this.padding,
    this.bgColor = Colors.transparent,
    this.isSelectable = false,
    this.fontColor = Colors.black,
    this.onTap,
    this.onHover,
    this.onExit,
    this.isTextTuncate = false,
    this.borderColor = const Color(0xFFB0B0B0),
    this.borderWidth = 0.1,
    this.decorationText = TextDecoration.none,
    this.decorationColor,
    this.tableCellVerticalAlignment = TableCellVerticalAlignment.middle,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: tableCellVerticalAlignment,
      child: Container(
        alignment: alignment,
        padding: padding ?? const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            right: BorderSide(color: borderColor, width: borderWidth *0.5),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            Widget innerText;

            // If truncation is enabled, measure overflow and wrap with Tooltip
            if (isTextTuncate) {
              final textPainter = TextPainter(
                text: TextSpan(
                  text: text,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    color: fontColor,
                    decoration: decorationText,
                    decorationColor: decorationColor,
                  ),
                ),
                textDirection: TextDirection.ltr,
                maxLines: 1,
              )..layout(maxWidth: double.infinity);

              final isOverflow = textPainter.width > constraints.maxWidth;

              innerText = isSelectable
                  ? SelectableText(
                      text,
                      maxLines: 1,
                      scrollPhysics: const NeverScrollableScrollPhysics(),
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                        color: fontColor,
                        decoration: decorationText,
                        decorationColor: decorationColor,
                      ),
                    )
                  : Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                        color: fontColor,
                        decoration: decorationText,
                        decorationColor: decorationColor,
                      ),
                    );

              if (isOverflow) {
                innerText = Tooltip(message: text, child: innerText);
              }
            } else {
              // Full text display without truncation
              innerText = isSelectable
                  ? SelectableText(
                      text,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                        color: fontColor,
                        decoration: decorationText,
                        decorationColor: decorationColor,
                      ),
                    )
                  : Text(
                      text,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                        color: fontColor,
                        decoration: decorationText,
                        decorationColor: decorationColor,
                      ),
                    );
            }

            // Wrap with InkWell if onTap exists
            if (onTap != null) {
              innerText = InkWell(onTap: onTap, child: innerText);
            }

            // Wrap with MouseRegion if hover/exit exists
            if (onHover != null || onExit != null) {
              innerText = MouseRegion(
                onHover: (_) => onHover?.call(),
                onExit: (_) => onExit?.call(),
                child: innerText,
              );
            }

            return innerText;
          },
        ),
      ),
    );
  }
}


extension SizedBoxExtensions on num {
  /// Returns a SizedBox with width equal to this value
  SizedBox get w => SizedBox(width: toDouble());

  /// Returns a SizedBox with height equal to this value
  SizedBox get h => SizedBox(height: toDouble());
}
