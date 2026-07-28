import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_context.dart';
import '../../domain/entities/location.dart';
import '../bloc/location_search_bloc.dart';

class LocationSearchField extends StatelessWidget {
  final TextEditingController controller;

  const LocationSearchField({super.key, required this.controller});

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<LocationSearchBloc, LocationSearchState>(
          builder:
              (final BuildContext context, final LocationSearchState state) {
                return TextField(
                  controller: controller,
                  textInputAction: TextInputAction.search,
                  onChanged: (final value) {
                    context.read<LocationSearchBloc>().add(
                      LocationQueryChanged(value),
                    );
                  },
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
                              context.read<LocationSearchBloc>().add(
                                const LocationSearchCleared(),
                              );
                            },
                          ),
                    labelText: 'Location',
                    hintText: 'Cox\'s Bazar',
                  ),
                );
              },
        ),
        BlocBuilder<LocationSearchBloc, LocationSearchState>(
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
          final Location location = state.suggestions[index];

          return ListTile(
            leading: const Icon(Icons.place_outlined),
            title: Text(location.name),
            subtitle: Text(
              '${location.latLng} • ${location.within.toStringAsFixed(0)} km',
            ),
            onTap: () {
              FocusScope.of(context).unfocus();
              context.read<LocationSearchBloc>().add(
                LocationSelected(location),
              );
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
