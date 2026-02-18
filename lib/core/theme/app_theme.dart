
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color backgroundBlack = Color(0xFF050505);
  static const Color backgroundGradientStart = Color(0xFF1A1A1A);
  
  static const Color neonCyan = Color(0xFF00F3FF);
  static const Color electricPurple = Color(0xFFBC13FE);
  static const Color holographicRed = Color(0xFFFF003C);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [neonCyan, electricPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundBlack,
    primaryColor: neonCyan,
    colorScheme: const ColorScheme.dark(
      primary: neonCyan,
      secondary: electricPurple,
      error: holographicRed,
      surface: Color(0xFF121212),
      background: backgroundBlack,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.orbitron(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: GoogleFonts.orbitron(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        color: Colors.white70,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        color: Colors.white60,
      ),
    ),
    useMaterial3: true,
  );
}
