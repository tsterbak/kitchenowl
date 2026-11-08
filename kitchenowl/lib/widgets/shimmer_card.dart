import 'package:material_ui/material_ui.dart';
import 'package:kitchenowl/styles/themes.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  final Widget? trailing;
  final EdgeInsetsGeometry? margin;
  const ShimmerCard({super.key, this.trailing, this.margin});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06),
        highlightColor:
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.14),
        child: ListTile(
          trailing: trailing,
          title: const Row(
            children: [
              ShimmerText(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class ShimmerText extends StatelessWidget {
  final double maxWidth;

  const ShimmerText({super.key, this.maxWidth = 200});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: Theme.of(context).textTheme.bodyLarge!.fontSize!,
        maxWidth: maxWidth,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06),
      ),
    );
  }
}
