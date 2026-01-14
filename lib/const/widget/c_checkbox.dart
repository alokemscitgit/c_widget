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


  const CCheckbox2(
      {super.key,
      required this.label,
      required this.value,
      this.onChanged,
      this.isLabelColorChange = true,
      this.isAnim = true});

  @override
  Widget build(BuildContext context) {
    final fontSize = Theme.of(context).textTheme.bodySmall?.fontSize ?? 9;

    // Scale checkbox based on font size
    final scale = (fontSize / 16).clamp(0.6, 1.0);

    return Stack(
      children: [
        Positioned.fill(
          child: !isAnim
              ? SizedBox()
              : AnimatedSlide(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  offset: value ? const Offset(0, 0) : const Offset(-1, 0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      color: value
                          ? AppThemeColors(context).selectedBg
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(
                scale: scale,
                child: Checkbox(
                  value: value,
                  onChanged: (v) => onChanged?.call(v ?? false),
                  activeColor: Theme.of(context).colorScheme.secondary,
                  checkColor: Theme.of(context).colorScheme.onPrimary,
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -4,
                  ),
                ),
              ),
              InkWell(
                onTap: () => onChanged?.call(!value),
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: fontSize* .91,
                    fontWeight: value?FontWeight.w600: FontWeight.w500,
                        color: (value && isLabelColorChange)
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).textTheme.bodySmall?.color,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
