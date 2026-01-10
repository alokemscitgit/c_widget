import 'package:flutter/material.dart';

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
