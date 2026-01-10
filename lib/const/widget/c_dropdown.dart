 
import 'package:c_widget/const/theme/colors.dart';
import 'package:flutter/material.dart';

import '../c_helper.dart';
import 'c_hover_container.dart';

// ignore: must_be_immutable
class CDropDown extends StatefulWidget {
  CDropDown(
      {super.key,
      required this.id,
      required this.list,
      required this.onTap,
      this.width = 100,
      this.height = 26,
      this.labeltext = 'Select',
      this.focusNode,
      this.isError = false,
      this.isAutoValidate = false,
      this.isScapeZeroValue = false,
      this.isDisable = false,
      this.borderRadious});
  bool isDisable;
  FocusNode? focusNode;
  double height;
  double? width;
  String? id;
  List<dynamic>? list;
  void Function(String? value) onTap;
  String? labeltext;

  bool isError;
  bool isAutoValidate;
  bool isScapeZeroValue;
  BorderRadius? borderRadious;

  @override
  State<CDropDown> createState() => _CDropDown2State();
}

class _CDropDown2State extends State<CDropDown> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputTheme = theme.inputDecorationTheme;
    final resolved =
        (inputTheme.contentPadding ?? EdgeInsets.symmetric(horizontal: 12))
            .resolve(Directionality.of(context));
    final scaled = resolved.copyWith(
      right: 5,
    );
    if (widget.isAutoValidate) {
      if (widget.id == '') {
        setState(() {
          widget.isError = true;
        });
      }
    }
    if ((widget.id ?? '') != '') {
      setState(() {
        widget.isError = false;
      });
    }
    return Stack(
      children: [
        CHoverMaskContainer(
          child: SizedBox(
            // margin: const EdgeInsets.only(left: 12,top: 12),
            width: widget.width,
            height: widget.height,
            child: DropdownButtonFormField(

//isDense: true,
itemHeight: null,


              dropdownColor: Theme.of(context).cardTheme.color,
              // itemHeight: 32,
              elevation: 3,
             enableFeedback:widget.isDisable?false:true ,
              icon: Icon(Icons.keyboard_arrow_down,
                  size: (((theme.textTheme.bodyLarge!.fontSize) ?? 16) * 1.5),
                  color: theme.colorScheme.secondary),
              padding: EdgeInsets.zero,
              focusNode: widget.focusNode,
              style:theme.textTheme.bodyMedium,
              value: (widget.isScapeZeroValue &&
                      (widget.id == '' || widget.id.toString() == '0'))
                  ? null
                  : widget.list!.where((e) => e.id == widget.id).isEmpty
                      ? null
                      : (widget.id == '' ? null : widget.id),
              items: widget.list!
                  .map((f) => DropdownMenuItem<String>(
                      value: f.id.toString(),
                      child: Text(
                        f.name!,
                        style: theme.textTheme.bodyMedium,
                      )))
                  .toList(),
              onChanged: (v) {
                setState(() {
                  widget.isError = true;
                  widget.id = v;
                });
                widget.onTap(v);
              },
             
              //  dropdownColor: AppThemeColors.scaffoldBackground(context),
              decoration: InputDecoration(
                  //  enabled: false,
                  fillColor: widget.isDisable
                      ? Colors.grey[theme.brightness == Brightness.dark ? 600 : 50]
                      : inputTheme.fillColor,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  // fillColor: Colors.white,
                  filled: true,
                  // focusColor: Colors.white,
                  labelText: widget.labeltext,
                  labelStyle: clabelStyle(context, widget.isError),
                  // hintText: widget.,
            
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
                  disabledBorder: CBorders.disabled(context,
                      borderRadious: widget.borderRadious),
                  contentPadding: scaled
            
                
                  ),
              isDense: true,
              isExpanded: true,
            ),
          ),
        ),
      
      widget.isDisable?  Positioned(
            left: 0,right: 0,bottom: 0,top: 0,
            child: Container(color: Colors.transparent,)):SizedBox.shrink()
      ],
    );
  }
}
