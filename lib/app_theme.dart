import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  CELESTIAL CALM — Design System
// ═══════════════════════════════════════════════════════════════════

// ── Core Palette ──────────────────────────────────────────────────
class AppColors {
  // Backgrounds
  static const deepNavy = Color(0xFF0A0E21);
  static const midnightBlue = Color(0xFF111638);
  static const cosmicIndigo = Color(0xFF1B1F4B);

  // Accents
  static const auroraLavender = Color(0xFF7B6CF6);
  static const auroraRose = Color(0xFFE8618C);
  static const auroraTeal = Color(0xFF4ECDC4);
  static const auroraGold = Color(0xFFD4A84B);

  // Text
  static const starWhite = Color(0xFFF0F0FA);
  static const moonGray = Color(0xFF8E8EA0);
  static const dimGray = Color(0xFF5A5A6E);

  // Glass
  static const glassWhite = Color(0x14FFFFFF); // 8%
  static const glassBorder = Color(0x1FFFFFFF); // 12%
  static const glassHighlight = Color(0x33FFFFFF); // 20%

  // Glow
  static const glowPurple = Color(0x337B6CF6); // 20%
  static const glowRose = Color(0x33E8618C);
  static const glowTeal = Color(0x334ECDC4);

  // Status
  static const successGreen = Color(0xFF2ECC71);
  static const errorRed = Color(0xFFE74C5F);
  static const warningAmber = Color(0xFFFFB347);
}

// ── Gradients ─────────────────────────────────────────────────────
class AppGradients {
  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.deepNavy,
      Color(0xFF0D1130),
      AppColors.midnightBlue,
    ],
  );

  static const cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x14FFFFFF),
      Color(0x0AFFFFFF),
    ],
  );

  static const primaryButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.auroraLavender,
      Color(0xFF6A5AE0),
    ],
  );

  static const roseButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.auroraRose,
      Color(0xFFD44E78),
    ],
  );

  static const tealButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.auroraTeal,
      Color(0xFF38B2AC),
    ],
  );

  static const purpleDeepGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF611D8A),
      Color(0xFF4A1570),
    ],
  );

  static const shimmerGradient = LinearGradient(
    colors: [
      Color(0x00FFFFFF),
      Color(0x33FFFFFF),
      Color(0x00FFFFFF),
    ],
    stops: [0.0, 0.5, 1.0],
  );
}

// ── Glass Morphism Helpers ────────────────────────────────────────
class GlassDecoration {
  /// Standard glass card
  static BoxDecoration card({
    double borderRadius = 20,
    Color? borderColor,
    double borderWidth = 1,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      gradient: AppGradients.cardGradient,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? AppColors.glassBorder,
        width: borderWidth,
      ),
      boxShadow: boxShadow ??
          [
            BoxShadow(
              color: AppColors.glowPurple,
              blurRadius: 20,
              spreadRadius: -5,
            ),
          ],
    );
  }

  /// Glass card with specific accent glow
  static BoxDecoration accentCard({
    required Color glowColor,
    double borderRadius = 20,
  }) {
    return BoxDecoration(
      gradient: AppGradients.cardGradient,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: glowColor.withOpacity(0.2),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: glowColor.withOpacity(0.15),
          blurRadius: 24,
          spreadRadius: -4,
        ),
      ],
    );
  }

  /// Input field decoration
  static BoxDecoration inputField({double borderRadius = 16}) {
    return BoxDecoration(
      color: AppColors.glassWhite,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: AppColors.glassBorder,
        width: 1,
      ),
    );
  }

  /// Elevated surface
  static BoxDecoration surface({double borderRadius = 16}) {
    return BoxDecoration(
      color: AppColors.cosmicIndigo.withOpacity(0.5),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: AppColors.glassBorder,
        width: 0.5,
      ),
    );
  }
}

// ── Typography ────────────────────────────────────────────────────
class AppTypography {
  // Display — Outfit
  static TextStyle displayLarge = GoogleFonts.outfit(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    color: AppColors.starWhite,
    letterSpacing: -0.5,
  );

  static TextStyle displayMedium = GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.starWhite,
    letterSpacing: -0.3,
  );

  static TextStyle displaySmall = GoogleFonts.outfit(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.starWhite,
  );

  // Headings — Outfit
  static TextStyle headlineLarge = GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.starWhite,
  );

  static TextStyle headlineMedium = GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.starWhite,
  );

  // Body — Inter
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.starWhite,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.moonGray,
    height: 1.4,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.moonGray,
  );

  // Labels — Inter
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.starWhite,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.starWhite,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.moonGray,
  );

  // Button text
  static TextStyle button = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );
}

// ── Theme Data ────────────────────────────────────────────────────
ThemeData celestialTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.deepNavy,
    canvasColor: Colors.transparent,
    fontFamily: GoogleFonts.inter().fontFamily,
    useMaterial3: true,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.auroraLavender,
      secondary: AppColors.auroraRose,
      tertiary: AppColors.auroraTeal,
      surface: AppColors.midnightBlue,
      error: AppColors.errorRed,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.starWhite,
      onError: Colors.white,
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTypography.headlineLarge,
      iconTheme: const IconThemeData(color: AppColors.starWhite),
    ),

    // Slider
    sliderTheme: SliderThemeData(
      trackHeight: 6,
      activeTrackColor: AppColors.auroraLavender,
      inactiveTrackColor: AppColors.auroraLavender.withOpacity(0.2),
      thumbColor: AppColors.starWhite,
      overlayColor: AppColors.auroraLavender.withOpacity(0.15),
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      trackShape: const RoundedRectSliderTrackShape(),
      valueIndicatorColor: AppColors.auroraLavender,
      valueIndicatorTextStyle: AppTypography.labelSmall.copyWith(
        color: Colors.white,
      ),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.glassWhite,
      disabledColor: AppColors.dimGray,
      selectedColor: AppColors.auroraLavender,
      secondarySelectedColor: AppColors.auroraLavender,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      side: BorderSide(color: AppColors.glassBorder, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      labelStyle: AppTypography.labelMedium,
      secondaryLabelStyle: AppTypography.labelMedium.copyWith(
        color: Colors.white,
      ),
      brightness: Brightness.dark,
      surfaceTintColor: Colors.transparent,
    ),

    // Text
    textTheme: TextTheme(
      displayLarge: AppTypography.displayLarge,
      displayMedium: AppTypography.displayMedium,
      displaySmall: AppTypography.displaySmall,
      headlineLarge: AppTypography.headlineLarge,
      headlineMedium: AppTypography.headlineMedium,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.bodyMedium,
      bodySmall: AppTypography.bodySmall,
      labelLarge: AppTypography.labelLarge,
      labelMedium: AppTypography.labelMedium,
      labelSmall: AppTypography.labelSmall,
    ),

    // Input
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.glassWhite,
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.moonGray.withOpacity(0.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.glassBorder, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.glassBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
            color: AppColors.auroraLavender, width: 1.5),
      ),
      prefixIconColor: AppColors.auroraLavender,
    ),

    // Divider
    dividerTheme: DividerThemeData(
      color: AppColors.glassBorder,
      thickness: 0.5,
    ),

    // Snackbar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.cosmicIndigo,
      contentTextStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.starWhite,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.midnightBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: AppTypography.headlineLarge,
      contentTextStyle: AppTypography.bodyLarge,
    ),

    // Bottom Sheet
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.midnightBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.auroraLavender,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: AppTypography.button,
        elevation: 0,
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.auroraLavender,
        textStyle: AppTypography.labelMedium,
      ),
    ),

    // Card
    cardTheme: CardThemeData(
      color: AppColors.midnightBlue,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.glassBorder, width: 0.5),
      ),
    ),

    // ListTile
    listTileTheme: ListTileThemeData(
      textColor: AppColors.starWhite,
      iconColor: AppColors.auroraLavender,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
  );
}
