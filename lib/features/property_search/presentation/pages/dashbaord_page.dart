import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/core_di.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/property_search_params.dart';
import '../bloc/location_search_bloc.dart';
import '../bloc/property_search_bloc.dart';
import '../bloc/search_filter_bloc.dart';
import '../widgets/filter_controls.dart';
import '../widgets/location_search_field.dart';
import '../widgets/property_results_view.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationSearchBloc>(
          create: (_) => sl<LocationSearchBloc>(),
        ),
        BlocProvider<SearchFilterBloc>(create: (_) => sl<SearchFilterBloc>()),
        BlocProvider<PropertySearchBloc>(
          create: (_) => sl<PropertySearchBloc>(),
        ),
      ],
      child: BlocListener<LocationSearchBloc, LocationSearchState>(
        listenWhen: (final previous, final current) {
          return previous.selectedLocation != current.selectedLocation;
        },
        listener:
            (final BuildContext context, final LocationSearchState state) {
              final Location? selectedLocation = state.selectedLocation;
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
                    LocationSearchField(controller: _locationController),
                    SizedBox(height: theme.spacing.md),
                    const FilterControls(),
                    SizedBox(height: theme.spacing.lg),
                    BlocBuilder<LocationSearchBloc, LocationSearchState>(
                      builder: (final context, final locationState) {
                        return BlocBuilder<SearchFilterBloc, SearchFilterState>(
                          builder: (final context, final filterState) {
                            return FilledButton.icon(
                              icon: const Icon(Icons.travel_explore),
                              label: const Text('Search'),
                              onPressed:
                                  locationState.hasSelectedLocation &&
                                      filterState.isValid
                                  ? () {
                                      context.read<PropertySearchBloc>().add(
                                        PropertySearchStarted(
                                          PropertySearchParams(
                                            location:
                                                locationState.selectedLocation!,
                                            from: filterState.fromParam,
                                            to: filterState.toParam,
                                            guests: filterState.guests,
                                            price: filterState.priceParam,
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: theme.spacing.xxl),
                    const PropertyResultsView(),
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
