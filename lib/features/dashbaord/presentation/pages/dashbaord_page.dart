import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_context.dart';
import '../../../../core/theme/theme_manager.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Travela'),
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (final BuildContext context, final ThemeState state) {
              final bool isDark = state.themeMode == ThemeMode.dark;

              return IconButton(
                tooltip: isDark ? 'Use light theme' : 'Use dark theme',
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  context.read<ThemeBloc>().add(
                    ThemeChanged(isDark ? ThemeMode.light : ThemeMode.dark),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(theme.spacing.pagePadding),
          children: [
            Text(
              'Find stays',
              style: theme.text.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: theme.spacing.xs),
            Text(
              'Search Travela properties by destination, dates, guests, and price.',
              style: theme.text.bodyMedium?.copyWith(
                color: theme.colors.onSurfaceVariant,
              ),
            ),
            SizedBox(height: theme.spacing.lg),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  tooltip: 'Clear location',
                  icon: const Icon(Icons.close),
                  onPressed: () {},
                ),
                labelText: 'Location',
                hintText: 'Cox\'s Bazar',
              ),
            ),
            SizedBox(height: theme.spacing.md),
            Wrap(
              spacing: theme.spacing.sm,
              runSpacing: theme.spacing.sm,
              children: const [
                _FilterChip(icon: Icons.calendar_today, label: 'Dates'),
                _FilterChip(icon: Icons.group, label: '2 guests'),
                _FilterChip(icon: Icons.payments, label: '1000-5000'),
              ],
            ),
            SizedBox(height: theme.spacing.lg),
            FilledButton.icon(
              icon: const Icon(Icons.travel_explore),
              label: const Text('Search'),
              onPressed: null,
            ),
            SizedBox(height: theme.spacing.xxl),
            Center(
              child: Text(
                'Choose a location to start.',
                style: theme.text.bodyLarge?.copyWith(
                  color: theme.colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FilterChip({required this.icon, required this.label});

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.md,
        vertical: theme.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colors.surfaceContainerLow,
        borderRadius: theme.radius.feedItem,
        border: Border.all(color: theme.colors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: theme.colors.primary),
          SizedBox(width: theme.spacing.sm),
          Text(label, style: theme.text.bodyMedium),
        ],
      ),
    );
  }
}
