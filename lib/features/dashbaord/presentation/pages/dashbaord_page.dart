import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/core_di.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../data/models/location_model.dart';
import '../cubit/location_search_cubit.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<LocationSearchCubit>(
      create: (_) => sl<LocationSearchCubit>(),
      child: BlocListener<LocationSearchCubit, LocationSearchState>(
        listenWhen: (final previous, final current) {
          return previous.selectedLocation != current.selectedLocation;
        },
        listener:
            (final BuildContext context, final LocationSearchState state) {
              final LocationModel? selectedLocation = state.selectedLocation;
              if (selectedLocation == null) {
                return;
              }

              _locationController.value = TextEditingValue(
                text: selectedLocation.name,
                selection: TextSelection.collapsed(
                  offset: selectedLocation.name.length,
                ),
              );
            },
        child: Builder(
          builder: (final BuildContext context) {
            final theme = context.theme;

            return Scaffold(
              appBar: AppBar(
                title: const Text('Travela'),
                actions: [
                  BlocBuilder<ThemeBloc, ThemeState>(
                    builder:
                        (final BuildContext context, final ThemeState state) {
                          final bool isDark = state.themeMode == ThemeMode.dark;

                          return IconButton(
                            tooltip: isDark
                                ? 'Use light theme'
                                : 'Use dark theme',
                            icon: Icon(
                              isDark ? Icons.light_mode : Icons.dark_mode,
                            ),
                            onPressed: () {
                              context.read<ThemeBloc>().add(
                                ThemeChanged(
                                  isDark ? ThemeMode.light : ThemeMode.dark,
                                ),
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
                    _LocationSearchField(controller: _locationController),
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
                    BlocBuilder<LocationSearchCubit, LocationSearchState>(
                      builder:
                          (
                            final BuildContext context,
                            final LocationSearchState state,
                          ) {
                            return FilledButton.icon(
                              icon: const Icon(Icons.travel_explore),
                              label: const Text('Search'),
                              onPressed: state.hasSelectedLocation
                                  ? () {}
                                  : null,
                            );
                          },
                    ),
                    SizedBox(height: theme.spacing.xxl),
                    BlocBuilder<LocationSearchCubit, LocationSearchState>(
                      builder:
                          (
                            final BuildContext context,
                            final LocationSearchState state,
                          ) {
                            final String label = state.hasSelectedLocation
                                ? 'Selected: ${state.selectedLocation!.name}'
                                : 'Choose a location to start.';

                            return Center(
                              child: Text(
                                label,
                                style: theme.text.bodyLarge?.copyWith(
                                  color: theme.colors.onSurfaceVariant,
                                ),
                              ),
                            );
                          },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LocationSearchField extends StatelessWidget {
  final TextEditingController controller;

  const _LocationSearchField({required this.controller});

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<LocationSearchCubit, LocationSearchState>(
          builder:
              (final BuildContext context, final LocationSearchState state) {
                return TextField(
                  controller: controller,
                  textInputAction: TextInputAction.search,
                  onChanged: context.read<LocationSearchCubit>().queryChanged,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: state.status == LocationSearchStatus.loading
                        ? const Padding(
                            padding: EdgeInsets.all(14),
                            child: SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            tooltip: 'Clear location',
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              controller.clear();
                              context.read<LocationSearchCubit>().clear();
                            },
                          ),
                    labelText: 'Location',
                    hintText: 'Cox\'s Bazar',
                  ),
                );
              },
        ),
        BlocBuilder<LocationSearchCubit, LocationSearchState>(
          builder:
              (final BuildContext context, final LocationSearchState state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: _LocationSuggestions(state: state),
                );
              },
        ),
      ],
    );
  }
}

class _LocationSuggestions extends StatelessWidget {
  final LocationSearchState state;

  const _LocationSuggestions({required this.state});

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;

    if (state.hasSelectedLocation ||
        state.query.isEmpty ||
        state.status == LocationSearchStatus.initial ||
        state.status == LocationSearchStatus.loading) {
      return const SizedBox.shrink();
    }

    if (state.status == LocationSearchStatus.empty) {
      return _SuggestionMessage(
        icon: Icons.search_off,
        message: 'No locations found for "${state.query}".',
      );
    }

    if (state.status == LocationSearchStatus.failure) {
      return _SuggestionMessage(
        icon: Icons.error_outline,
        message: state.errorMessage ?? 'Could not load locations.',
      );
    }

    return Container(
      key: const ValueKey('location-suggestions'),
      margin: EdgeInsets.only(top: theme.spacing.sm),
      decoration: BoxDecoration(
        color: theme.colors.surfaceContainerLow,
        borderRadius: theme.radius.card,
        border: Border.all(color: theme.colors.outlineVariant),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.suggestions.length,
        separatorBuilder: (final BuildContext context, final int index) {
          return Divider(color: theme.colors.divider);
        },
        itemBuilder: (final BuildContext context, final int index) {
          final LocationModel location = state.suggestions[index];

          return ListTile(
            leading: const Icon(Icons.place_outlined),
            title: Text(location.name),
            subtitle: Text(
              '${location.latLng} • ${location.within.toStringAsFixed(0)} km',
            ),
            onTap: () {
              FocusScope.of(context).unfocus();
              context.read<LocationSearchCubit>().selectLocation(location);
            },
          );
        },
      ),
    );
  }
}

class _SuggestionMessage extends StatelessWidget {
  final IconData icon;
  final String message;

  const _SuggestionMessage({required this.icon, required this.message});

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;

    return Container(
      key: ValueKey(message),
      margin: EdgeInsets.only(top: theme.spacing.sm),
      padding: EdgeInsets.all(theme.spacing.md),
      decoration: BoxDecoration(
        color: theme.colors.surfaceContainerLow,
        borderRadius: theme.radius.card,
        border: Border.all(color: theme.colors.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colors.onSurfaceVariant),
          SizedBox(width: theme.spacing.sm),
          Expanded(
            child: Text(
              message,
              style: theme.text.bodyMedium?.copyWith(
                color: theme.colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
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
