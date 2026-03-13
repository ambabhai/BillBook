import 'package:flutter/material.dart';

class AppTheme {

  /// Brand color
  static const Color primary = Color(0xFF3A4F7A);

  /// Background (slightly warmer)
  static const Color background = Color(0xFFE9E6E1);

  /// Card color (clear separation)
  static const Color card = Color(0xFFF5F4F1);

  /// Accent
  static const Color accent = Color(0xFFD9A441);

  /// Navbar
  static const Color navBar = Color(0xFF2F3E5C);

  /// Text
  static const Color textDark = Color(0xFF1F2937);

  static const Color textLight = Color(0xFF6B7280);

  /// Status
  static const Color success = Color(0xFF22C55E);

  static const Color danger = Color(0xFFEF4444);

  static List<BoxShadow> cardShadow = [

    BoxShadow(
      color: Colors.black.withOpacity(.05),
      blurRadius: 18,
      offset: const Offset(0,8),
    )

  ];
}