import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_context.dart';
import '../bloc/property_search_bloc.dart';

class InitialResultsView extends StatelessWidget {
  const InitialResultsView({super.key});

  @override
  Widget build(final BuildContext context) {
    return const ResultMessageView(
      icon: Icons.travel_explore,
      message: 'Choose a location to start.',
    );
  }
}

class EmptyResultsView extends StatelessWidget {
  const EmptyResultsView({super.key});

  @override
  Widget build(final BuildContext context) {
    return const ResultMessageView(
      icon: Icons.search_off,
      message: 'No stays matched these filters.',
    );
  }
}

class ErrorResultsView extends StatelessWidget {
  final String message;

  const ErrorResultsView({super.key, required this.message});

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;

    return Column(
      children: [
        ResultMessageView(icon: Icons.error_outline, message: message),
        SizedBox(height: theme.spacing.md),
        OutlinedButton.icon(
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
          onPressed: () {
            context.read<PropertySearchBloc>().add(
              const PropertySearchRetryRequested(),
            );
          },
        ),
      ],
    );
  }
}

class ResultMessageView extends StatelessWidget {
  final IconData icon;
  final String message;

  const ResultMessageView({
    super.key,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(theme.spacing.lg),
      decoration: BoxDecoration(
        color: theme.colors.surfaceContainerLow,
        borderRadius: theme.radius.card,
        border: Border.all(color: theme.colors.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.colors.onSurfaceVariant),
          SizedBox(height: theme.spacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.text.bodyMedium?.copyWith(
              color: theme.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
