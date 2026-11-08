import 'package:material_ui/material_ui.dart';

import 'colors.dart';

/// The shape language of the app.
///
/// One consistent radius scale instead of ad-hoc values scattered across the
/// widgets: quiet, rounded, but not bubbly. Components should reference these
/// tokens instead of hard-coding [BorderRadius] literals.
abstract class AppRadius {
  AppRadius._();

  /// Small controls: text fields, inner boxes, list tiles.
  static const double sm = 14;

  /// Buttons and snack bars.
  static const double md = 16;

  /// Cards and other primary content containers.
  static const double lg = 20;

  /// Dialogs and panels.
  static const double xl = 24;

  /// Bottom sheets.
  static const double sheet = 28;

  static RoundedRectangleBorder rounded([double radius = lg]) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));

  static RoundedRectangleBorder roundedTop([double radius = sheet]) =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
      );
}

abstract class AppThemes {
  /// Light and dark schemes derived from the brand green through the Material
  /// tonal system. All roles (secondary, tertiary, containers, surfaces) are
  /// generated harmoniously from the seed instead of being flattened onto the
  /// primary color, which gives the app depth and a quieter, more refined look.
  static ColorScheme lightScheme = ColorScheme.fromSeed(
    seedColor: AppColors.green,
    brightness: Brightness.light,
  );

  static ColorScheme darkScheme = ColorScheme.fromSeed(
    seedColor: AppColors.green,
    brightness: Brightness.dark,
  );

  static ThemeData light([ColorScheme? colorScheme]) {
    colorScheme ??= lightScheme;
    return _theme(colorScheme);
  }

  static ThemeData dark([ColorScheme? colorScheme]) {
    colorScheme ??= darkScheme;
    return _theme(colorScheme);
  }

  /// Single shared theme definition for both brightnesses. Colors come from
  /// the color scheme so light, dark, dynamic and user-accent themes all stay
  /// consistent automatically.
  static ThemeData _theme(ColorScheme colorScheme) {
    final ThemeData base = ThemeData.from(
      colorScheme: colorScheme,
      useMaterial3: true,
    );
    final TextTheme textTheme = _textTheme(base.textTheme);

    final cardColor = colorScheme.brightness == Brightness.dark
        ? colorScheme.surfaceContainerHigh
        : colorScheme.surfaceContainerLowest;

    final buttonStyle = ButtonStyle(
      elevation: WidgetStatePropertyAll(0.0),
      minimumSize: WidgetStatePropertyAll(Size(64, 48)),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
      shape: WidgetStatePropertyAll(AppRadius.rounded(AppRadius.md)),
      textStyle: WidgetStatePropertyAll(
        TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          fontSize: 0.95,
        ),
      ),
    );

    OutlineInputBorder fieldBorder({BorderSide side = BorderSide.none}) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: side,
        );

    return base.copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      textTheme: textTheme,
      // Warm, tonal canvas: content surfaces sit visibly on the background.
      scaffoldBackgroundColor: colorScheme.surfaceContainerLow,
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        space: 1,
        thickness: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surfaceContainerLow,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
        actionsIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
      ),
      tabBarTheme: TabBarThemeData(
        dividerColor: Colors.transparent,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: textTheme.titleSmall,
        unselectedLabelStyle: textTheme.titleSmall,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        indicatorColor: colorScheme.secondaryContainer,
        selectedLabelTextStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        unselectedLabelTextStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
        selectedIconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 70,
        indicatorColor: colorScheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelMedium?.copyWith(
            color: states.contains(WidgetState.selected)
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? colorScheme.onSecondaryContainer
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        color: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: AppRadius.rounded(),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: AppRadius.rounded(AppRadius.xl),
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        modalBackgroundColor: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        showDragHandle: true,
        dragHandleColor: colorScheme.outlineVariant,
        shape: AppRadius.roundedTop(),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: AppRadius.rounded(AppRadius.md),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        highlightElevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(style: buttonStyle),
      elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: buttonStyle.copyWith(
          side: WidgetStateProperty.resolveWith(
            (states) => BorderSide(color: colorScheme.outlineVariant),
          ),
          foregroundColor: WidgetStatePropertyAll(colorScheme.onSurface),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: AppRadius.rounded(AppRadius.md),
          minimumSize: Size(48, 44),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            fontSize: 0.95,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.onSurface.withValues(alpha: 0.045),
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
        ),
        helperStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        counterStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        labelStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        floatingLabelStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: fieldBorder(),
        enabledBorder: fieldBorder(),
        focusedBorder: fieldBorder(
          side: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: fieldBorder(
          side: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: fieldBorder(
          side: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        disabledBorder: fieldBorder(),
      ),
      chipTheme: ChipThemeData.fromDefaults(
        primaryColor: colorScheme.primary,
        secondaryColor: colorScheme.surfaceContainerHighest,
        labelStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w500,
        ),
      ).copyWith(
        checkmarkColor: colorScheme.onPrimary,
        side: BorderSide.none,
        shape: StadiumBorder(),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurfaceVariant,
        shape: AppRadius.rounded(AppRadius.sm),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        titleTextStyle: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        year2023: false,
        color: colorScheme.primary,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          // Use PredictiveBackPageTransitionsBuilder to get the predictive back route transition!
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.fuchsia: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeForwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  /// Tighter, more confident type scale on top of the platform default:
  /// negative optical tracking on display and headline sizes, semibold
  /// headings, and more generous body leading for comfortable reading.
  static TextTheme _textTheme(TextTheme base) => base.copyWith(
    displayLarge: base.displayLarge?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -1.0,
      height: 1.05,
    ),
    displayMedium: base.displayMedium?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.75,
      height: 1.07,
    ),
    displaySmall: base.displaySmall?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      height: 1.1,
    ),
    headlineLarge: base.headlineLarge?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: -0.6,
      height: 1.1,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
      height: 1.15,
    ),
    headlineSmall: base.headlineSmall?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      height: 1.2,
    ),
    titleLarge: base.titleLarge?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    titleSmall: base.titleSmall?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
    bodyLarge: base.bodyLarge?.copyWith(height: 1.5, letterSpacing: 0.1),
    bodyMedium: base.bodyMedium?.copyWith(height: 1.5, letterSpacing: 0.15),
    bodySmall: base.bodySmall?.copyWith(height: 1.45, letterSpacing: 0.2),
    labelLarge: base.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
    labelMedium: base.labelMedium?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    ),
    labelSmall: base.labelSmall?.copyWith(letterSpacing: 0.4),
  );
}
