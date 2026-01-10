
import 'package:c_widget/const/c_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'c_hover_container.dart';

// ignore: must_be_immutable
class CTextBox extends StatefulWidget {
  String label;
  double width;
  int maxlength;
  TextEditingController controller;
  TextInputType? textInputType;
  int? maxLine;
  double? height;
  TextAlign? textAlign;
  bool isPassword;
  bool isReadonly;
  bool isDisable;
  Color surfixIconColor;
  void Function(String v)? onChange;
  void Function(String) onSubmitted;
  void Function() onEditingComplete;
  FocusNode? focusNode;
  bool isCapitalization;
  bool iSAutoCorrected;
  String hintText;
  bool isError;
  bool isAutoValidate;
  bool isSearchBox;
  bool issuffixIcon;
  IconData? suffixIcon;
  BorderRadius? borderRadious;
  CTextBox(
      {super.key,
      this.label = '',
      this.width = 100,
      this.maxlength = 150,
      required this.controller,
      this.textInputType = TextInputType.text,
      this.maxLine = 1,
      this.height = 26,
      this.textAlign = TextAlign.start,
      this.onChange,
      this.isPassword = false,
      this.isReadonly = false,
      this.isDisable = false,
      this.surfixIconColor = Colors.grey,
      void Function(String)? onSubmitted,
      void Function()? onEditingComplete,
      this.focusNode,
      this.hintText = '',
      this.isCapitalization = false,
      this.iSAutoCorrected = false,
      this.isAutoValidate = false,
      this.isError = false,
      this.isSearchBox = false,
      this.borderRadious,this.issuffixIcon=false,this.suffixIcon})
      : onSubmitted = onSubmitted ?? ((String v) {}),
        onEditingComplete = onEditingComplete ?? (() {});

  @override
  State<CTextBox> createState() => _CTextBoxState();
}

class _CTextBoxState extends State<CTextBox> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputTheme = theme.inputDecorationTheme;
final resolved = (inputTheme.contentPadding ?? EdgeInsets.symmetric(horizontal: 12 ))
        .resolve(Directionality.of(context));
    final scaled = resolved.copyWith(
      right: widget.issuffixIcon? 0:4,
    );
    bool isObsText = false;
    if (widget.isAutoValidate) {
      if (widget.controller.text.isEmpty) {
        setState(() {
          widget.isError = false;
        });
      }
    }
    if (widget.isError) {
      if (widget.controller.text.isEmpty) {
        setState(() {
          widget.isError = true;
        });
      }
    }
    if (widget.controller.text.isNotEmpty) {
      setState(() {
        widget.isError = false;
      });
    }
    return BlocProvider(
      create: (context) => PasswordShowBloc(),
      child: CHoverMaskContainer(
         hoverColor: widget.isDisable? Colors.transparent:null,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: BlocBuilder<PasswordShowBloc, PasswordIconState>(
            builder: (context, state) {
              if (state is PasswordIconShowState) {
                isObsText = state.isShow;
              }
              return TextField(
                
                textInputAction: widget.textInputType == TextInputType.multiline
                    ? null
                    : TextInputAction.next,
                textDirection: widget.textInputType == TextInputType.multiline
                    ? TextDirection.ltr
                    : null,
                autocorrect: widget.iSAutoCorrected,
                textCapitalization: widget.isCapitalization == true
                    ? TextCapitalization.characters
                    : TextCapitalization.none,
                focusNode: widget.focusNode,
                enabled: !widget.isDisable,
                readOnly: widget.isReadonly,
                onChanged: (value) {
                  setState(() {
                    widget.isError = false;
                  });
                  if (widget.onChange != null) {
                    widget.onChange!(value);
                  }
                },
                onSubmitted: (v) {
                  widget.onSubmitted(v);
                },
                onEditingComplete: () {
                  widget.onEditingComplete();
                },
                keyboardType: widget.textInputType,
                obscureText: !isObsText ? widget.isPassword : false,
                inputFormatters: widget.isCapitalization
                    ? [upperCaseTextFormatter()]
                    : widget.textInputType == TextInputType.multiline
                        ? []
                        : widget.textInputType == TextInputType.emailAddress
                            ? []
                            : widget.textInputType == TextInputType.text
                                ? []
                                : widget.textInputType == TextInputType.datetime
                                    ? [
                                        //dateFormatter,
                                        LengthLimitingTextInputFormatter(
                                            10), // Limit to 10 characters
                                        DateInputFormatter(),
                                      ]
                                    : [
                                        widget.textInputType ==
                                                TextInputType.number
                                            ? FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d+\.?\d*'))
                                            : FilteringTextInputFormatter
                                                .digitsOnly
                                      ],
                maxLength: widget.maxlength,
                maxLines: widget.maxLine,
                style: theme.textTheme.bodyMedium!.copyWith(),
                textAlignVertical: TextAlignVertical.center,
                textAlign: widget.textAlign!,
                decoration: InputDecoration(
                  hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
       // fillColor: Colors.white,
        filled: true,
                  fillColor: widget.isDisable
                      ? Colors
                          .grey[theme.brightness == Brightness.dark ? 600 : 50]
                      : inputTheme.fillColor,
                 // focusColor: Colors.white,
                  labelText: widget.label,
                  labelStyle: clabelStyle(context, widget.isError),
                  // labelStyle: widget.isError
                  //     ? inputTheme.labelStyle!.copyWith(color: Colors.red)
                  //     : inputTheme.labelStyle!.copyWith(
                  //         color: inputTheme.labelStyle!.color!.withOpacity(.6)
                  //         ),
                  hintText: widget.hintText,
        
                  hintStyle: theme.textTheme.labelSmall,
                  counterText: '',
                  border: CBorders.border(
                      context: context,
                      //borderRadious: widget.borderRadious??AppThemeColors.inputBorder(context).borderRadius,
                      isError: widget.isError,
                      isDisabled: widget.isDisable),
                  focusedBorder: CBorders.focused(context,
                      borderRadious: widget.borderRadious,
                      isError: widget.isError),
                  enabledBorder: CBorders.enabled(context,
                      borderRadious: widget.borderRadious,
                      isError: widget.isError),
                  disabledBorder: CBorders.disabled(context,
                      borderRadious: widget.borderRadious),
                  suffixIcon: widget.isPassword
                      ? InkWell(
                          onTap: () {
                            context
                                .read<PasswordShowBloc>()
                                .add(PasswordShowSetEvent(isShow: !isObsText));
                          },
                          child: Icon(
                            !isObsText ? Icons.visibility_off : Icons.visibility,
                            size: (((theme.textTheme.bodyLarge!.fontSize) ?? 16) *
                                1.2),
                            color: theme.colorScheme.secondary,
                          ),
                        )
                      : widget.issuffixIcon? MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Icon(
                              widget.suffixIcon??  Icons.keyboard_arrow_down,
                              size: (((theme.textTheme.bodyLarge!.fontSize) ?? 16) *
                                  1.5),
                              color: theme.colorScheme.secondary,
                            ),
                      ):null,
                  prefixIcon: widget.isSearchBox
                      ? Icon(
                          Icons.search_rounded,
                          size: (((theme.textTheme.bodyLarge!.fontSize) ?? 16) *
                              1.5),
                          color: theme.colorScheme.secondary,
                        )
                      : null,
                  contentPadding:resolved,
                  //const EdgeInsets.only(
                  //    // bottom: 6,
                  //   // top: 2,
                  //     left: 8,
                  //     right: 8)
                ),
                
                controller: widget.controller,
              );
            },
          ),
        ),
      ),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String oldText = oldValue.text;
    String newText = newValue.text;

    // Prevent invalid characters (only digits and "/")
    if (!RegExp(r'^[0-9/]*$').hasMatch(newText)) {
      return oldValue;
    }

    // Handle backspace - allow deletion of "/"
    if (oldText.length > newText.length) {
      return newValue;
    }

    // Automatically insert "/" at the 3rd and 5th positions
    if (newText.length == 2 && !newText.contains("/")) {
      newText += '/';
    } else if (newText.length == 5 && newText.lastIndexOf("/") == 2) {
      newText += '/';
    }

    // Ensure "/" is only at the 3rd and 5th positions
    if (newText.length > 3 && newText[2] != '/') {
      newText = '${newText.substring(0, 2)}/${newText.substring(2)}';
    }
    if (newText.length > 6 && newText[5] != '/') {
      newText = '${newText.substring(0, 5)}/${newText.substring(5)}';
    }

    // Validate day (dd) and month (MM)
    if (newText.length >= 2) {
      String day = newText.substring(0, 2);
      if (int.tryParse(day) != null &&
          (int.parse(day) < 1 || int.parse(day) > 31)) {
        return oldValue; // Invalid day
      }
    }
    if (newText.length >= 5) {
      String month = newText.substring(3, 5);
      if (int.tryParse(month) != null &&
          (int.parse(month) < 1 || int.parse(month) > 12)) {
        return oldValue; // Invalid month
      }
    }

    // Truncate if the user tries to exceed the format
    if (newText.length > 10) {
      newText = newText.substring(0, 10);
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

// ignore: camel_case_types
class upperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

abstract class PasswordIconState {}

class PasswordIconInitState extends PasswordIconState {
  final bool isShow;
  PasswordIconInitState({required this.isShow});
}

class PasswordIconShowState extends PasswordIconState {
  final bool isShow;
  PasswordIconShowState({required this.isShow});
}

abstract class PasswordShowEvent {}

class PasswordShowSetEvent extends PasswordShowEvent {
  final bool isShow;
  PasswordShowSetEvent({required this.isShow});
}

class PasswordShowBloc extends Bloc<PasswordShowEvent, PasswordIconState> {
  PasswordShowBloc() : super(PasswordIconInitState(isShow: false)) {
    on<PasswordShowSetEvent>((event, emit) {
      emit(PasswordIconShowState(isShow: event.isShow));
    });
  }
}

// bool mIsValidateDate(String date) {
//   // Split the input into day, month, and year
//   List<String> parts = date.split('/');
//   if (parts.length == 3) {
//     int day = int.tryParse(parts[0]) ?? 0;
//     int month = int.tryParse(parts[1]) ?? 0;
//     int year = int.tryParse(parts[2]) ?? 0;

//     try {
//       DateTime parsedDate = DateTime(year, month, day);

//       // Ensure the day, month, and year are valid
//       if (parsedDate.year != year ||
//           parsedDate.month != month ||
//           parsedDate.day != day) {
//         return false;
//       } else {
//         return true;
//       }
//     } catch (e) {
//       return false;
//     }
//   }
//   return false;
// }
