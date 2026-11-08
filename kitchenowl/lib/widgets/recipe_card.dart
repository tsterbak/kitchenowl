import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:go_router/go_router.dart';
import 'package:kitchenowl/cubits/household_cubit.dart';
import 'package:kitchenowl/enums/update_enum.dart';
import 'package:kitchenowl/kitchenowl.dart';
import 'package:kitchenowl/models/household.dart';
import 'package:kitchenowl/models/recipe.dart';
import 'package:kitchenowl/services/storage/storage.dart';
import 'package:kitchenowl/styles/themes.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tuple/tuple.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool showHousehold;
  final void Function()? onUpdated;
  final void Function()? onPressed;
  final Future<void> Function()? onLongPressed;
  final Future<void> Function()? onAddToDate;
  final double? width;
  final int imageFlex;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onUpdated,
    this.onPressed,
    this.onLongPressed,
    this.onAddToDate,
    this.showHousehold = false,
    this.width,
    this.imageFlex = 5,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasImage = recipe.image?.isNotEmpty ?? false;

    // Compact action/tile variant used inside carousels and when the card
    // carries its own action buttons.
    final isActionCard = onLongPressed != null;

    if (!isActionCard) {
      // Editorial hero card: image bleeds to the card edges, name and tags
      // float over a gradient scrim.
      return SizedBox(
        width: width ??
            getValueForScreenType(
              context: context,
              mobile: 250,
              tablet: 275,
              desktop: 275,
            ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed ?? () => _defaultOnTap(context),
            onLongPress: onLongPressed,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (hasImage)
                  FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: recipe.imageHash != null
                        ? BlurHashImage(recipe.imageHash!)
                        : MemoryImage(kTransparentImage) as ImageProvider,
                    image: getImageProvider(
                      context,
                      recipe.image!,
                      maxWidth: 512,
                    ),
                  )
                else
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          scheme.secondaryContainer,
                          Color.alphaBlend(
                              scheme.primary.withAlpha(70),
                              scheme.secondaryContainer),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.fastfood_rounded,
                        size: 56,
                        color: scheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                // Legibility scrim
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withAlpha(10),
                        Colors.transparent,
                        Colors.black.withAlpha(150),
                        Colors.black.withAlpha(215),
                      ],
                      stops: const [0.0, 0.35, 0.75, 1.0],
                    ),
                  ),
                ),
                if (recipe.time > 0)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: _frostedChip(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.timer_rounded,
                                size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              "${recipe.time} min",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (showHousehold && recipe.household != null)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: _frostedChip(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            HouseholdCircleAvatar(
                              household: recipe.household!,
                              radius: 9,
                            ),
                            const SizedBox(width: 6),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 90),
                              child: Text(
                                recipe.household!.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (recipe.household!.verified) ...[
                              const SizedBox(width: 4),
                              Icon(Icons.verified_rounded,
                                  size: 14, color: scheme.primary),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (recipe.tags.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: ShaderMask(
                            shaderCallback: (rect) {
                              return const LinearGradient(
                                begin: Alignment(.7, 0),
                                end: Alignment.centerRight,
                                colors: [Colors.black, Colors.transparent],
                              ).createShader(
                                Rect.fromLTRB(0, 0, rect.width, rect.height),
                              );
                            },
                            blendMode: BlendMode.dstIn,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              child: Row(
                                children: recipe.tags
                                    .map((e) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4),
                                          child: _frostedChip(
                                            child: Text(
                                              e.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      Text(
                        recipe.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: width ??
          getValueForScreenType(
            context: context,
            mobile: 250,
            tablet: 275,
            desktop: 275,
          ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed ?? () => _defaultOnTap(context),
          onLongPress: onLongPressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: imageFlex,
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [
                    if (hasImage)
                      FadeInImage(
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: recipe.imageHash != null
                            ? BlurHashImage(recipe.imageHash!)
                            : MemoryImage(kTransparentImage) as ImageProvider,
                        image: getImageProvider(
                          context,
                          recipe.image!,
                          maxWidth: 512,
                        ),
                      ),
                    if (!hasImage)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              scheme.secondaryContainer,
                              Color.alphaBlend(
                                  scheme.primary.withAlpha(70),
                                  scheme.secondaryContainer),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.fastfood_rounded,
                          size: 48,
                          color: scheme.onSecondaryContainer,
                        ),
                      ),
                    if (recipe.time > 0)
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Chip(
                            avatar: Icon(Icons.timer_rounded),
                            label: Text(
                              "${recipe.time} min",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (recipe.tags.isNotEmpty)
                        ShaderMask(
                          shaderCallback: (rect) {
                            return const LinearGradient(
                              begin: Alignment(.7, 0),
                              end: Alignment.centerRight,
                              colors: [Colors.black, Colors.transparent],
                            ).createShader(
                              Rect.fromLTRB(0, 0, rect.width, rect.height),
                            );
                          },
                          blendMode: BlendMode.dstIn,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            child: Row(
                              children: recipe.tags
                                  .map((e) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4),
                                        child: Chip(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          label: Text(e.name),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      const SizedBox(height: 2),
                      Text(
                        recipe.name,
                        maxLines: getValueForScreenType(
                          context: context,
                          mobile: 2,
                          tablet: 2,
                          desktop: 2,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      if (showHousehold && recipe.household != null)
                        Row(
                          children: [
                            HouseholdCircleAvatar(
                              household: recipe.household!,
                              radius: 15,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                recipe.household!.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (recipe.household!.verified)
                              Icon(
                                Icons.verified_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          ],
                        ),
                      if (onLongPressed != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (onAddToDate != null)
                              LoadingElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  padding: EdgeInsets.zero,
                                ).copyWith(
                                  elevation: ButtonStyleButton.allOrNull(0.0),
                                  iconColor: WidgetStatePropertyAll(
                                      Theme.of(context).colorScheme.onPrimary),
                                ),
                                onPressed: onAddToDate,
                                child: const Icon(Icons.calendar_month_rounded),
                              ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: LoadingElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                ).copyWith(
                                  elevation: ButtonStyleButton.allOrNull(0.0),
                                ),
                                onPressed: onLongPressed,
                                child: LayoutBuilder(builder:
                                    (BuildContext context,
                                        BoxConstraints size) {
                                  final TextPainter painter = TextPainter(
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    textDirection: TextDirection.ltr,
                                    text: TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .addRecipeToPlannerShort,
                                    ),
                                  );

                                  painter.layout(maxWidth: size.maxWidth);

                                  return Text(
                                    painter.didExceedMaxLines
                                        ? AppLocalizations.of(context)!.add
                                        : AppLocalizations.of(context)!
                                            .addRecipeToPlannerShort,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _frostedChip({required Widget child}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(90),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: Colors.white.withAlpha(40)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: child,
      ),
    );
  }

  Future<void> _defaultOnTap(BuildContext context) async {
    String query = "?showHousehold=${showHousehold}";
    final household = context.read<HouseholdCubit?>()?.state.household;
    if (household == null) {
      debugPrint("RecipeCard onTap called without a Household context");
      final lastHousehold = await PreferenceStorage.getInstance().readInt(
        key: 'lastHouseholdId',
      );
      if (lastHousehold == null) {
        context.push<UpdateEnum>(
          "/recipe/${recipe.id}${query}",
          extra: recipe,
        );
      } else {
        final res = await context.push<UpdateEnum>(
          "/household/${lastHousehold}/recipes/details/${recipe.id}${query}",
          extra: Tuple2<Household, Recipe>(Household(id: lastHousehold), recipe),
        );
        _handleUpdate(res);
      }
    } else {
      final res = await context.push<UpdateEnum>(
        "/household/${household.id}/recipes/details/${recipe.id}${query}",
        extra: Tuple2<Household, Recipe>(household, recipe),
      );
      _handleUpdate(res);
    }
  }

  void _handleUpdate(UpdateEnum? res) {
    if (onUpdated != null &&
        (res == UpdateEnum.updated || res == UpdateEnum.deleted)) {
      onUpdated!();
    }
  }
}
