import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_filter_event.dart';
part 'search_filter_state.dart';

class SearchFilterBloc extends Bloc<SearchFilterEvent, SearchFilterState> {
  SearchFilterBloc() : super(SearchFilterState.initial()) {
    on<FilterDateRangeChanged>(_onDateRangeChanged);
    on<FilterGuestIncremented>(_onGuestIncremented);
    on<FilterGuestDecremented>(_onGuestDecremented);
    on<FilterMinPriceChanged>(_onMinPriceChanged);
    on<FilterMaxPriceChanged>(_onMaxPriceChanged);
  }

  void _onDateRangeChanged(
    final FilterDateRangeChanged event,
    final Emitter<SearchFilterState> emit,
  ) {
    DateTime to = event.to;
    if (to.isBefore(event.from)) {
      to = event.from.add(const Duration(days: 1));
    }
    emit(state.copyWith(from: event.from, to: to));
  }

  void _onGuestIncremented(
    final FilterGuestIncremented event,
    final Emitter<SearchFilterState> emit,
  ) {
    emit(state.copyWith(guests: state.guests + 1));
  }

  void _onGuestDecremented(
    final FilterGuestDecremented event,
    final Emitter<SearchFilterState> emit,
  ) {
    if (state.guests <= 1) {
      return;
    }
    emit(state.copyWith(guests: state.guests - 1));
  }

  void _onMinPriceChanged(
    final FilterMinPriceChanged event,
    final Emitter<SearchFilterState> emit,
  ) {
    final int? minPrice = int.tryParse(event.value);
    if (minPrice == null) {
      return;
    }
    emit(state.copyWith(minPrice: minPrice));
  }

  void _onMaxPriceChanged(
    final FilterMaxPriceChanged event,
    final Emitter<SearchFilterState> emit,
  ) {
    final int? maxPrice = int.tryParse(event.value);
    if (maxPrice == null) {
      return;
    }
    emit(state.copyWith(maxPrice: maxPrice));
  }
}
