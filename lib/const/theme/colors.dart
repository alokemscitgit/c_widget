import 'package:flutter/material.dart';

/// Extension on BuildContext for quick access to Theme Colors and Chainable Text Styles
extension CAppThemeX on BuildContext {
  /// Theme Colors: context.color.primary, context.color.normalBg, etc.
  _AppColors get color => _AppColors(this);

  /// Chainable Text Styles & UI Metrics: context.style.bodySmall.bold, context.style.scale, etc.
  _AppStyles get style => _AppStyles(this);

  /// Quick dark mode check directly on context: context.isDark
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Optional override wrapper for color parameters
  _AppColors withColorOverrides({Color? overrideColor, Color? overrideTextColor}) =>
      _AppColors(this, overrideColor: overrideColor, overrideTextColor: overrideTextColor);
}

// ============================================================================
// 1. CONTEXT.COLOR (All Color Properties & Color Logic)
// ============================================================================
class _AppColors {
  final BuildContext context;
  final Color? _overrideColor;
  final Color? _overrideTextColor;

  const _AppColors(
    this.context, {
    Color? overrideColor,
    Color? overrideTextColor,
  })  : _overrideColor = overrideColor,
        _overrideTextColor = overrideTextColor;

  ThemeData get _theme => Theme.of(context);
  ColorScheme get _scheme => _theme.colorScheme;
  TextTheme get _textTheme => _theme.textTheme;

  // Primary & Secondary
  Color get primary => _scheme.primary;
  Color get secondary => _scheme.secondary;
  Color get onPrimary => _scheme.onPrimary;

  // Buttons
  Color get buttonBg =>
      _theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}) ?? primary;
  Color get buttonTextColor =>
      _theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}) ?? onPrimary;

  // Surfaces & Backgrounds
  Color get card => _theme.cardColor;
  Color get scaffold => _theme.scaffoldBackgroundColor;
  Color get scaffoldBackground => scaffold;
  Color get error => _scheme.error;
  Color get windowColor => _theme.cardTheme.color ?? _theme.cardColor;
  Color get toolBarColor => context.isDark ? Colors.grey[700]! : Colors.white;

  // Dynamic Theme Colors
  Color get selectedRowColor =>
      secondary.withValues(alpha: context.isDark ? 0.08 : 0.02);
  Color get animColor => primary.withValues(alpha: 0.18);
  Color get autoTextColor => context.isDark ? Colors.white : Colors.black;
  Color get autoBgColor => context.isDark ? Colors.black : Colors.white;

  // State & Surface Colors (AppThemeColors overrides)
  Color get normalBg =>
      _overrideColor ?? _scheme.surfaceContainerHighest.withValues(alpha: 0.6);
  Color get hoverBg => primary.withValues(alpha: 0.05);
  Color get selectedBg => primary.withValues(alpha: 0.3);
Color get disabledColor=>Colors.grey[_theme.brightness == Brightness.dark ? 700 : 50]!;
  // Text Colors
  Color get normalText =>
      _overrideTextColor ?? (_textTheme.bodyMedium?.color ?? _scheme.onSurface);
  Color get hoverText => primary;
  Color get crossNormal => primary;
  Color get crossHover => error;

  // Icons
  Color get iconColor => secondary;

  // Border Colors
  Color get borderColor {
    final enabled = _theme.inputDecorationTheme.enabledBorder;
    if (enabled is OutlineInputBorder) {
      return enabled.borderSide.color;
    }
    return _scheme.outline;
  }

  Color borderColorStatic({bool isEnabled = true, bool isFocused = false}) =>
      context.style.inputBorder(isEnabled: isEnabled, isFocused: isFocused).borderSide.color;
}

// ============================================================================
// 2. CONTEXT.STYLE (Text Styles, Chainable Builders & UI Metrics)
// ============================================================================
class _AppStyles {
  final BuildContext context;
  const _AppStyles(this.context);

  ThemeData get _theme => Theme.of(context);
  TextTheme get _textTheme => _theme.textTheme;

  // Chainable Text Styles
  _StyleBuilder get bodySmall => _StyleBuilder(context, _textTheme.bodySmall ?? const TextStyle());
  _StyleBuilder get bodyMedium => _StyleBuilder(context, _textTheme.bodyMedium ?? const TextStyle());
  _StyleBuilder get bodyLarge => _StyleBuilder(context, _textTheme.bodyLarge ?? const TextStyle());
  _StyleBuilder get titleSmall => _StyleBuilder(context, _textTheme.titleSmall ?? const TextStyle());
  _StyleBuilder get titleMedium => _StyleBuilder(context, _textTheme.titleMedium ?? const TextStyle());
  _StyleBuilder get titleLarge => _StyleBuilder(context, _textTheme.titleLarge ?? const TextStyle());
  
  // Custom Error Preset
  _StyleBuilder get txtError => bodyLarge.errorText;

  // Input Theme & Sizes
  InputDecorationTheme get inputDecorationTheme => _theme.inputDecorationTheme;
  double get fontSize => inputDecorationTheme.labelStyle?.fontSize ?? 12;
  double get iconSize => (((_textTheme.bodyLarge?.fontSize) ?? 16) * 1.5);

  // Borders & Border Metrics
  OutlineInputBorder get safeOutlineBorder => OutlineInputBorder(
        borderSide: BorderSide(color: context.color.borderColor),
      );

  OutlineInputBorder inputBorder({
    bool isEnabled = true,
    bool isFocused = false,
  }) {
    final inputTheme = _theme.inputDecorationTheme;
    final fallback = safeOutlineBorder;

    OutlineInputBorder toSafe(InputBorder? b) {
      if (b is OutlineInputBorder) return b;
      if (b != null) return fallback.copyWith(borderSide: b.borderSide);
      return fallback;
    }

    final enabledBorder = toSafe(inputTheme.enabledBorder);
    final focusedBorder = toSafe(inputTheme.focusedBorder);
    final disabledBorder = toSafe(inputTheme.disabledBorder);

    if (!isEnabled) return disabledBorder;
    if (isFocused) return focusedBorder;
    return enabledBorder;
  }

  double borderWidth({bool isEnabled = true, bool isFocused = false}) =>
      inputBorder(isEnabled: isEnabled, isFocused: isFocused).borderSide.width;

  // Screen Scale Calculation
  double get scale {
    final w = MediaQuery.of(context).size.width;
    if (w < 700) return 0.9;
    if (w < 1130) return 0.92;
    if (w < 1650) return 0.94;
    if (w < 1920) return 0.96;
    return 0.98;
  }
}

// ============================================================================
// 3. STYLEBUILDER (Fluent Wrapper around TextStyle)
// ============================================================================
class _StyleBuilder {
  final BuildContext context;
  final TextStyle style;

  const _StyleBuilder(this.context, this.style);

  /// Implicit getter to extract the raw TextStyle when needed
  TextStyle get setStyle => style;

  // ---------- FONT STYLE ----------
  _StyleBuilder get italic => _StyleBuilder(context, style.copyWith(fontStyle: FontStyle.italic));
  _StyleBuilder get normal => _StyleBuilder(context, style.copyWith(fontStyle: FontStyle.normal));

  // ---------- FONT WEIGHT ----------
  _StyleBuilder get bold => _StyleBuilder(context, style.copyWith(fontWeight: FontWeight.bold));
  _StyleBuilder get semiBold => _StyleBuilder(context, style.copyWith(fontWeight: FontWeight.w600));
  _StyleBuilder get light => _StyleBuilder(context, style.copyWith(fontWeight: FontWeight.w300));

  // ---------- COLORS ----------
  _StyleBuilder get colorBlack => _StyleBuilder(context, style.copyWith(color: Colors.black));
  _StyleBuilder get colorWhite => _StyleBuilder(context, style.copyWith(color: Colors.white));
  _StyleBuilder get colorGrey => _StyleBuilder(context, style.copyWith(color: Colors.grey));
  _StyleBuilder get colorButtonText =>
      _StyleBuilder(context, style.copyWith(color: context.color.buttonTextColor));

  /// Custom color method (works clean now because _StyleBuilder doesn't inherit TextStyle.color)
  _StyleBuilder withColor(Color color) => _StyleBuilder(context, style.copyWith(color: color));

  _StyleBuilder get darklightText => _StyleBuilder(
        context,
        style.copyWith(
          color: context.isDark ? context.color.primary : Colors.white,
        ),
      );

  _StyleBuilder get errorText => _StyleBuilder(context, style.copyWith(color: Colors.red));

  // ---------- SIZE & DECORATION ----------
  _StyleBuilder size(double value) => _StyleBuilder(context, style.copyWith(fontSize: value));
  _StyleBuilder get underline => _StyleBuilder(context, style.copyWith(decoration: TextDecoration.underline));
}