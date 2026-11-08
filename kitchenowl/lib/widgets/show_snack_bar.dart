import 'package:material_ui/material_ui.dart';
import 'package:kitchenowl/styles/themes.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar({
  required BuildContext context,
  SnackBarAction? action,
  required Widget content,
  Duration? duration,
  double? width = 180,
}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: action,
        content: DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyLarge!,
          textAlign: action == null ? TextAlign.center : null,
          child: content,
        ),
        duration: duration ?? const Duration(milliseconds: 1500),
        width: width,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        clipBehavior: Clip.none,
        backgroundColor: Theme.of(context).cardColor,
      ),
    );
