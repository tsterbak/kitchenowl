import 'package:material_ui/material_ui.dart';

abstract class AppColors {
  static const MaterialColor green = MaterialColor(0xFF20AC64, {
    50: Color(0xFF53DF97),
    100: Color(0xFF41DC8C),
    200: Color(0xFF30D982),
    300: Color(0xFF26CF78),
    400: Color(0xFF23BE6E),
    500: Color(0xFF20AC64), // Primary
    600: Color(0xFF1C9B5A),
    700: Color(0xFF198A50),
    800: Color(0xFF167946),
    900: Color(0xFF13673C),
  });

  /// Calm, considered accent choices used across the app (seed colors for the
  /// Material color system). Replaces the washed-out `*Accent` variants so
  /// every generated palette stays rich and consistent in light and dark.
  static const List<Color> accentColorOptions = [
    Color(0xFFE5484D), // red
    Color(0xFFE93D82), // pink
    Color(0xFF8E4EC6), // purple
    Color(0xFF6E56CF), // indigo
    Color(0xFF0090FF), // blue
    Color(0xFF00A5BC), // cyan
    Color(0xFF12A594), // teal
    Color(0xFF2FB86F), // green
    Color(0xFFB8A018), // yellow
    Color(0xFFE07B00), // orange
    Color(0xFFE54D2E), // deep orange
  ];
}
