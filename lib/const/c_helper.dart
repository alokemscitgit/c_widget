import 'package:flutter/material.dart';

class CBorders {
  const CBorders._(); // private constructor

  /// Returns a border using the theme's InputDecorationTheme
  static OutlineInputBorder border({
  required BuildContext context,
  bool isError = false,
  BorderRadius? borderRadious,
  Color? borderColor,
  bool isFocused = false,
  bool isDisabled = false,
}) {
  final theme = Theme.of(context);
  final inputTheme = theme.inputDecorationTheme;

  // Fallback safe border
  final fallback = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(
      color: theme.colorScheme.outline,
      width: 1,
    ),
  );

  // Convert any InputBorder to OutlineInputBorder safely
  OutlineInputBorder toSafe(InputBorder? b) {
    if (b is OutlineInputBorder) return b;

    if (b != null) {
      return fallback.copyWith(borderSide: b.borderSide);
    }

    return fallback;
  }

  final enabled = toSafe(inputTheme.enabledBorder);
  final focused = toSafe(inputTheme.focusedBorder);
  final disabled = toSafe(inputTheme.disabledBorder);

  OutlineInputBorder base;

  if (isDisabled) {
    base = disabled;
  } else if (isFocused) {
    base = focused;
  } else {
    base = enabled;
  }

  return base.copyWith(
    borderRadius: borderRadious ?? base.borderRadius,
    borderSide: BorderSide(
      color: borderColor ?? (isError ? Colors.red : base.borderSide.color),
      width: base.borderSide.width,
    ),
  );
}

  static OutlineInputBorder enabled(BuildContext context,
          {bool isError = false, BorderRadius? borderRadious}) =>
      border(context: context, isError: isError, borderRadious: borderRadious);

  static OutlineInputBorder focused(BuildContext context,
          {bool isError = false, BorderRadius? borderRadious}) =>
      border(
          context: context,
          isError: isError,
          borderRadious: borderRadious,
          isFocused: true);

  static OutlineInputBorder disabled(BuildContext context,
          {BorderRadius? borderRadious}) =>
      border(context: context, borderRadious: borderRadious, isDisabled: true);
}


OutlineInputBorder safeOutlineBorder(BuildContext context) {
  final input = Theme.of(context).inputDecorationTheme;

  if (input.enabledBorder is OutlineInputBorder) {
    return input.enabledBorder as OutlineInputBorder;
  }

  return const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6)),
    borderSide: BorderSide(color: Colors.grey, width: 1),
  );
}

TextStyle clabelStyle(BuildContext context, bool isError)   {
  
     
   final labelStyle = Theme.of(context).inputDecorationTheme.labelStyle;

  final Color safeColor =isError
      ? Colors.red
      : (labelStyle?.color ?? Colors.black).withOpacity(.6);

  return (labelStyle ?? const TextStyle( fontSize: 12 )).copyWith(
    color: safeColor,
  );
}



