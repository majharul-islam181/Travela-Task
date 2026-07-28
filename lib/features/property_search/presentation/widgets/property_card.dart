import 'package:flutter/material.dart';

import '../../../../core/theme/theme_context.dart';
import '../../domain/entities/property.dart';

class PropertyCard extends StatelessWidget {
  final Property property;

  const PropertyCard(this.property, {super.key});

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;
    final String? imageUrl = property.firstImageUrl;

    return Container(
      margin: EdgeInsets.only(bottom: theme.spacing.md),
      decoration: BoxDecoration(
        color: theme.colors.surfaceContainerLow,
        borderRadius: theme.radius.card,
        border: Border.all(color: theme.colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: imageUrl == null
                ? const _PropertyImageFallback()
                : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (final context, final error, final stack) {
                      return const _PropertyImageFallback();
                    },
                    loadingBuilder: (final context, final child, final event) {
                      if (event == null) {
                        return child;
                      }
                      return const _PropertyImageLoading();
                    },
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(theme.spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        property.title,
                        style: theme.text.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (property.reviewsAvg != null) ...[
                      SizedBox(width: theme.spacing.sm),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: 18,
                            color: theme.colors.warning,
                          ),
                          SizedBox(width: theme.spacing.xs),
                          Text(property.reviewsAvg!.toStringAsFixed(1)),
                        ],
                      ),
                    ],
                  ],
                ),
                SizedBox(height: theme.spacing.xs),
                Text(
                  property.address,
                  style: theme.text.bodyMedium?.copyWith(
                    color: theme.colors.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: theme.spacing.sm),
                Wrap(
                  spacing: theme.spacing.sm,
                  runSpacing: theme.spacing.xs,
                  children: [
                    _InfoChip(label: '${property.maxGuest} guests'),
                    _InfoChip(label: '${property.bedroom} bedrooms'),
                    _InfoChip(label: '${property.beds} beds'),
                    _InfoChip(label: '${property.bathroom} baths'),
                  ],
                ),
                SizedBox(height: theme.spacing.md),
                Row(
                  children: [
                    Text(
                      'BDT ${property.displayPrice}',
                      style: theme.text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (property.offerPrice != null) ...[
                      SizedBox(width: theme.spacing.sm),
                      Text(
                        '${property.price}',
                        style: theme.text.bodyMedium?.copyWith(
                          color: theme.colors.onSurfaceVariant,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.sm,
        vertical: theme.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colors.surfaceContainerHighest,
        borderRadius: theme.radius.small,
      ),
      child: Text(label, style: theme.text.bodySmall),
    );
  }
}

class _PropertyImageFallback extends StatelessWidget {
  const _PropertyImageFallback();

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;

    return ColoredBox(
      color: theme.colors.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.apartment,
          size: 40,
          color: theme.colors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _PropertyImageLoading extends StatelessWidget {
  const _PropertyImageLoading();

  @override
  Widget build(final BuildContext context) {
    return const ColoredBox(
      color: Color(0x11000000),
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}
