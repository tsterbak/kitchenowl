import 'package:animations/animations.dart';
import 'package:material_ui/material_ui.dart';

class KitchenOwlFab extends StatelessWidget {
  final Widget Function(BuildContext, void Function({Object? returnValue}))
      openBuilder;
  final Function(Object?)? onClosed;
  final IconData? icon;
  final String? tooltip;

  const KitchenOwlFab({
    super.key,
    required this.openBuilder,
    this.onClosed,
    this.icon = Icons.add,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      useRootNavigator: true,
      transitionType: ContainerTransitionType.fade,
      openBuilder: openBuilder,
      openColor: Theme.of(context).scaffoldBackgroundColor,
      onClosed: onClosed,
      tappable: false,
      clipBehavior: Clip.none,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
      ),
      closedColor:
          Theme.of(context).floatingActionButtonTheme.backgroundColor ??
              Theme.of(context).colorScheme.secondary,
      closedBuilder: (
        BuildContext context,
        VoidCallback openContainer,
      ) {
        final scheme = Theme.of(context).colorScheme;
        return Tooltip(
          message: tooltip ?? '',
          child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withAlpha(90),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: openContainer,
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.alphaBlend(
                          scheme.onPrimary.withAlpha(26), scheme.primary),
                      scheme.primary,
                      Color.alphaBlend(
                          scheme.tertiary.withAlpha(80), scheme.primary),
                    ],
                  ),
                ),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(
                    icon,
                    color: scheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
        );
      },
    );
  }
}
