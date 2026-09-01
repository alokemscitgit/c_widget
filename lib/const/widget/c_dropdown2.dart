import 'package:c_widget/const/widget/c_hover_container.dart';
import 'package:flutter/material.dart';

import '../c_helper.dart';

 

class CDropDown2 extends StatefulWidget {
  const CDropDown2({
    super.key,
    required this.cmb,
    this.list,
    this.onTap,
    this.width = double.infinity,
    this.height = 26,
    this.labeltext = '',
    this.focusNode,
    this.isError = false,
    this.isAutoValidate = false,
    this.isScapeZeroValue = false,
    this.isDisable = false,
    this.borderRadious,
  });

  final Cmb cmb;
  final List<dynamic>? list;
  final void Function(String? value)? onTap;
  final double height;
  final double? width;
  final FocusNode? focusNode;
  final String labeltext;
  final bool isError;
  final bool isAutoValidate;
  final bool isScapeZeroValue;
  final bool isDisable;
  final BorderRadius? borderRadious;

  @override
  State<CDropDown2> createState() => _CDropDown2State();
}

class _CDropDown2State extends State<CDropDown2> {
  late bool _hasError;

  @override
  void initState() {
    super.initState();
    _hasError = widget.isError;
  }

  @override
  void didUpdateWidget(covariant CDropDown2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isError != widget.isError) {
      _hasError = widget.isError;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputTheme = theme.inputDecorationTheme;
    final resolved = (inputTheme.contentPadding ?? const EdgeInsets.symmetric(horizontal: 12))
        .resolve(Directionality.of(context));
    final scaled = resolved.copyWith(right: 5);

    // Dynamic list resolution (fallback to widget.list if cmb.list is empty)
    final activeList =  widget.list ;

    final currentId = widget.cmb.id ;

    // Validation state evaluation (without triggering setState during build)
    bool effectiveError = _hasError;
    if (widget.isAutoValidate && currentId.isEmpty) {
      effectiveError = true;
    } else if (currentId.isNotEmpty) {
      effectiveError = false;
    }

    final isValidValue = activeList?.any((e) => e.id.toString() == currentId);
    final selectedValue = (widget.isScapeZeroValue && (currentId == '' || currentId == '0'))
        ? null
        : (!(isValidValue??false) || currentId == '')
            ? null
            : currentId;

    return Stack(
      children: [
        CHoverMaskContainer(
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: DropdownButtonFormField<String>(
              itemHeight: null,
              dropdownColor: theme.cardTheme.color,
              elevation: 3,
              enableFeedback: !widget.isDisable,
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: ((theme.textTheme.bodyLarge?.fontSize ?? 16) * 1.5),
                color: theme.colorScheme.secondary,
              ),
              padding: EdgeInsets.zero,
              focusNode: widget.focusNode,
              style: theme.textTheme.bodyMedium,
              value: selectedValue,
              items: activeList!
                  .map((f) => DropdownMenuItem<String>(
                        value: f.id.toString(),
                        child: Text(
                          f.name ?? '',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ))
                  .toList(),
              onChanged: widget.isDisable
                  ? null
                  : (v) {
                      setState(() {
                        widget.cmb.id = v!;  
                        _hasError = false;
                      });
                      if (widget.onTap != null) {
                        widget.onTap!(v);
                      }
                    },
              decoration: InputDecoration(
                fillColor: widget.isDisable
                    ? Colors.grey[theme.brightness == Brightness.dark ? 600 : 50]
                    : inputTheme.fillColor,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                filled: true,
                labelText: widget.labeltext,
                labelStyle: clabelStyle(context, effectiveError),
                hintStyle: theme.textTheme.labelSmall,
                counterText: '',
                border: CBorders.border(
                    context: context,
                    borderRadious: widget.borderRadious,
                    isError: effectiveError,
                    isDisabled: widget.isDisable),
                focusedBorder: CBorders.focused(context,
                    borderRadious: widget.borderRadious, isError: effectiveError),
                enabledBorder: CBorders.enabled(context,
                    borderRadious: widget.borderRadious, isError: effectiveError),
                disabledBorder: CBorders.disabled(context,
                    borderRadious: widget.borderRadious),
                contentPadding: scaled,
              ),
              isDense: true,
              isExpanded: true,
            ),
          ),
        ),
        if (widget.isDisable)
            Positioned.fill(
            child: Container(color: Colors.transparent),
          ),
      ],
    );
  }
}