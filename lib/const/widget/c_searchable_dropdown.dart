import 'dart:async';
import 'package:c_widget/const/c_helper.dart';
import 'package:c_widget/const/theme/colors.dart';
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
  TextAlign? textAlign;
  double height;
  double width;
  Color bgColor;
  String label;
  bool showOnFocus;
  bool isDisable;
  bool isError;
  bool isDownIcon;

  BorderRadius? borderRadius;

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
      this.borderRadius,this.isDownIcon=true});

  @override
  _CSearchableDropdownState<T> createState() =>
      _CSearchableDropdownState<T>();
}

class _CSearchableDropdownState<T>
    extends State<CSearchableDropdown<T>> {
  bool _isDisposed = false; // Keep track if widget is disposed

  @override
  void initState() {
    super.initState();
    _isDisposed = false; // Not disposed when initialized
  }

  @override
  Widget build(BuildContext context) {
    // final isDark =
    // Theme.of(context).brightness == Brightness.dark;
    return CupertinoTypeAheadField<T>(
      showOnFocus: widget.showOnFocus,
      focusNode: widget.focusNode,
      controller: widget.controller,
      builder: (context, controller, focusNode) {
        return Stack(
          children: [
            CTextBox(
              issuffixIcon: widget.isDownIcon,
              //  fontSize: widget.fontSize,
              isError: widget.isError,
              borderRadious: widget.borderRadius,
              //isFilled: true,
              isDisable: widget.isDisable,
              // fillColor: widget.bgColor,
              height: widget.height,
              textAlign: widget.textAlign,
              // fontColor: widget.TextBoxTextColor,
              // fontWeight: widget.FontWidth,
              controller: controller,
              focusNode: focusNode,
              width: widget.width,
              onChange: (v) {
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
            widget.isDisable?  Positioned(
            left: 0,right: 0,bottom: 0,top: 0,
            child: Container(color: Colors.transparent,)):SizedBox.shrink()
          ],
        );
      },
      
      decorationBuilder: (context, child) => Material(
        color: Theme.of(context).cardTheme.color, //isDark?AppThemeColors.scaffoldBackground(context):Colors.white,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 4),
                      child: result,
                    ),
                  ),
                ],
              )
            : Container();
      },
      suggestionsCallback: (v) {
        return widget.suggestionList(v);
      },
      onSelected: (v) {
        if (!_isDisposed && mounted) {
          // Check if not disposed
          widget.onSelected!(v);
          setState(() {
            widget.isError = false;
          });
        }
      },
    );
  }
}
