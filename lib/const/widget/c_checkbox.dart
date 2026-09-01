import 'package:flutter/material.dart';

import '../theme/colors.dart';

class CCheckbox extends StatefulWidget {
  final String label;
  final bool initialValue;
  final ValueChanged<bool>? onChanged;
  final bool isLabelColorChange;

  const CCheckbox(
      {super.key,
      required this.label,
      this.initialValue = false,
      this.onChanged,
      this.isLabelColorChange = true});

  @override
  State<CCheckbox> createState() => _CCheckboxState();
}

class _CCheckboxState extends State<CCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  void _onChanged(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(_isChecked);
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Theme.of(context).textTheme.bodyMedium!.fontSize ?? 11;

    // Determine scale based on font size (smaller font → smaller checkbox)
    double scale = (fontSize / 16).clamp(0.6, 1.0);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: scale,
          child: Checkbox(
            value: _isChecked,
            onChanged: _onChanged,
            activeColor: Theme.of(context).colorScheme.secondary,
            checkColor: Theme.of(context).colorScheme.onPrimary,
            visualDensity: const VisualDensity(
              horizontal: -4.0, // reduces horizontal space
              vertical: -4.0, // reduces vertical space
            ),
          ),
        ),
        InkWell(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => setState(() {
            _isChecked = !_isChecked;
          }),
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: (_isChecked && widget.isLabelColorChange)
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).textTheme.bodyMedium!.color,
                ),
          ),
        ),
      ],
    );
  }
}
class CCheckbox2 extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isLabelColorChange;
  final bool isAnim;
  final bool isShoCheck;
  final Color? animColor;
  final Color? animTextColor;
  final double? textFontSize;
  final FontWeight? textFontWeight;
  final bool isTruncate;
  final Color? checkTickColor;

  const CCheckbox2({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
    this.isLabelColorChange = true,
    this.isAnim = true,
    this.isShoCheck = true,
    this.animColor,
    this.animTextColor,
    this.textFontSize,
    this.textFontWeight,
    this.isTruncate = false,
    this.checkTickColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bodySmall = theme.textTheme.bodySmall;
    final isDark = theme.brightness == Brightness.dark;

    final fontSize = textFontSize ?? bodySmall?.fontSize ?? 9;
    final scale = (fontSize / 16).clamp(0.6, 1.0);

    final primaryColor = theme.colorScheme.primary;
    final selectTextColor = Color.lerp(
      primaryColor,
      isDark ? Colors.white : Colors.black,
      0.2,
    )!;

    Widget textWidget = GestureDetector(
      onTap: () => onChanged?.call(!value),
      behavior: HitTestBehavior.opaque,
      child: Text(
        label,
        maxLines: isTruncate ? 1 : null,
        overflow: isTruncate ? TextOverflow.ellipsis : TextOverflow.visible,
        style: bodySmall?.copyWith(
          fontSize: fontSize * 0.91,
          fontWeight: value ? FontWeight.bold : (textFontWeight ?? FontWeight.w600),
          color: (value && isLabelColorChange)
              ? (animTextColor ?? selectTextColor)
              : bodySmall.color,
        ),
      ),
    );

    if (isTruncate) {
      textWidget = Expanded(child: textWidget);
    }

    return Stack(
      children: [
        if (isAnim)
          Positioned.fill(
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              offset: value ? Offset.zero : const Offset(-1, 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: value
                      ? (animColor ?? primaryColor.withValues(alpha: 0.18))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(right: 6, left: isShoCheck ? 0 : 6),
          child: Row(
            mainAxisSize: isTruncate ? MainAxisSize.max : MainAxisSize.min,
            children: [
              Transform.scale(
                scale: scale,
                child: isShoCheck
                    ? Checkbox(
                        value: value,
                        onChanged: (v) => onChanged?.call(v ?? false),
                        activeColor: theme.colorScheme.secondary,
                        checkColor: checkTickColor ?? theme.colorScheme.onPrimary,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      )
                    : const SizedBox(height: 18),
              ),
              if (label.isNotEmpty) textWidget,
            ],
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class CCheckBox3 extends StatelessWidget {
  CCheckBox3({super.key, this.value, this.onChanged, this.checkColor});
  bool? value;
  final void Function(bool)? onChanged;
  final Color? checkColor;
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: (v) => onChanged?.call(v ?? false),
      activeColor: Theme.of(context).colorScheme.secondary,
      checkColor: checkColor ?? Theme.of(context).colorScheme.onPrimary,
      visualDensity: const VisualDensity(
        horizontal: -4,
        vertical: -4,
      ),
    );
  }
}
