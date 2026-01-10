import 'package:c_widget/const/c_helper.dart';
import 'package:flutter/material.dart';

// New constructor that accepts context
class AppThemeColors {
  final Color normalBg;
  final Color hoverBg;
  final Color selectedBg;
  final Color normalText;
  final Color hoverText;
  final Color crossNormal;
  final Color crossHover;
  final Color borderColor;

  AppThemeColors(
    BuildContext context, {
    Color? overrideColor,
    Color? overrideTextColor,
  })  : normalBg = overrideColor ??
            Theme.of(context).colorScheme.surfaceVariant.withOpacity(.6),
        hoverBg = Theme.of(context).colorScheme.primary.withOpacity(.05),
        selectedBg = Theme.of(context).colorScheme.primary.withOpacity(.3),

        // ---------- TEXT COLOR (SAFE) ----------
        normalText = overrideTextColor ??
            (Theme.of(context).textTheme.bodyMedium?.color ??
                Theme.of(context).colorScheme.onSurface),
        hoverText = Theme.of(context).colorScheme.primary,
        crossNormal = Theme.of(context).colorScheme.primary,
        crossHover = Theme.of(context).colorScheme.error,

        // ---------- BORDER COLOR (FULLY SAFE) ----------
        borderColor = (() {
          final inputTheme = Theme.of(context).inputDecorationTheme;
          final enabled = inputTheme.enabledBorder;

          if (enabled is OutlineInputBorder) {
            return enabled.borderSide.color;
          }

          // fallback color if no border found
          return Theme.of(context).colorScheme.outline;
        })();

  /// Returns InputBorder style for enabled, disabled, or focused state
  static OutlineInputBorder inputBorder(
    BuildContext context, {
    bool isEnabled = true,
    bool isFocused = false,
  }) {
    final inputTheme = Theme.of(context).inputDecorationTheme;
    final fallback = safeOutlineBorder(context);

    // --- Convert ANY border to safe OutlineInputBorder ---
    OutlineInputBorder toSafe(InputBorder? b) {
      if (b is OutlineInputBorder) {
        return b;
      }

      if (b != null) {
        return fallback.copyWith(
          borderSide: b.borderSide,
        );
      }

      return fallback;
    }

    final enabledBorder = toSafe(inputTheme.enabledBorder);
    final focusedBorder = toSafe(inputTheme.focusedBorder);
    final disabledBorder = toSafe(inputTheme.disabledBorder);

    if (!isEnabled) return disabledBorder;
    if (isFocused) return focusedBorder;

    return enabledBorder;
  }

  /// Get border width
  static double borderWidth(BuildContext context,
      {bool isEnabled = true, bool isFocused = false}) {
    return inputBorder(context, isEnabled: isEnabled, isFocused: isFocused)
        .borderSide
        .width;
  }

  static double iconSize(BuildContext context) =>
      (((Theme.of(context).textTheme.bodyLarge!.fontSize) ?? 16) * 1.5);
  static Color iconColor(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;

  /// Get border color
  static Color borderColorStatic(BuildContext context,
      {bool isEnabled = true, bool isFocused = false}) {
    return inputBorder(context, isEnabled: isEnabled, isFocused: isFocused)
        .borderSide
        .color;
  }


  /// Get font size from InputDecoration
  static double fontSize(BuildContext context) {
    final theme = Theme.of(context);
    return theme.inputDecorationTheme.labelStyle?.fontSize ?? 12;
  }

  /// Get primary color
  static Color primary(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  /// Get secondary color
  static Color secondary(BuildContext context) {
    return Theme.of(context).colorScheme.secondary;
  }

  /// Get scaffold background color
  static Color scaffoldBackground(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  static Color windowColor(BuildContext context) {
    return Theme.of(context).cardTheme.color as Color;
  }


  
  static Color toolBarColor(BuildContext context) => (Theme.of(context).brightness == Brightness.dark)
      ? Colors.grey[700]!
      : Colors.white;

  static TextStyle bodySmall(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!;
  static TextStyle bodyMedium(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!;
  static TextStyle bodyLarge(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!;
  static TextStyle titleSmall(BuildContext context) =>
      Theme.of(context).textTheme.titleSmall!;
  static TextStyle titleMedium(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium!;
  static InputDecorationTheme inputDecorationTheme(BuildContext context) =>
      Theme.of(context).inputDecorationTheme;
}
