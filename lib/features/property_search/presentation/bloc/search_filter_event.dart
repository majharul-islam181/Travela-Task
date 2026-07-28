part of 'search_filter_bloc.dart';

sealed class SearchFilterEvent extends Equatable {
  const SearchFilterEvent();

  @override
  List<Object?> get props => [];
}

class FilterDateRangeChanged extends SearchFilterEvent {
  final DateTime from;
  final DateTime to;

  const FilterDateRangeChanged({required this.from, required this.to});

  @override
  List<Object?> get props => [from, to];
}

class FilterGuestIncremented extends SearchFilterEvent {
  const FilterGuestIncremented();
}

class FilterGuestDecremented extends SearchFilterEvent {
  const FilterGuestDecremented();
}

class FilterMinPriceChanged extends SearchFilterEvent {
  final String value;

  const FilterMinPriceChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class FilterMaxPriceChanged extends SearchFilterEvent {
  final String value;

  const FilterMaxPriceChanged(this.value);

  @override
  List<Object?> get props => [value];
}
