import 'dart:async';

import 'package:c_widget/const/c_helper.dart';

import 'package:flutter/material.dart';
import 'package:searchable_dropdown/surchable_dropdown.dart';

import 'c_textbox.dart';

// ignore: must_be_immutable
class CSearchableDropdown<T> extends StatefulWidget {
  final Widget? Function(T) callback;
  final FutureOr<List<T>?> Function(String) suggestionList;
  Function(T)? onSelected;
  TextEditingController controller;
  FocusNode focusNode;
  Function(String v)? onTextChenge;
  Function(String v)? onSubmitted;
  void Function()? onTap;
  TextAlign? textAlign;
  double height;
  double width;
  Color bgColor;
  String label;
  bool showOnFocus;
  bool isDisable;
  bool isError;
  bool isDownIcon;
  EdgeInsetsGeometry? padding;
  BorderRadius? borderRadious;
  Color? disabledColor;

  CSearchableDropdown(
      {super.key,
      required this.callback,
      required this.suggestionList,
      required this.onSelected,
      required this.controller,
      required this.focusNode,
      this.onTextChenge,
      this.onSubmitted,
      this.textAlign = TextAlign.start,
      this.height = 26,
      this.width = double.infinity,
      this.label = '',
      this.showOnFocus = true,
      this.isDisable = false,
      this.bgColor = Colors.transparent,
      this.isError = false,
      this.borderRadious,
      this.isDownIcon = true,
      this.padding,
      this.onTap,this.disabledColor});

  @override
  _CSearchableDropdownState<T> createState() => _CSearchableDropdownState<T>();
}


class _CSearchableDropdownState<T> extends State<CSearchableDropdown<T>> {
  bool _isDisposed = false;
  bool _showAllOnFocus = false; // Flag to force showing full list on click/tap

  @override
  void initState() {
    super.initState();
    _isDisposed = false;

    // Listen to focus changes on the provided focusNode
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (widget.focusNode.hasFocus) {
      // Whenever field receives focus, trigger full list
      if (mounted) {
        setState(() {
          _showAllOnFocus = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTypeAheadField<T>(
      showOnFocus: widget.showOnFocus,
      focusNode: widget.focusNode,
      controller: widget.controller,
      builder: (context, controller, focusNode) {
        return Stack(
          children: [
            CTextBox(
              disabledColor: widget.disabledColor,
              onTap: () {
                // Force full list when tapped explicitly
                setState(() {
                  _showAllOnFocus = true;
                });
                widget.onTap?.call();
              },
              
              issuffixIcon: widget.isDownIcon,
              isError: widget.isError,
              borderRadious: widget.borderRadious,
              isDisable: widget.isDisable,
              height: widget.height,
              textAlign: widget.textAlign,
              controller: controller,
              focusNode: focusNode,
              width: widget.width,
              onChange: (v) {
                // When user actively types, revert back to normal filtering mode
                if (_showAllOnFocus) {
                  setState(() {
                    _showAllOnFocus = false;
                  });
                }

                if (widget.onTextChenge != null) {
                  widget.onTextChenge!(v);
                }
                setState(() {
                  widget.isError = false;
                });
              },
              onSubmitted: (v) {
                if (widget.onSubmitted != null) {
                  widget.onSubmitted!(v);
                }
              },
              label: widget.label,
            ),
            widget.isDisable
                ? Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Container(
                      color: Colors.transparent,
                    ),
                  )
                : const SizedBox.shrink()
          ],
        );
      },
      decorationBuilder: (context, child) => Material(
        color: Theme.of(context).cardTheme.color,
        type: MaterialType.card,
        elevation: 4,
        borderRadius: safeOutlineBorder(context).borderRadius,
        child: child,
      ),
      itemBuilder: (context, c) {
        Widget? result = widget.callback(c);
        return result != null
            ? Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: widget.padding ??
                          const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                      child: result,
                    ),
                  ),
                ],
              )
            : Container();
      },
      suggestionsCallback: (v) {
        // If _showAllOnFocus is true, pass an empty query "" to fetch ALL items.
        // Otherwise pass the actual pattern typed by the user.
        final query = _showAllOnFocus ? '' : v;
        return widget.suggestionList(query);
      },
      onSelected: (v) {
        if (!_isDisposed && mounted) {
          // Reset the flag after selection
          _showAllOnFocus = false;

          widget.onSelected!(v);
          setState(() {
            widget.isError = false;
          });
        }
      },
    );
  }
}

// class _CSearchableDropdownState<T> extends State<CSearchableDropdown<T>> {
//   bool _isDisposed = false; // Keep track if widget is disposed

//   @override
//   void initState() {
//     super.initState();
//     _isDisposed = false; // Not disposed when initialized
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final isDark =
//     // Theme.of(context).brightness == Brightness.dark;
//     return CupertinoTypeAheadField<T>(
//       showOnFocus: widget.showOnFocus,
//       focusNode: widget.focusNode,
//       controller: widget.controller,
//       builder: (context, controller, focusNode) {
//         return Stack(
//           children: [
//             CTextBox(
//               disabledColor: widget.disabledColor,
//               onTap: () => widget.onTap?.call(),
//               issuffixIcon: widget.isDownIcon,
//               //  fontSize: widget.fontSize,
//               isError: widget.isError,
//               borderRadious: widget.borderRadius,
//               //isFilled: true,
//               isDisable: widget.isDisable,
//               // fillColor: widget.bgColor,
//               height: widget.height,
//               textAlign: widget.textAlign,
//               // fontColor: widget.TextBoxTextColor,
//               // fontWeight: widget.FontWidth,
//               controller: controller,
//               focusNode: focusNode,
//               width: widget.width,
//               onChange: (v) {
//                 if (widget.onTextChenge != null) {
//                   widget.onTextChenge!(v);
//                 }
//                 setState(() {
//                   widget.isError = false;
//                 });
//               },
//               onSubmitted: (v) {
//                 if (widget.onSubmitted != null) {
//                   widget.onSubmitted!(v);
//                 }
//               },
//               label: widget.label,
//             ),
//             widget.isDisable
//                 ? Positioned(
//                     left: 0,
//                     right: 0,
//                     bottom: 0,
//                     top: 0,
//                     child: Container(
//                       color: Colors.transparent,
//                     ))
//                 : SizedBox.shrink()
//           ],
//         );
//       },
//       decorationBuilder: (context, child) => Material(
//         color: Theme.of(context)
//             .cardTheme
//             .color, //isDark?AppThemeColors.scaffoldBackground(context):Colors.white,
//         type: MaterialType.card,
//         elevation: 4,
//         borderRadius: safeOutlineBorder(context).borderRadius,
//         child: child,
//       ),
//       itemBuilder: (context, c) {
//         Widget? result = widget.callback(c);
//         return result != null
//             ? Row(
//                 children: [
//                   Flexible(
//                     child: Padding(
//                       padding: widget.padding ??
//                           const EdgeInsets.symmetric(
//                               horizontal: 4, vertical: 4),
//                       child: result,
//                     ),
//                   ),
//                 ],
//               )
//             : Container();
//       },
//       suggestionsCallback: (v) {
//         return widget.suggestionList(v);
//       },
//       onSelected: (v) {
//         if (!_isDisposed && mounted) {
//           // Check if not disposed
//           widget.onSelected!(v);
//           setState(() {
//             widget.isError = false;
//           });
//         }
//       },
//     );
//   }
// }
