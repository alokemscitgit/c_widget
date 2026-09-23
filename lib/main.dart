// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:c_widget/body2.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'const/theme/theme.dart';

void main() {
  runApp(
    // Wrap the app with ChangeNotifierProvider to manage the theme state
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to the ThemeProvider to get the currently selected theme
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      scrollBehavior: kIsWeb? CustomScrollBehavior():null,
      title: 'Dynamic Hospital Theme',
      // Apply the theme data from the provider
           theme: themeProvider.getTheme(context),
      home: const ThemeChangeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ThemeChangeScreen extends StatelessWidget {
  const ThemeChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body2());
  }
}


class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}