import 'package:material_ui/material_ui.dart';
import 'package:kitchenowl/styles/themes.dart';

class SelectableButtonCard extends StatefulWidget {
  final String title;
  final IconData? icon;
  final String? description;
  final bool selected;
  final void Function()? onPressed;
  final void Function()? onLongPressed;
  final Widget? extraOption;
  final Widget? badge;

  const SelectableButtonCard({
    super.key,
    this.icon,
    required this.title,
    this.description,
    this.onPressed,
    this.onLongPressed,
    this.selected = false,
    this.extraOption,
    this.badge,
  });

  @override
  State<SelectableButtonCard> createState() => _SelectableButtonCardState();
}

class _SelectableButtonCardState extends State<SelectableButtonCard> {
  bool mouseHover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: widget.selected
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.alphaBlend(
                      scheme.onPrimary.withAlpha(26), scheme.primary),
                  scheme.primary,
                  Color.alphaBlend(
                      scheme.tertiary.withAlpha(64), scheme.primary),
                ],
              )
            : null,
        color: widget.selected
            ? null
            : ElevationOverlay.applySurfaceTint(
                Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
                Theme.of(context).cardTheme.surfaceTintColor ??
                    scheme.surfaceTint,
                1,
              ),
        border: widget.selected
            ? null
            : Border.all(
                color: mouseHover
                    ? scheme.primary.withAlpha(120)
                    : scheme.outlineVariant.withAlpha(90),
                width: 1,
              ),
        boxShadow: widget.selected
            ? [
                BoxShadow(
                  color: scheme.primary.withAlpha(70),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ]
            : const [],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        type: MaterialType.transparency,
        child: MouseRegion(
          onEnter: (event) {
            setState(() {
              mouseHover = true;
            });
          },
          onExit: (event) {
            setState(() {
              mouseHover = false;
            });
          },
          child: InkWell(
            onTap: widget.onPressed,
            onSecondaryTap: widget.onLongPressed,
            onLongPress: widget.onLongPressed,
            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                if (widget.extraOption != null && mouseHover)
                  widget.extraOption!,
                if (widget.extraOption == null &&
                    widget.onLongPressed != null &&
                    mouseHover)
                  IconButton(
                    onPressed: widget.onLongPressed,
                    color: widget.selected
                        ? scheme.onPrimary
                        : scheme.onSurfaceVariant,
                    icon: const Icon(Icons.more_horiz_rounded),
                  ),
                if (widget.badge != null)
                  Positioned(
                    left: 4,
                    top: 4,
                    child: widget.badge!,
                  ),
                AnimatedScale(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  scale: mouseHover ? 1.02 : 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
                          child: LayoutBuilder(
                            builder: (context, constraint) {
                              final iconSize =
                                  (constraint.maxWidth / 2.4).clamp(28.0, 44.0);
                              return Center(
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 200),
                                  width: iconSize * 1.55,
                                  height: iconSize * 1.55,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: widget.selected
                                        ? scheme.onPrimary.withAlpha(40)
                                        : scheme.primaryContainer
                                            .withAlpha(140),
                                  ),
                                  child: Icon(
                                    widget.icon,
                                    size: iconSize,
                                    color: widget.selected
                                        ? scheme.onPrimary
                                        : scheme.primary,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      Tooltip(
                        message: widget.title,
                        waitDuration: const Duration(milliseconds: 500),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              color: widget.selected
                                  ? scheme.onPrimary
                                  : null,
                              fontWeight: widget.selected
                                  ? FontWeight.w600
                                  : null,
                            ),
                            maxLines: widget.icon != null ? 2 : 3,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      if (widget.description?.isNotEmpty ?? false)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            widget.description!,
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: widget.selected
                                          ? scheme.onPrimary.withAlpha(200)
                                          : scheme.onSurfaceVariant,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
