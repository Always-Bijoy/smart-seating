import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Exact color pattern from Smart Seating design.
class AppColors {
  // Primary / Accent (yellow-orange)
  static const Color primary = Color(0xFFF4C025); // Design golden yellow
  static const Color primaryDark = Color(0xFFD4A010);
  static const Color accentOrange = Color(0xFFF4A000); // Arrow, highlights
  static const Color accent = Color(0xFF2B5CE6); // Blue (other screens)

  // Background — top (cream/beige), bottom (pale blue)
  static const Color backgroundTop = Color(0xFFFDF9EC); // Light off-white/beige, ~70% of screen
  static const Color backgroundBottom = Color(0xFFE5F3F8); // Pale blue/teal, ~30% of screen
  static const Color background = Color(0xFFFDF9EC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color pillBackground = Color(0xFFF8F8F8); // Route/weather/sunlight pills

  // Text
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF616161); // Descriptive text
  static const Color textMuted = Color(0xFF9E9E9E); // Icons, inactive nav

  // Status
  static const Color sunYellow = Color(0xFFF4C025);
  static const Color sunlightLines = Color(0xFFF4C025);
  static const Color snowflakeBlue = Color(0xFFADD8E6); // Light blue cooling
  static const Color greenCheck = Color(0xFF4CAF50);

  // Bus
  static const Color busBody = Color(0xFF2A2A2A); // Very dark bus exterior
  static const Color busBorder = Color(0xFF333333);
  static const Color busWarmWindow = Color(0xFF7A6522); // Amber — sun-side windows
  static const Color busCoolWindow = Color(0xFF4B5E6B); // Blue-gray — shade-side window

  // Footer (same as bottom background)
  static const Color footerBackground = Color(0xFFE5F3F8);

  // Button
  static const Color primaryButtonBg = Color(0xFFF4C025);

  // Background gradient: smooth blend from cream/beige to pale blue (Home screen)
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFDF9EC), // Light beige at top
      Color(0xFFFDF9EC), // Keep beige for ~70% of screen
      Color(0xFFF0F4F6), // Mid transition
      Color(0xFFE5F3F8), // Pale blue at bottom
    ],
    stops: [0.0, 0.65, 0.75, 1.0], // Transition starts around 65%, completes by 75%
  );

  // Plan screen gradient: #fffcf0 → #f8f8f5 (40%) → #e0f2fe (100%)
  static const LinearGradient planScreenGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFCF0), // Very light yellow/cream
      Color(0xFFF8F8F5), // Light beige at 40%
      Color(0xFFE0F2FE), // Sky blue at bottom
    ],
    stops: [0.0, 0.4, 1.0],
  );

  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD340), Color(0xFFF4C025)],
  );
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        surface: AppColors.cardBackground,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
    );
  }
}
