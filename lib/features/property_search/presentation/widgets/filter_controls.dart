import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_context.dart';
import '../bloc/search_filter_bloc.dart';

class FilterControls extends StatelessWidget {
  const FilterControls({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<SearchFilterBloc, SearchFilterState>(
      builder: (final BuildContext context, final SearchFilterState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: context.spacing.sm,
              runSpacing: context.spacing.sm,
              children: [
                _DateRangeFilter(state: state),
                _GuestFilter(state: state),
              ],
            ),
            SizedBox(height: context.spacing.md),
            const _PriceRangeFilter(),
            if (!state.isValid) ...[
              SizedBox(height: context.spacing.sm),
              Text(
                'Please choose a valid date, guest count, and price range.',
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.error,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _DateRangeFilter extends StatelessWidget {
  final SearchFilterState state;

  const _DateRangeFilter({required this.state});

  @override
  Widget build(final BuildContext context) {
    return _FilterChip(
      icon: Icons.calendar_today,
      label: state.dateLabel,
      onTap: () => _pickDateRange(context),
    );
  }

  Future<void> _pickDateRange(final BuildContext context) async {
    final SearchFilterBloc bloc = context.read<SearchFilterBloc>();
    final DateTime today = DateTime.now();
    final DateTime firstDate = DateTime(today.year, today.month, today.day);

    final DateTimeRange? range = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: firstDate.add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: state.from, end: state.to),
    );

    if (range == null) {
      return;
    }

    bloc.add(FilterDateRangeChanged(from: range.start, to: range.end));
  }
}

class _GuestFilter extends StatelessWidget {
  final SearchFilterState state;

  const _GuestFilter({required this.state});

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.sm,
        vertical: theme.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colors.surfaceContainerLow,
        borderRadius: theme.radius.feedItem,
        border: Border.all(color: theme.colors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.group, size: 18),
          SizedBox(width: theme.spacing.sm),
          Text(state.guestLabel, style: theme.text.bodyMedium),
          SizedBox(width: theme.spacing.sm),
          IconButton(
            tooltip: 'Remove guest',
            icon: const Icon(Icons.remove_circle_outline),
            visualDensity: VisualDensity.compact,
            onPressed: state.guests > 1
                ? () {
                    context.read<SearchFilterBloc>().add(
                      const FilterGuestDecremented(),
                    );
                  }
                : null,
          ),
          IconButton(
            tooltip: 'Add guest',
            icon: const Icon(Icons.add_circle_outline),
            visualDensity: VisualDensity.compact,
            onPressed: () {
              context.read<SearchFilterBloc>().add(
                const FilterGuestIncremented(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PriceRangeFilter extends StatefulWidget {
  const _PriceRangeFilter();

  @override
  State<_PriceRangeFilter> createState() => _PriceRangeFilterState();
}

class _PriceRangeFilterState extends State<_PriceRangeFilter> {
  late final TextEditingController _minController;
  late final TextEditingController _maxController;

  @override
  void initState() {
    super.initState();
    final SearchFilterState state = context.read<SearchFilterBloc>().state;
    _minController = TextEditingController(text: state.minPrice.toString());
    _maxController = TextEditingController(text: state.maxPrice.toString());
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;

    return BlocListener<SearchFilterBloc, SearchFilterState>(
      listenWhen: (final previous, final current) {
        return previous.minPrice != current.minPrice ||
            previous.maxPrice != current.maxPrice;
      },
      listener: (final context, final state) {
        _syncController(_minController, state.minPrice.toString());
        _syncController(_maxController, state.maxPrice.toString());
      },
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _minController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (final value) {
                context.read<SearchFilterBloc>().add(
                  FilterMinPriceChanged(value),
                );
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.payments),
                labelText: 'Min price',
              ),
            ),
          ),
          SizedBox(width: theme.spacing.sm),
          Expanded(
            child: TextField(
              controller: _maxController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (final value) {
                context.read<SearchFilterBloc>().add(
                  FilterMaxPriceChanged(value),
                );
              },
              decoration: const InputDecoration(labelText: 'Max price'),
            ),
          ),
        ],
      ),
    );
  }

  void _syncController(
    final TextEditingController controller,
    final String value,
  ) {
    if (controller.text == value) {
      return;
    }
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FilterChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;

    return InkWell(
      borderRadius: theme.radius.feedItem,
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
