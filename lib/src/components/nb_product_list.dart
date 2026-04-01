import 'package:flutter/material.dart';
import '../theme/nb_theme.dart';

// ─── Data model ───────────────────────────────────────────────────────────────

/// Data for a single product item rendered by [NbProductGridView] or
/// [NbProductListView].
class NbProductItem {
  const NbProductItem({
    required this.title,
    required this.price,
    this.originalPrice,
    this.image,
    this.badge,
    this.badgeColor,
    this.rating,
    this.reviewCount,
    this.onTap,
    this.onAddToCart,
  });

  /// Product name.
  final String title;

  /// Formatted price string, e.g. `'\$29.99'`.
  final String price;

  /// Original price (shown with strikethrough). Pass when item is on sale.
  final String? originalPrice;

  /// Optional image widget. Use `Image.network(...)`, `Image.asset(...)`, or any
  /// widget. If `null`, a muted placeholder icon is shown.
  final Widget? image;

  /// Badge label shown over the image (e.g. `'Sale'`, `'New'`).
  final String? badge;

  /// Badge background color. Defaults to [NbColorScheme.primary].
  final Color? badgeColor;

  /// Star rating value from 0.0 to 5.0. Shows star icons when set.
  final double? rating;

  /// Number of reviews shown next to rating.
  final int? reviewCount;

  /// Called when the card/tile is tapped.
  final VoidCallback? onTap;

  /// Called when the `+` add button is tapped.
  final VoidCallback? onAddToCart;
}

// ─── NbProductGridView ────────────────────────────────────────────────────────

/// Displays a list of [NbProductItem] in a grid layout.
///
/// Use [shrinkWrap] + [physics] to embed inside a [Column] or [CustomScrollView].
///
/// ```dart
/// NbProductGridView(
///   items: _products,
///   crossAxisCount: 2,
///   shrinkWrap: true,
///   physics: const NeverScrollableScrollPhysics(),
/// )
/// ```
class NbProductGridView extends StatelessWidget {
  const NbProductGridView({
    super.key,
    required this.items,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.imageHeight = 140,
  });

  /// Product data list.
  final List<NbProductItem> items;

  /// Number of columns. Default: 2.
  final int crossAxisCount;

  /// Horizontal gap between cards. Default: 12.
  final double crossAxisSpacing;

  /// Vertical gap between cards. Default: 12.
  final double mainAxisSpacing;

  /// Padding around the grid.
  final EdgeInsets? padding;

  /// Use `true` when embedding inside a [Column]. Default: false.
  final bool shrinkWrap;

  /// Scroll physics. Use [NeverScrollableScrollPhysics] when embedding.
  final ScrollPhysics? physics;

  /// Height of the image section in each card. Default: 140.
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    // content area ≈ imageHeight + 84 (title + price row + padding)
    final ratio = imageHeight / (imageHeight + 84);

    return GridView.builder(
      padding: padding ?? EdgeInsets.zero,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: ratio,
      ),
      itemBuilder: (_, i) => _NbProductGridCard(item: items[i], imageHeight: imageHeight),
    );
  }
}

// ─── NbProductListView ────────────────────────────────────────────────────────

/// Displays a list of [NbProductItem] in a vertical list layout with the image
/// on the left and details on the right.
///
/// ```dart
/// NbProductListView(
///   items: _products,
///   shrinkWrap: true,
///   physics: const NeverScrollableScrollPhysics(),
/// )
/// ```
class NbProductListView extends StatelessWidget {
  const NbProductListView({
    super.key,
    required this.items,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.imageSize = 110,
    this.spacing = 12,
  });

  /// Product data list.
  final List<NbProductItem> items;

  /// Padding around the list.
  final EdgeInsets? padding;

  /// Use `true` when embedding inside a [Column]. Default: false.
  final bool shrinkWrap;

  /// Scroll physics. Use [NeverScrollableScrollPhysics] when embedding.
  final ScrollPhysics? physics;

  /// Width (and min height) of the image on the left. Default: 110.
  final double imageSize;

  /// Vertical space between items. Default: 12.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? EdgeInsets.zero,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: spacing),
      itemBuilder: (_, i) => _NbProductListTile(item: items[i], imageSize: imageSize),
    );
  }
}

// ─── Grid card ────────────────────────────────────────────────────────────────

class _NbProductGridCard extends StatefulWidget {
  const _NbProductGridCard({
    required this.item,
    required this.imageHeight,
  });

  final NbProductItem item;
  final double imageHeight;

  @override
  State<_NbProductGridCard> createState() => _NbProductGridCardState();
}

class _NbProductGridCardState extends State<_NbProductGridCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;
    final item = widget.item;
    final isTappable = item.onTap != null;
    final radius = theme.borderRadius;
    final bWidth = theme.borderWidth;
    final offset = _pressed ? theme.shadowOffsetX : 0.0;

    Widget card = AnimatedContainer(
      duration: theme.pressAnimationDuration,
      transform: isTappable ? Matrix4.translationValues(offset, offset, 0) : Matrix4.identity(),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: colors.border, width: bWidth),
        boxShadow: isTappable && !_pressed ? [theme.hardShadow] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Image (clipped to card's top corners) ─────────────────────
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius - bWidth),
              topRight: Radius.circular(radius - bWidth),
            ),
            child: Stack(
              children: [
                Container(
                  height: widget.imageHeight,
                  color: colors.muted,
                  child: item.image != null
                      ? SizedBox.expand(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            clipBehavior: Clip.hardEdge,
                            child: item.image,
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 40,
                            color: colors.mutedForeground,
                          ),
                        ),
                ),
                if (item.badge != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _Badge(
                      label: item.badge!,
                      color: item.badgeColor ?? colors.primary,
                      foreground: item.badgeColor != null ? colors.foreground : colors.primaryForeground,
                      borderColor: colors.border,
                      borderWidth: bWidth,
                      borderRadius: radius,
                      labelStyle: theme.typography.labelSmall,
                    ),
                  ),
              ],
            ),
          ),

          // ── Content ───────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.title,
                    style: theme.typography.label.copyWith(
                      color: colors.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.price,
                              style: theme.typography.label.copyWith(
                                color: colors.foreground,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (item.originalPrice != null)
                              Text(
                                item.originalPrice!,
                                style: theme.typography.caption.copyWith(
                                  color: colors.mutedForeground,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: colors.mutedForeground,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (item.onAddToCart != null)
                        _AddButton(
                          onTap: item.onAddToCart!,
                          primaryColor: colors.primary,
                          primaryForeground: colors.primaryForeground,
                          borderColor: colors.border,
                          borderWidth: bWidth,
                          borderRadius: radius,
                          animationDuration: theme.pressAnimationDuration,
                          shadowOffsetX: theme.shadowOffsetX,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (!isTappable) return card;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        item.onTap!();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: Container(
        margin: theme.shadowMargin,
        child: card,
      ),
    );
  }
}

// ─── List tile ────────────────────────────────────────────────────────────────

class _NbProductListTile extends StatefulWidget {
  const _NbProductListTile({
    required this.item,
    required this.imageSize,
  });

  final NbProductItem item;
  final double imageSize;

  @override
  State<_NbProductListTile> createState() => _NbProductListTileState();
}

class _NbProductListTileState extends State<_NbProductListTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.nbTheme;
    final colors = theme.colorScheme;
    final item = widget.item;
    final isTappable = item.onTap != null;
    final radius = theme.borderRadius;
    final bWidth = theme.borderWidth;
    final offset = _pressed ? theme.shadowOffsetX : 0.0;

    Widget tile = AnimatedContainer(
      duration: theme.pressAnimationDuration,
      transform: isTappable ? Matrix4.translationValues(offset, offset, 0) : Matrix4.identity(),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: colors.border, width: bWidth),
        boxShadow: isTappable && !_pressed ? [theme.hardShadow] : null,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Image (clipped to left corners) ───────────────────────
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius - bWidth),
                bottomLeft: Radius.circular(radius - bWidth),
              ),
              child: Stack(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: widget.imageSize,
                      minWidth: widget.imageSize,
                      maxWidth: widget.imageSize,
                    ),
                    child: Container(
                      color: colors.muted,
                      child: item.image != null
                          ? FittedBox(
                              fit: BoxFit.cover,
                              clipBehavior: Clip.hardEdge,
                              child: SizedBox(
                                width: widget.imageSize,
                                height: widget.imageSize,
                                child: item.image,
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 32,
                                color: colors.mutedForeground,
                              ),
                            ),
                    ),
                  ),
                  if (item.badge != null)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: _Badge(
                        label: item.badge!,
                        color: item.badgeColor ?? colors.primary,
                        foreground: item.badgeColor != null ? colors.foreground : colors.primaryForeground,
                        borderColor: colors.border,
                        borderWidth: bWidth,
                        borderRadius: radius,
                        labelStyle: theme.typography.labelSmall,
                      ),
                    ),
                ],
              ),
            ),

            // ── Vertical divider ──────────────────────────────────────
            Container(width: bWidth, color: colors.border),

            // ── Content ───────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.typography.label.copyWith(
                        color: colors.foreground,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.rating != null) ...[
                      const SizedBox(height: 4),
                      _StarRating(
                        rating: item.rating!,
                        reviewCount: item.reviewCount,
                        warningColor: colors.warning,
                        mutedForeground: colors.mutedForeground,
                        captionStyle: theme.typography.caption,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.price,
                              style: theme.typography.title.copyWith(
                                color: colors.foreground,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (item.originalPrice != null)
                              Text(
                                item.originalPrice!,
                                style: theme.typography.caption.copyWith(
                                  color: colors.mutedForeground,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: colors.mutedForeground,
                                ),
                              ),
                          ],
                        ),
                        const Spacer(),
                        if (item.onAddToCart != null)
                          _AddButton(
                            onTap: item.onAddToCart!,
                            primaryColor: colors.primary,
                            primaryForeground: colors.primaryForeground,
                            borderColor: colors.border,
                            borderWidth: bWidth,
                            borderRadius: radius,
                            animationDuration: theme.pressAnimationDuration,
                            shadowOffsetX: theme.shadowOffsetX,
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
    );

    if (!isTappable) return tile;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        item.onTap!();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: Container(
        margin: theme.shadowMargin,
        child: tile,
      ),
    );
  }
}

// ─── Add button ───────────────────────────────────────────────────────────────

class _AddButton extends StatefulWidget {
  const _AddButton({
    required this.onTap,
    required this.primaryColor,
    required this.primaryForeground,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.animationDuration,
    required this.shadowOffsetX,
  });

  final VoidCallback onTap;
  final Color primaryColor;
  final Color primaryForeground;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final Duration animationDuration;
  final double shadowOffsetX;

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: widget.animationDuration,
        transform: _pressed ? Matrix4.translationValues(widget.shadowOffsetX, widget.shadowOffsetX, 0) : Matrix4.identity(),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: _pressed ? widget.primaryColor.withValues(alpha: 0.85) : widget.primaryColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
        ),
        child: Icon(
          Icons.add_rounded,
          size: 18,
          color: widget.primaryForeground,
        ),
      ),
    );
  }
}

// ─── Badge ────────────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    required this.foreground,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.labelStyle,
  });

  final String label;
  final Color color;
  final Color foreground;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius / 2),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Text(
        label,
        style: labelStyle.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─── Star rating ──────────────────────────────────────────────────────────────

class _StarRating extends StatelessWidget {
  const _StarRating({
    required this.rating,
    this.reviewCount,
    required this.warningColor,
    required this.mutedForeground,
    required this.captionStyle,
  });

  final double rating;
  final int? reviewCount;
  final Color warningColor;
  final Color mutedForeground;
  final TextStyle captionStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (i) {
          final filled = i < rating.floor();
          final half = !filled && i < rating && (rating - i) >= 0.5;
          return Icon(
            filled
                ? Icons.star_rounded
                : half
                    ? Icons.star_half_rounded
                    : Icons.star_outline_rounded,
            size: 14,
            color: warningColor,
          );
        }),
        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: captionStyle.copyWith(color: mutedForeground),
          ),
        ],
      ],
    );
  }
}
