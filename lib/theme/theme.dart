
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PawfectCareTheme {
  static const Color primaryBlue = Color(0xFF5FA8D3);
  static const Color darkBlue = Color(0xFF4A90B8);
  static const Color lightBlue = Color(0xFF7BB8D9);
  static const Color accentBlue = Color(0xFF87CEEB);

  static const Color backgroundWhite = Color(0xFFFAFAFA);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color dividerGray = Color(0xFFE5E5E5);

  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textMuted = Color(0xFF9CA3AF);

  static const Color successGreen = Color(0xFF22C55E);
  static const Color warningYellow = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);

  static const Color chipBackground = Color(0xFFE0F2FE);
  static const Color chipBorder = Color(0xFFBAE6FD);

  static const Color statusCompleted = Color(0xFF10B981);
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusCancelled = Color(0xFFEF4444);
  static const Color statusUpcoming = Color(0xFF6366F1);

  static TextStyle get headingLarge => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle get headingMedium => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.25,
  );

  static TextStyle get headingSmall => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.4,
  );

  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: textMuted,
    height: 1.4,
  );

  static TextStyle get buttonText => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get linkText => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: primaryBlue,
    decoration: TextDecoration.underline,
  );

  static TextStyle get priceText => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: primaryBlue,
  );

  static final BoxDecoration cardDecoration = BoxDecoration(
    color: cardWhite,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static final BoxDecoration chipDecoration = BoxDecoration(
    color: chipBackground,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: chipBorder, width: 1),
  );

  static final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF7F8FA),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryBlue, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: errorRed, width: 1),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    hintStyle: const TextStyle(color: textMuted),
  );

  static final ElevatedButtonThemeData elevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 48),
          textStyle: buttonText,
        ),
      );

  static final OutlinedButtonThemeData outlinedButtonTheme =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: dividerGray, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 48),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
        ),
      );

  static final TextButtonThemeData textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryBlue,
      textStyle: linkText,
    ),
  );

  static const AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: backgroundWhite,
    elevation: 1,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    iconTheme: IconThemeData(color: textPrimary, size: 24),
  );

  static const BottomNavigationBarThemeData
  bottomNavigationBarTheme = BottomNavigationBarThemeData(
    backgroundColor: cardWhite,
    selectedItemColor: primaryBlue,
    unselectedItemColor: textMuted,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
  );

  static final ChipThemeData chipTheme = ChipThemeData(
    backgroundColor: chipBackground,
    selectedColor: primaryBlue,
    secondarySelectedColor: primaryBlue.withOpacity(0.1),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    labelStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: primaryBlue,
    ),
    secondaryLabelStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: chipBorder, width: 1),
    ),
  );

  static const DividerThemeData dividerTheme = DividerThemeData(
    color: dividerGray,
    thickness: 1,
    space: 1,
  );

  static const CardThemeData cardTheme = CardThemeData(
    color: cardWhite,
    elevation: 2,
    shadowColor: Colors.black12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      side: BorderSide(color: dividerGray, width: 1)
    ),
    
    margin: EdgeInsets.all(8),
  );

  static BoxDecoration getStatusBadgeDecoration(String status) {
    Color backgroundColor;
    switch (status.toLowerCase()) {
      case 'completed':
        backgroundColor = statusCompleted;
        break;
      case 'pending':
        backgroundColor = statusPending;
        break;
      case 'cancelled':
        backgroundColor = statusCancelled;
        break;
      case 'upcoming':
        backgroundColor = statusUpcoming;
        break;
      case 'excellent':
        backgroundColor = statusCompleted;
        break;
      case 'approved':
        backgroundColor = statusCompleted;
        break;
      case 'rejected':
        backgroundColor = statusCancelled;
        break;
      default:
        backgroundColor = textMuted;
    }

    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
    );
  }

  static TextStyle getStatusTextStyle() {
    return const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
        primary: primaryBlue,
        secondary: accentBlue,
        surface: backgroundWhite,
        background: backgroundWhite,
        error: errorRed,
      ),
      scaffoldBackgroundColor: backgroundWhite,
      appBarTheme: appBarTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      textButtonTheme: textButtonTheme,
      inputDecorationTheme: inputDecorationTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme,
      chipTheme: chipTheme,
      dividerTheme: dividerTheme,
      cardTheme: cardTheme,
      textTheme: GoogleFonts.interTextTheme(),
    );
  }
}
