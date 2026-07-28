import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_context.dart';
import '../bloc/property_search_bloc.dart';
import 'property_card.dart';
import 'property_result_placeholders.dart';

class PropertyResultsView extends StatelessWidget {
  const PropertyResultsView({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<PropertySearchBloc, PropertySearchState>(
      builder: (final BuildContext context, final PropertySearchState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SearchStatusHeader(state: state),
            if (state.status == PropertySearchStatus.initial)
              const InitialResultsView()
            else if (state.status == PropertySearchStatus.failure)
              ErrorResultsView(message: state.errorMessage ?? 'Search failed.')
            else if (state.status == PropertySearchStatus.empty)
              const EmptyResultsView()
            else ...[
              ...state.properties.map(PropertyCard.new),
              if (state.isReceiving) const _StreamingFooter(),
              if (state.status == PropertySearchStatus.done)
                const _FinishedFooter(),
            ],
          ],
        );
      },
    );
  }
}

class _SearchStatusHeader extends StatelessWidget {
  final PropertySearchState state;

  const _SearchStatusHeader({required this.state});

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;
    final int? totalCount = state.meta?.totalCount;

    if (state.status == PropertySearchStatus.initial) {
      return const SizedBox.shrink();
    }

    final String label = totalCount == null
        ? 'Searching stays'
        : '$totalCount stays';

    return Padding(
      padding: EdgeInsets.only(bottom: theme.spacing.md),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.text.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (state.isReceiving)
            const SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }
}

class _StreamingFooter extends StatelessWidget {
  const _StreamingFooter();

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: theme.spacing.md),
      child: Center(
        child: Text(
          'Receiving more stays...',
          style: theme.text.bodyMedium?.copyWith(
            color: theme.colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _FinishedFooter extends StatelessWidget {
  const _FinishedFooter();

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: theme.spacing.md),
      child: Center(
        child: Text(
          'All results loaded.',
          style: theme.text.bodyMedium?.copyWith(
            color: theme.colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
