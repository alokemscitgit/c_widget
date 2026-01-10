import 'package:flutter/material.dart';

enum AppThemeKeys {
  lightGreen,
  blue,
  dark,
  purple,
  orange,
  mintGlass,
  royalGold,
  coolGrey,
  sunsetRed,
  tinyhtGreen
}

ThemeData generateThemeData(
  AppThemeKeys key,
  BuildContext context, {
  String? fontFamily, // NEW: dynamic font
}) {
  final size = MediaQuery.of(context).size;
  final deviceType = _getDeviceType(size.width);

  // Define dynamic font scale by device type
  final scale = switch (deviceType) {
    DeviceType.mobile => 0.9,
    DeviceType.tablet => .94,
    DeviceType.desktop => 1.0,
  };

  switch (key) {
    case AppThemeKeys.lightGreen:
      return _lightGreenTheme(scale, fontFamily);
    case AppThemeKeys.blue:
      return _blueTheme(scale, fontFamily);
    case AppThemeKeys.dark:
      return _darkTheme(scale, fontFamily);
    case AppThemeKeys.purple:
      return _purpleTheme(scale, fontFamily);
    case AppThemeKeys.orange:
      return _orangeTheme(scale, fontFamily);
    case AppThemeKeys.mintGlass:
      return _mintGlassTheme(scale, fontFamily);
    case AppThemeKeys.royalGold:
      return _royalGoldTheme(scale, fontFamily);
    case AppThemeKeys.coolGrey:
      return _coolGreyTheme(scale, fontFamily);
    case AppThemeKeys.sunsetRed:
      return _sunsetRedTheme(scale, fontFamily);
    case AppThemeKeys.tinyhtGreen:
      return _tinyGreenTheme(scale, fontFamily);
  }
}

enum DeviceType { mobile, tablet, desktop }

DeviceType _getDeviceType(double width) {
  if (width < 700) return DeviceType.mobile;
  if (width < 1150) return DeviceType.tablet;
  return DeviceType.desktop;
}

ThemeData _lightGreenTheme(double s, String? fontFamily) {
  const primary = Color(0xFF4CAF50);
  const secondary = Color.fromARGB(255, 122, 170, 67);
  const bg = Color(0xFFF8F8F8);
  const font = Color.fromARGB(255, 0, 37, 2);
  const panel = Color(0xFFE6F5E9);

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
        seedColor: primary, secondary: secondary, brightness: Brightness.light),
    scaffoldBackgroundColor: bg,
    appBarTheme:
        const AppBarTheme(backgroundColor: panel, foregroundColor: font),
    textTheme: _textTheme(font, s, fontFamily: fontFamily),
    inputDecorationTheme: _inputDecoration(
        font, primary, Colors.grey.shade400, s,
        fill: Colors.white, fontFamily: fontFamily),
    elevatedButtonTheme:
        _buttonTheme(primary, Colors.white, s, fontFamily: fontFamily),
    cardTheme: _cardTheme(),
    scrollbarTheme: _scrollbarTheme(secondary),
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 56, 105, 0),
      size: 20,
    ),
    //datePickerTheme: _calendarTheme(primary,font,s)
  );
}

ThemeData _blueTheme(double s, String? fontFamily) {
  // Premium blue palette (refined)
  const primary = Color(0xFF1E88E5); // Slightly deeper & modern blue
  const secondary = Color(0xFF64B5F6); // Softer accent blue
  const bg = Color(0xFFF4F7FA); // Cleaner light background
  const font = Color(0xFF1C2A38); // Deep readable text
  const panel = Color(0xFF1976D2); // AppBar blue (clean, strong)

  return ThemeData(
    useMaterial3: true,

    // ----------- ColorScheme -----------
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      background: bg,
      brightness: Brightness.light,
    ),

    scaffoldBackgroundColor: bg,

    // ----------- AppBar -----------
    appBarTheme: const AppBarTheme(
      backgroundColor: panel,
      foregroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.black26,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    // ----------- Typography -----------
    textTheme: _textTheme(font, s, fontFamily: fontFamily),

    // ----------- Inputs -----------
    inputDecorationTheme: _inputDecoration(
        font,
        primary,
        const Color(0xFFB0BEC5), // soft bluish-grey border
        s,
        fill: Colors.white,
        fontFamily: fontFamily),

    // ----------- Buttons -----------
    elevatedButtonTheme:
        _buttonTheme(primary, Colors.white, s, fontFamily: fontFamily),

    // ----------- Cards -----------
    cardTheme: _cardTheme().copyWith(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black12,
    //  margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // ----------- Scrollbars -----------
    scrollbarTheme: _scrollbarTheme(secondary),

    // ----------- Divider -----------
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade300,
      thickness: 1,
      space: 20,
    ),

    // ----------- Icons -----------
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 0, 109, 204),
      size: 20,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
  );
}

ThemeData _darkTheme(double s, String? fontFamily) {
  const accent = Color(0xFFFFA726);
  const secondary = Color.fromARGB(255, 255, 191, 95);
  const font = Color(0xFFF5F5F5);
  const panel = Color(0xFF1A1A1A);
  const group = Color(0xFF3D3D3D);

  return ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(
        primary: accent,
        seedColor: accent,
        secondary: secondary,
        brightness: Brightness.dark,
        error: Colors.redAccent),
    scaffoldBackgroundColor: const Color(0xFF2C2C2C),
    appBarTheme:
        const AppBarTheme(backgroundColor: panel, foregroundColor: font),
    textTheme: _textTheme(font, s, fontFamily: fontFamily),
    inputDecorationTheme: _inputDecoration(
        font, accent, Colors.grey.shade600, s,
        fill: group, fontFamily: fontFamily),
    elevatedButtonTheme:
        _buttonTheme(accent, Colors.black, s, fontFamily: fontFamily),
    cardTheme: _cardTheme(color: group),
    // datePickerTheme: _calendarTheme(accent,font,s)
    scrollbarTheme: _scrollbarTheme(secondary),
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 252, 198, 118),
      size: 20,
    ),
  );
}

ScrollbarThemeData _scrollbarTheme(Color secondery) => ScrollbarThemeData(
      thumbVisibility: WidgetStateProperty.all(true),
      trackVisibility: WidgetStateProperty.all(true),
      thickness: WidgetStateProperty.all(6),
      radius: const Radius.circular(8),

      // Auto uses theme colors
      thumbColor: WidgetStateProperty.all(secondery),
      trackColor: WidgetStateProperty.all(secondery.withOpacity(.1)),
    );

ThemeData _purpleTheme(double s, String? fontFamily) {
  const primary = Color(0xFF9B59B6);
  const secondary = Color.fromARGB(255, 237, 132, 255);
  const bg = Color(0xFFF3E5F5);
  const font = Color(0xFF2E004F);
  const panel = Color(0xFFDCC6E0);

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primary, secondary: secondary),
    scaffoldBackgroundColor: bg,
    appBarTheme:
        const AppBarTheme(backgroundColor: panel, foregroundColor: font),
    textTheme: _textTheme(font, s, fontFamily: fontFamily),
    inputDecorationTheme: _inputDecoration(
        font, primary, Colors.grey.shade400, s,
        fontFamily: fontFamily),
    elevatedButtonTheme:
        _buttonTheme(primary, Colors.white, s, fontFamily: fontFamily),
    cardTheme: _cardTheme(),
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 129, 1, 180),
      size: 20,
    ),
    //datePickerTheme: _calendarTheme(primary,font,s)
  );
}

ThemeData _orangeTheme(double s, String? fontFamily) {
  const primary = Color(0xFFFF7043);
  const secondary = Color(0xFFFFA726);
  const bg = Color(0xFFFFF3E0);
  const font = Color(0xFF4E342E);
  const panel = Color(0xFFFFCCBC);

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
        seedColor: primary, secondary: const Color.fromARGB(255, 206, 138, 35)),
    scaffoldBackgroundColor: bg,
    appBarTheme:
        const AppBarTheme(backgroundColor: panel, foregroundColor: font),
    textTheme: _textTheme(font, s, fontFamily: fontFamily),
    inputDecorationTheme: _inputDecoration(
        font, primary, Colors.grey.shade400, s,
        fontFamily: fontFamily),
    elevatedButtonTheme:
        _buttonTheme(primary, Colors.white, s, fontFamily: fontFamily),
    cardTheme: _cardTheme(),
    scrollbarTheme: _scrollbarTheme(secondary),
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 206, 49, 1),
      size: 20,
    ),
    //   datePickerTheme: _calendarTheme(primary,font,s)
  );
}

ThemeData _mintGlassTheme(double s, String? fontFamily) {
  const primary = Color(0xFF00C4B4); // mint/cyan
  const secondary = Color.fromARGB(255, 72, 122, 118); // lighter mint
  const bg = Color(0xFFEFFAF9); // very light mint for scaffold
  const font = Color(0xFF003D39); // dark teal for readability
  const panel = Color(0xCCFFFFFF);

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primary, secondary: secondary),
    scaffoldBackgroundColor: bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: panel,
      foregroundColor: font,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: Colors.white.withOpacity(0.6),
      elevation: 6,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
    textTheme: _textTheme(font, s, fontFamily: fontFamily),
    inputDecorationTheme: _inputDecoration(
      font,
      primary,
      Colors.teal.shade200,
      s,
      fontFamily: fontFamily,
      fill: Colors.white.withOpacity(0.7),
    ),
    elevatedButtonTheme:
        _buttonTheme(primary, Colors.white, s, fontFamily: fontFamily),
    scrollbarTheme: _scrollbarTheme(secondary),
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 0, 119, 109),
      size: 20,
    ),
    // datePickerTheme: _calendarTheme(primary,font,s)
  );
}

ThemeData _royalGoldTheme(double s, String? fontFamily) {
  const primary = Color(0xFFD4AF37);
  const secondary = Color.fromARGB(255, 155, 139, 89);
  const bg = Color(0xFFFDFCF7);
  const font = Color(0xFF3A2F0B);
  const panel = Color(0xFFE8D9A8);

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primary, secondary: secondary),
    scaffoldBackgroundColor: bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: panel,
      foregroundColor: font,
    ),
    textTheme: _textTheme(font, s, fontFamily: fontFamily),
    inputDecorationTheme: _inputDecoration(
        font, primary, Colors.brown.shade300, s,
        fontFamily: fontFamily),
    elevatedButtonTheme: _buttonTheme(Color(0xFFB8962D), Colors.white, s,
        fontFamily: fontFamily),
    cardTheme: _cardTheme(color: Colors.white),
    scrollbarTheme: _scrollbarTheme(secondary),
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 153, 117, 0),
      size: 20,
    ),
    // datePickerTheme: _calendarTheme(primary,font,s)
  );
}

ThemeData _coolGreyTheme(double s, String? fontFamily) {
  const primary = Color(0xFF546E7A);
  const secondary = Color(0xFF78909C);
  const bg = Color(0xFFF4F6F7);
  const font = Color(0xFF263238);
  const panel = Color(0xFFE8ECEF);

  return ThemeData(
    useMaterial3: true,
    // dropdownMenuTheme: _dropdownMenuTheme(),

    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      secondary: secondary,
    ),
    scaffoldBackgroundColor: bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: panel,
      foregroundColor: font,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    textTheme: _textTheme(font, s, fontFamily: fontFamily),
    inputDecorationTheme: _inputDecoration(
        font, primary, Colors.grey.shade400, s,
        fontFamily: fontFamily),
    elevatedButtonTheme:
        _buttonTheme(primary, Colors.white, s, fontFamily: fontFamily),
    scrollbarTheme: _scrollbarTheme(secondary),
    drawerTheme: DrawerThemeData(backgroundColor: Color(0xe3e8f0)),
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 0, 66, 97),
      size: 20,
    ),
    //iconTheme: IconThemeData(color:secondary,size: s*20 )
    //datePickerTheme: _calendarTheme(primary,font,s)
  );
}

ThemeData _sunsetRedTheme(double s, String? fontFamily) {
  const primary = Color(0xFFE74C3C);
  const secondary = Color.fromARGB(255, 145, 99, 94);
  const bg = Color(0xFFFFF5F4);
  const font = Color(0xFF641E16);
  const panel = Color(0xFFFFCFC9);

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primary, secondary: secondary),
    scaffoldBackgroundColor: bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: panel,
      foregroundColor: font,
    ),
    textTheme: _textTheme(font, s, fontFamily: fontFamily),
    inputDecorationTheme: _inputDecoration(
        font, primary, Colors.red.shade200, s,
        fontFamily: fontFamily),
    elevatedButtonTheme:
        _buttonTheme(primary, Colors.white, s, fontFamily: fontFamily),
    cardTheme: _cardTheme(),
    scrollbarTheme: _scrollbarTheme(secondary),
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 230, 23, 0),
      size: 20,
    ),
    // datePickerTheme: _calendarTheme(primary,font,s)
  );
}

ThemeData _tinyGreenTheme(double s, String? fontFamily) {
  // Facebook-style Green Color Palette
  const primary =
      Color(0xFF008141); // FB-style strong green (acts like FB blue)
  const secondary = Color(0xFF4CAF7B); // soft green accent
  const bg = Color(0xFFF4F7F5); // FB-like light background
  const font = Color(0xFF1F3B2D); // deep readable text
  const panel = Color(0xFFFFFFFF); // white panel like FB cards

  return ThemeData(
    useMaterial3: true,

    // ===== Color Scheme =====
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      background: bg,
      brightness: Brightness.light,
    ),

    scaffoldBackgroundColor: bg,

    // ===== AppBar ===== (FB style = white, small shadow, bold title)
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      shadowColor: Colors.black12,
      foregroundColor: primary,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
    ),

    // ===== Text Theme =====
    textTheme: _textTheme(font, s, fontFamily: fontFamily),

    // ===== Input Decoration =====
    inputDecorationTheme: _inputDecoration(
        font,
        primary,
        const Color(0xFFB9DAC6), // subtle border like FB
        s,
        fill: Colors.white,
        fontFamily: fontFamily // FB uses white input background
        ),

    // ===== Buttons ===== (FB uses solid primary color)
    elevatedButtonTheme:
        _buttonTheme(primary, Colors.white, s, fontFamily: fontFamily),

    // ===== Card Theme ===== (FB cards are white with light radius & shadow)
    cardTheme: _cardTheme(),

    // ===== Scrollbar =====
    scrollbarTheme: _scrollbarTheme(secondary),

    // ===== Icon Theme =====
    iconTheme: const IconThemeData(
      color: primary,
      size: 20,
    ),

    // ===== Divider ===== (Facebook uses very soft dividers)
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade300,
      thickness: 1,
    ),

    // ===== Chip Theme =====
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: secondary.withOpacity(0.3),
      labelStyle: TextStyle(
        color: font,
        fontSize: 12 * s,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    ),
  );
}

TextTheme _textTheme(Color color, double s, {String? fontFamily}) {
  double size(double base) => (base * s).clamp(11, 24);
  return TextTheme(
    bodyLarge:
        TextStyle(color: color, fontSize: size(13), fontFamily: fontFamily),
    bodyMedium: TextStyle(
        color: color,
        fontSize: size(10),
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily),
    bodySmall:
        TextStyle(color: color, fontSize: size(9), fontFamily: fontFamily),
    titleLarge: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: size(18),
        fontFamily: fontFamily),
    titleMedium: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: size(16),
        fontFamily: fontFamily),
    titleSmall: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: size(13),
        fontFamily: fontFamily),
    headlineSmall: TextStyle(
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: size(16),
        fontFamily: fontFamily),
  );
}

/// -----------------------------
/// Input Decoration Theme
/// -----------------------------
InputDecorationTheme _inputDecoration(
    Color font, Color focus, Color border, double s,
    {Color? fill, String? fontFamily}) {
  return InputDecorationTheme(
    filled: true,
    fillColor: fill ?? Colors.white,
    contentPadding:
        EdgeInsets.symmetric(horizontal: 12 * s).copyWith(bottom: 2),
    labelStyle:
        TextStyle(color: font, fontSize: 11 * s, fontFamily: fontFamily),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
    focusedErrorBorder:
        OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: border, width: 1.1),
        borderRadius: BorderRadius.circular(4)),
    disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: border.withOpacity(0.5), width: 1.4),
        borderRadius: BorderRadius.circular(6)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: focus, width: .8),
        borderRadius: BorderRadius.circular(4)),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4), gapPadding: 0),
    suffixIconConstraints: const BoxConstraints(minWidth: 28, minHeight: 20),
  );
}

/// -----------------------------
/// Elevated Button Theme
/// -----------------------------
ElevatedButtonThemeData _buttonTheme(Color bg, Color fg, double s,
    {String? fontFamily}) {
  double size(double v) => (v * s).clamp(10, 14);
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: size(s),
        fontFamily: fontFamily,
      ),
      padding: EdgeInsets.symmetric(horizontal: 14 * s, vertical: 6 * s),
      minimumSize: Size(64 * s, 32 * s),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
    ),
  );
}

/// -----------------------------
/// Card Theme
/// -----------------------------
CardTheme _cardTheme({Color? color}) => CardTheme(
      color: color ?? Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(),
      margin: const EdgeInsets.all(8),
    );
DatePickerThemeData _calendarTheme(Color primary, Color font, double s) {
  return DatePickerThemeData(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    elevation: 2,
    shadowColor: Colors.black26,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

    // Header
    headerBackgroundColor: primary.withOpacity(.15),
    headerForegroundColor: font,
    headerHeadlineStyle: TextStyle(
      fontSize: 18 * s,
      fontWeight: FontWeight.w700,
      color: font,
    ),
    headerHelpStyle: TextStyle(
      fontSize: 12 * s,
      color: font.withOpacity(.7),
    ),

    // Weekday style
    weekdayStyle: TextStyle(
      fontSize: 12 * s,
      color: primary.withOpacity(.8),
      fontWeight: FontWeight.w600,
    ),

    // Day cells
    dayStyle: TextStyle(
      fontSize: 12 * s,
      fontWeight: FontWeight.w600,
    ),
    dayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) return font.withOpacity(.5);
      if (states.contains(MaterialState.selected)) return Colors.white;
      return font;
    }),
    dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected))
        return primary.withOpacity(0.2);
      return null;
    }),
    dayOverlayColor: WidgetStateProperty.all(primary.withOpacity(.2)),

    // Today
    todayForegroundColor: WidgetStateProperty.all(primary.withBlue(100)),
    todayBackgroundColor: WidgetStateProperty.all(primary.withOpacity(.6)),

    // Year picker
    yearStyle: TextStyle(
      fontSize: 14 * s,
      fontWeight: FontWeight.w600,
    ),
    yearForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) return Colors.white;
      return font;
    }),
    yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) return primary;
      return primary.withOpacity(.15);
    }),
  );
}

class ThemeProvider with ChangeNotifier {
  AppThemeKeys _themeKey = AppThemeKeys.coolGrey;
  String _fontFamily = "Roboto"; // Default font

  AppThemeKeys get themeKey => _themeKey;
  String get fontFamily => _fontFamily;

  ThemeData getTheme(BuildContext context) =>
      generateThemeData(_themeKey, context, fontFamily: _fontFamily);

  void setTheme(AppThemeKeys key) {
    if (key != _themeKey) {
      _themeKey = key;
      notifyListeners();
    }
  }

  void setFontFamily(String font) {
    if (font != _fontFamily) {
      _fontFamily = font;
      notifyListeners();
    }
  }
}


// class ThemeProvider1 with ChangeNotifier {
//   AppThemeKeys _themeKey = AppThemeKeys.coolGrey;

//   AppThemeKeys get themeKey => _themeKey;

//   // -----------------
//   // Load Theme
//   // -----------------
//   Future<void> loadTheme() async {
//     final prefs = await SharedPreferences.getInstance();
//     final saved = prefs.getString("themeKey");

//     if (saved != null) {
//       _themeKey = themeKeyFromString(saved);
//       notifyListeners();
//     }
//   }

//   // -----------------
//   // Current Theme
//   // -----------------
//   ThemeData getTheme(BuildContext context) =>
//       generateThemeData(_themeKey, context);

//   // -----------------
//   // Change Theme + Save to SharedPreferences
//   // -----------------
//   Future<void> setTheme(AppThemeKeys key) async {
//     if (key != _themeKey) {
//       _themeKey = key;

//       final prefs = await SharedPreferences.getInstance();
//       prefs.setString("themeKey", themeKeyToString(key));

//       notifyListeners();
//     }
//   }
// }

// AppThemeKeys themeKeyFromString(String key) {
//   return AppThemeKeys.values.firstWhere(
//     (e) => e.toString().split('.').last == key,
//     orElse: () => AppThemeKeys.coolGrey,
//   );
// }