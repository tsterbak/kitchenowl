import 'package:material_ui/material_ui.dart';
import 'package:kitchenowl/kitchenowl.dart';

Future<bool> askForConfirmation({
  required BuildContext context,
  Widget? content,
  Widget? title,
  String? confirmText,
  String? cancelText,
  bool showCancel = true,
  Color? confirmBackgroundColor,
  Color? confirmForegroundColor,
  Color? cancelColor,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          content: content,
          actions: <Widget>[
            if (showCancel)
              TextButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all<Color>(
                    cancelColor ?? Theme.of(context).disabledColor,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  cancelText ?? AppLocalizations.of(context)!.cancel,
                ),
              ),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  confirmBackgroundColor ??
                      Theme.of(context).colorScheme.error,
                ),
                foregroundColor: WidgetStateProperty.all<Color>(
                  confirmForegroundColor ??
                      Theme.of(context).colorScheme.onError,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmText ?? AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
    ) ??
    false;
