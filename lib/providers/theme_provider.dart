// theme_provider.dart
import 'package:flutter/material.dart';
import 'package:pawfect_care/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';


enum ThemeMode { light, dark, system }

enum UserType { petOwner, veterinarian, shelterAdmin }

class ThemeProvider extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';
  static const String _userTypeKey = 'user_type';
  static const String _accentColorKey = 'accent_color';

  ThemeMode _themeMode = ThemeMode.light;
  UserType _userType = UserType.petOwner;
  Color _customAccentColor = PawfectCareTheme.primaryBlue;
  bool _isInitialized = false;

 
  ThemeMode get themeMode => _themeMode;
  UserType get userType => _userType;
  Color get customAccentColor => _customAccentColor;
  bool get isInitialized => _isInitialized;

  ThemeData getThemeData(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDark =
        _themeMode == ThemeMode.dark ||
        (_themeMode == ThemeMode.system && brightness == Brightness.dark);

    return isDark ? _getDarkTheme() : _getLightTheme();
  }

  ThemeData _getLightTheme() {
    var theme = PawfectCareTheme.lightTheme;

    
    switch (_userType) {
      case UserType.veterinarian:
        theme = theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            primary: const Color(0xFF2563EB),
            secondary: const Color(0xFF7C3AED), 
          ),
        );
        break;
      case UserType.shelterAdmin:
        theme = theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            primary: const Color(0xFF059669), // Green for shelter/rescue
            secondary: const Color(0xFFF59E0B), // Orange accent
          ),
        );
        break;
      case UserType.petOwner:
      default:
        if (_customAccentColor != PawfectCareTheme.primaryBlue) {
          theme = theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: _customAccentColor,
            ),
          );
        }
        break;
    }

    return theme;
  }

  ThemeData _getDarkTheme() {
    const darkBackground = Color(0xFF0F172A);
    const darkSurface = Color(0xFF1E293B);
    const darkCardColor = Color(0xFF334155);
    const darkTextPrimary = Color(0xFFF8FAFC);
    const darkTextSecondary = Color(0xFFCBD5E1);

    var baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: ColorScheme.dark(
        primary: _getThemeColor(),
        secondary: _getSecondaryColor(),
        surface: darkSurface,
        background: darkBackground,
        onBackground: darkTextPrimary,
        onSurface: darkTextPrimary,
        error: const Color(0xFFEF4444),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        iconTheme: IconThemeData(color: darkTextPrimary, size: 24),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _getThemeColor(),
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
      cardTheme: const CardThemeData(
        color: darkCardColor,
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCardColor,
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
          borderSide: BorderSide(color: _getThemeColor(), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: const TextStyle(color: darkTextSecondary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: _getThemeColor(),
        unselectedItemColor: darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      fontFamily: 'SF Pro Display',
    );

    return baseTheme;
  }

  // Get theme color based on user type
  Color _getThemeColor() {
    switch (_userType) {
      case UserType.veterinarian:
        return const Color(0xFF2563EB);
      case UserType.shelterAdmin:
        return const Color(0xFF059669);
      case UserType.petOwner:
      default:
        return _customAccentColor;
    }
  }

  // Get secondary color based on user type
  Color _getSecondaryColor() {
    switch (_userType) {
      case UserType.veterinarian:
        return const Color(0xFF7C3AED);
      case UserType.shelterAdmin:
        return const Color(0xFFF59E0B);
      case UserType.petOwner:
      default:
        return PawfectCareTheme.accentBlue;
    }
  }

  // Initialize theme from storage
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load theme mode
      final themeModeIndex = prefs.getInt(_themeModeKey) ?? 0;
      _themeMode = ThemeMode.values[themeModeIndex];

      // Load user type
      final userTypeIndex = prefs.getInt(_userTypeKey) ?? 0;
      _userType = UserType.values[userTypeIndex];

      // Load custom accent color
      final colorValue = prefs.getInt(_accentColorKey);
      if (colorValue != null) {
        _customAccentColor = Color(colorValue);
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing theme: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, mode.index);
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }


  Future<void> setUserType(UserType type) async {
    if (_userType == type) return;

    _userType = type;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_userTypeKey, type.index);
    } catch (e) {
      debugPrint('Error saving user type: $e');
    }
  }

  // Set custom accent color (for pet owners)
  Future<void> setCustomAccentColor(Color color) async {
    if (_customAccentColor == color) return;

    _customAccentColor = color;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_accentColorKey, color.value);
    } catch (e) {
      debugPrint('Error saving accent color: $e');
    }
  }

  // Toggle between light and dark mode
  void toggleTheme() {
    final newMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    setThemeMode(newMode);
  }

  // Reset to defaults
  Future<void> resetToDefaults() async {
    _themeMode = ThemeMode.system;
    _userType = UserType.petOwner;
    _customAccentColor = PawfectCareTheme.primaryBlue;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_themeModeKey);
      await prefs.remove(_userTypeKey);
      await prefs.remove(_accentColorKey);
    } catch (e) {
      debugPrint('Error resetting theme: $e');
    }
  }

  // Get status color helper
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'excellent':
      case 'approved':
        return PawfectCareTheme.statusCompleted;
      case 'pending':
        return PawfectCareTheme.statusPending;
      case 'cancelled':
      case 'rejected':
        return PawfectCareTheme.statusCancelled;
      case 'upcoming':
        return PawfectCareTheme.statusUpcoming;
      default:
        return PawfectCareTheme.textMuted;
    }
  }

  // Get user type display name
  String getUserTypeDisplayName() {
    switch (_userType) {
      case UserType.petOwner:
        return 'Pet Owner';
      case UserType.veterinarian:
        return 'Veterinarian';
      case UserType.shelterAdmin:
        return 'Shelter Admin';
    }
  }

  // Get theme mode display name
  String getThemeModeDisplayName() {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}

// Extension for easy context access
extension ThemeProviderExtension on BuildContext {
  ThemeProvider get themeProvider =>
      Provider.of<ThemeProvider>(this, listen: false);

  ThemeProvider get watchThemeProvider => Provider.of<ThemeProvider>(this);
}
