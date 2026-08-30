import 'package:c_widget/const/widget/c_textbox.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../c_helper.dart';
import 'c_hover_container.dart';

// ignore: must_be_immutable
class CDatePicker extends StatefulWidget {
  // ignore: non_constant_identifier_names
  TextEditingController controller;
  String? label;

  double? height;
  double? width;
  bool? isBackDate;

  TextAlign? textAlign;
  bool isFilled;

  bool isShowCurrentDate;
  FontWeight textfontWeight;
  double textFontSize;
  bool isOnleClickDate;
  bool isFutureDateDisplay;
  FocusNode? focusNode;
  String? hintText;
  bool? isReadOnly;
  Function(DateTime)? onDateChanged;
  String? startDate;
  bool? isError;
  bool isDisable;
  BorderRadius? borderRadious;
  List<DateTime>? pridictDate;
  void Function(String) onSubmitted;
  Color? focusBgColor;
  bool isfocusBGcolor;
  Color? disabledColor;

  CDatePicker({
    super.key,
    // ignore: non_constant_identifier_names
    required this.controller,
    this.label = '',
    this.height = 26,
    this.width = 130,
    this.isBackDate = false,
    this.isFilled = false,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.isShowCurrentDate = false,
    this.textfontWeight = FontWeight.w600,
    this.textFontSize = 12,
    this.isOnleClickDate = false,
    this.isFutureDateDisplay = true,
    this.hintText = 'DD/MM/YYYY',
    this.isReadOnly = false,
    this.onDateChanged,
    this.startDate = '',
    this.isError = false,
    this.isDisable = false,
    this.borderRadious,
    this.focusBgColor,
    this.isfocusBGcolor = true,
    this.disabledColor,
    void Function(String)? onSubmitted,
    List<DateTime>? pridictDate,
  })  : onSubmitted = onSubmitted ?? ((String v) {}),
        pridictDate = pridictDate ?? [];

  @override
  State<CDatePicker> createState() => _CDatePickerState();
}

class _CDatePickerState extends State<CDatePicker> {
  bool isMonth = false;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    if (widget.isShowCurrentDate) {
      widget.controller.text = widget.controller.text == ''
          ? DateFormat('dd/MM/yyyy').format(DateTime.now())
          : widget.controller.text;
      widget.isError = false;
    }
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = !widget.isfocusBGcolor ? false : _focusNode.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputTheme = theme.inputDecorationTheme;

    // High contrast light-yellow focus background
    final Color focusBgColor = widget.focusBgColor ??
        ((theme.brightness == Brightness.dark)
            ? theme.primaryColor.withOpacity(0.3)
            : Color.alphaBlend(
                Colors.yellow.shade50.withOpacity(0.2),
                Colors.white,
              ));

    final Color normalBgColor = inputTheme.fillColor ?? Colors.transparent;
    final Color disabledBgColor = widget.disabledColor ??
        Colors.grey[theme.brightness == Brightness.dark ? 700 : 50]!;

    final Color resolvedFillColor = widget.isDisable
        ? disabledBgColor
        : (_isFocused ? focusBgColor : normalBgColor);

    return Stack(
      children: [
        CHoverMaskContainer(
          hoverColor: widget.isDisable ? Colors.transparent : null,
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Stack(
              children: [
                _cText(
                  context,
                  widget,
                  focusNode: _focusNode, // Correctly bound state focus node
                  fun: (value) {
                    try {
                      if (value.length == 10) {
                        if (widget.isError == true) {
                          setState(() {
                            widget.isError = false;
                          });
                        }
                        if (!widget.isBackDate!) {
                          var dt2 = DateFormat("dd/MM/yyyy")
                              .format(DateTime.now())
                              .toString();
                          if (!isValidDateRange(dt2, value)) {
                            setState(() {
                              widget.controller.text = '';
                            });
                          }
                        }
                      }
                    } catch (e) {}
                  },
                  onSubmitted: (p0) => widget.onSubmitted.call(p0),
                  bgcolor: resolvedFillColor,
                ),
              ],
            ),
          ),
        ),
        if (widget.isDisable)
            Positioned.fill(
            child: Container(
              color: Colors.transparent,
            ),
          ),
      ],
    );
  }

  Widget _cText(
    BuildContext context,
    dynamic widget, {
    required FocusNode focusNode,
    Function(String d)? fun,
    void Function(String)? onSubmitted,
    Color? bgcolor,
  }) {
    final theme = Theme.of(context);
    final inputTheme = theme.inputDecorationTheme;
    final resolved =
        (inputTheme.contentPadding ?? const EdgeInsets.symmetric(horizontal: 12))
            .resolve(Directionality.of(context));
    final scaled = resolved.copyWith(right: 2);

    return TextFormField(
      onFieldSubmitted: (value) => onSubmitted?.call(value),
      focusNode: focusNode, // Uses the managed internal FocusNode
      controller: widget.controller,
      style: theme.textTheme.bodyMedium,
      textAlignVertical: TextAlignVertical.center,
      textAlign: widget.textAlign!,
      decoration: InputDecoration(
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        filled: true,
        fillColor: bgcolor,
        labelText: widget.label == '' ? null : widget.label,
        labelStyle: clabelStyle(context, widget.isError),
        hintText: widget.hintText,
        hintStyle: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        counterText: '',
        border: CBorders.border(
            context: context,
            borderRadious: widget.borderRadious,
            isError: widget.isError,
            isDisabled: widget.isDisable),
        focusedBorder: CBorders.focused(context,
            borderRadious: widget.borderRadious, isError: widget.isError),
        enabledBorder: CBorders.enabled(context,
            borderRadious: widget.borderRadious, isError: widget.isError),
        disabledBorder:
            CBorders.disabled(context, borderRadious: widget.borderRadious),
        contentPadding: scaled,
        suffixIcon: PopupMenuButton<int>(
          padding: EdgeInsets.zero,
          menuPadding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(8),
          popUpAnimationStyle: AnimationStyle(
              curve: Curves.bounceOut,
              duration: const Duration(milliseconds: 300)),
          tooltip: widget.label,
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              padding: EdgeInsets.zero,
              onTap: () {},
              enabled: false,
              value: 1,
              child: Container(
                width: 280,
                height: 220,
                decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(8)),
                child: CalendarDatePicker(
                  currentDate: () {
                    try {
                      return widget.controller.text.length == 10
                          ? DateFormat("dd/MM/yyyy")
                              .parse(widget.controller.text)
                          : DateTime.now();
                    } catch (e) {
                      return null;
                    }
                  }(),
                  initialDate: () {
                    try {
                      return widget.controller.text.length == 10
                          ? DateFormat("dd/MM/yyyy")
                              .parse(widget.controller.text)
                          : widget.pridictDate.isNotEmpty
                              ? widget.pridictDate.first
                              : DateTime.now();
                    } catch (e) {
                      return widget.pridictDate.isNotEmpty
                          ? widget.pridictDate.first
                          : DateTime.now();
                    }
                  }(),
                  firstDate: widget.pridictDate.isNotEmpty
                      ? widget.pridictDate.first
                      : widget.isBackDate!
                          ? widget.startDate.toString().length < 10
                              ? DateTime(1900)
                              : DateFormat("dd/MM/yyyy")
                                  .parse(widget.startDate)
                          : DateTime.now(),
                  lastDate: widget.pridictDate.isNotEmpty
                      ? widget.pridictDate.last
                      : widget.isFutureDateDisplay
                          ? DateTime.now().add(const Duration(days: 36500))
                          : DateTime.now(),
                  initialCalendarMode: DatePickerMode.day,
                  onDisplayedMonthChanged: (DateTime newDate) {
                    isMonth = true;
                  },
                  onDateChanged: (DateTime value) {
                    bool bb = false;
                    try {
                      DateFormat('dd/MM/yyyy').parse(widget.controller.text);
                      bb = true;
                    } catch (e) {
                      bb = false;
                    }

                    DateTime fromDate = widget.isShowCurrentDate
                        ? DateTime.now()
                        : bb
                            ? DateFormat('dd/MM/yyyy')
                                .parse(widget.controller.text)
                            : DateTime.now();

                    if (value.day != fromDate.day &&
                        value.month != fromDate.month &&
                        isMonth) {
                      isMonth = false;
                    }
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(value);

                    setState(() {
                      widget.controller.text = formattedDate;
                      widget.isError = false;
                      if (!isMonth) {
                        Navigator.of(context).pop();
                      }
                      if (widget.onDateChanged != null) {
                        widget.onDateChanged!(value);
                      }
                      isMonth = false;
                    });
                  },
                  selectableDayPredicate: (d) =>
                      widget.pridictDate.isEmpty ||
                      widget.pridictDate.any((x) =>
                          x.year == d.year &&
                          x.month == d.month &&
                          x.day == d.day),
                ),
              ),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              Icons.calendar_month,
              size: (((theme.textTheme.bodyLarge!.fontSize) ?? 16) * 1.5),
              color: theme.colorScheme.secondary,
            ),
          ),
        ),
      ),
      onChanged: (value) {
        if (fun != null) {
          fun(value);
        }
      },
      readOnly: widget.isReadOnly ?? false,
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
        DateInputFormatter(),
      ],
      enableInteractiveSelection: false,
    );
  }
}

bool isValidDateRange(String fdate, String tdate) {
  try {
    final format = DateFormat('dd/MM/yyyy');
    return !format.parse(tdate).isBefore(format.parse(fdate));
  } catch (_) {
    return false;
  }
}