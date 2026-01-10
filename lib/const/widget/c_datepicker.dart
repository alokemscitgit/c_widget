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
  CDatePicker(
      {super.key,
      // ignore: non_constant_identifier_names
      required this.controller,
      this.label = 'Select Date',
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
      this.borderRadious});

  @override
  State<CDatePicker> createState() => _CDatePickerState();
}

class _CDatePickerState extends State<CDatePicker> {
  bool isMonth = false;
  @override
  void initState() {
    super.initState();
    if (widget.isShowCurrentDate) {
      widget.controller.text = widget.controller.text == ''
          ? DateFormat('dd/MM/yyyy').format(DateTime.now())
          : widget.controller.text;
      setState(() {
        widget.isError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //String formattedDate =DateFormat('dd/MM/yyyy').format(DateTime.now());
    if (widget.controller.text.length == 10) {
      setState(() {
        widget.isError = false;
      });
      //   print(widget.isError);
    }
    return Stack(
      children: [
        CHoverMaskContainer(
          hoverColor: widget.isDisable ? Colors.transparent : null,
          child: SizedBox(
            width: widget.width,
            height: widget.height,
        
            child: Stack(
              children: [
                _cText(context, widget, (value) {
                  try {
                    if (value.length == 10) {
                      if (!widget.isBackDate!) {
                        var dt2 = DateFormat("dd/MM/yyyy")
                            .format(DateTime.now())
                            .toString();
                        //  print(dt2);
                        if (!isValidDateRange(dt2, value)) {
                          setState(() {
                            widget.controller.text = '';
                          });
                        }
                      }
                    }
                  } catch (e) {}
                }),
              ],
            ),
            //)
          ),
        ),
     
       
      widget.isDisable?  Positioned(
            left: 0,right: 0,bottom: 0,top: 0,
            child: Container(color: Colors.transparent,)):SizedBox.shrink()
      ],
    );
  }

  Widget _cText(BuildContext context, dynamic widget,
      [Function(String d)? fun]) {
    final theme = Theme.of(context);
    final inputTheme = theme.inputDecorationTheme;
    final resolved =
        (inputTheme.contentPadding ?? EdgeInsets.symmetric(horizontal: 12))
            .resolve(Directionality.of(context));
    final scaled = resolved.copyWith(
      right: 2,
    );
    return TextFormField(
      focusNode: widget.focusNode,

      controller: widget.controller,

      style: theme.textTheme.bodyMedium,
      textAlignVertical: TextAlignVertical.center,
      textAlign: widget.textAlign!,
      decoration: InputDecoration(
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        // fillColor: Colors.white,
        filled: true,
        fillColor: widget.isDisable
            ? Colors.grey[theme.brightness == Brightness.dark ? 600 : 50]
            : inputTheme.fillColor,
        // focusColor: Colors.white,
        labelText: widget.label,
        labelStyle: clabelStyle(context, widget.isError),
        hintText: widget.hintText,

        hintStyle: theme.textTheme.labelSmall,
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
          // shadowColor: appGray100,
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
                      // Handle parse exception, return null or current date
                      return null;
                    }
                  }(),
                  initialDate: () {
                    try {
                      return widget.controller.text.length == 10
                          ? DateFormat("dd/MM/yyyy")
                              .parse(widget.controller.text)
                          : DateTime.now();
                    } catch (e) {
                      // Handle parse exception, return current date as fallback
                      return DateTime.now();
                    }
                  }(),
                  firstDate: widget.isBackDate!
                      ? widget.startDate.toString().length < 10
                          ? DateTime(1900)
                          : DateFormat("dd/MM/yyyy").parse(widget.startDate)
                      : DateTime.now(),
                  lastDate: widget.isFutureDateDisplay
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
                      //return;
                    }
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(value);

                    //  print(formattedDate);
                    setState(() {
                      widget.controller.text = formattedDate;
                      widget.isError = false;
                      if (!isMonth) {
                        Navigator.of(context).pop();
                      }
                      if (widget.onDateChanged != null) {
                        widget.onDateChanged(value);
                      }

                      isMonth = false;
                    });
                  },
                ),
              ),
            ),
            //),
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
      readOnly: widget.isReadOnly,
      inputFormatters: [
        //dateFormatter,
        LengthLimitingTextInputFormatter(10), // Limit to 10 characters
        DateInputFormatter(),
      ],
      //  enabled: false,
      enableInteractiveSelection: false,
    );
  }
}

bool isValidDateRange(String fdate, String tdate) {
  try {
    final format = DateFormat('dd/MM/yyyy');
    return !format.parse(tdate).isBefore(format.parse(fdate));
  } catch (_) {
    return false; // invalid date format
  }
}
