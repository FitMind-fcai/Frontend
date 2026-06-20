import 'package:fitmind/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // TODO: replace with your exact AppConstants.primaryColor hex value.
  // Used as the seed so every generated tone (containers, accents, etc.)
  // derives from your actual brand orange instead of Material's default blue.
  static const Color _seedColor = AppConstants.primaryColor;

  // TODO: confirm against your Figma file — eyeballed from the screenshot.
  // This is the near-black, slightly cool-toned background from your
  // reference design, NOT Flutter's default dark gray (#121212).
  static const Color _darkSurface = Color(0xFF14141A);
  static const Color _darkSurfaceElevated = Color(0xFF1E1E26);

  // CHANGED: ColorScheme.fromSeed() derives "neutral" surfaces from the
  // seed hue at low chroma — with an orange seed, that means surface and
  // surfaceContainerHighest both come out with a faint peach tint instead
  // of true neutral white/gray. Overriding them explicitly here mirrors
  // what the dark theme already does below.
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightSurfaceElevated = Color(0xFFF5F1ED);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ).copyWith(
      surface: _lightSurface,
      surfaceContainerHighest: _lightSurfaceElevated,
      surfaceContainer: _lightSurfaceElevated,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      cardColor: colorScheme.surface,
      dividerColor: colorScheme.outlineVariant,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ).copyWith(
      surface: _darkSurface,
      surfaceContainerHighest: _darkSurfaceElevated,
      surfaceContainer: _darkSurfaceElevated,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _darkSurface,
      cardColor: _darkSurfaceElevated,
      dividerColor: colorScheme.outlineVariant,
      appBarTheme: AppBarTheme(
        backgroundColor: _darkSurface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
    );
  }
}