import 'dart:async';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/copy_with_sentinel.dart';
import '../../domain/entities/location.dart';
import '../../domain/usecases/search_locations.dart';
part 'location_search_event.dart';
part 'location_search_state.dart';

class LocationSearchBloc
    extends Bloc<LocationSearchEvent, LocationSearchState> {
  final SearchLocations _searchLocations;
  Timer? _debounce;
  CancelToken? _cancelToken;

  LocationSearchBloc(this._searchLocations) : super(LocationSearchState()) {
    on<LocationQueryChanged>(_onQueryChanged);
    on<LocationSearchRequested>(_onSearchRequested);
    on<LocationSelected>(_onLocationSelected);
    on<LocationSearchCleared>(_onSearchCleared);
  }

  void _onQueryChanged(
    final LocationQueryChanged event,
    final Emitter<LocationSearchState> emit,
  ) {
    final String query = event.value.trim();
    _debounce?.cancel();

    if (query.isEmpty) {
      _cancelCurrentRequest();
      emit(LocationSearchState(status: LocationSearchStatus.initial));
      return;
    }

    emit(
      state.copyWith(
        query: query,
        status: LocationSearchStatus.loading,
        selectedLocation: null,
        errorMessage: null,
      ),
    );

    _debounce = Timer(const Duration(milliseconds: 450), () {
      add(LocationSearchRequested(query));
    });
  }

  Future<void> _onSearchRequested(
    final LocationSearchRequested event,
    final Emitter<LocationSearchState> emit,
  ) async {
    _cancelCurrentRequest();
    final CancelToken cancelToken = CancelToken();
    _cancelToken = cancelToken;

    try {
      final result = await _searchLocations(
        SearchLocationsParams(query: event.query, cancelToken: cancelToken),
      );

      if (cancelToken.isCancelled) {
        return;
      }

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: LocationSearchStatus.failure,
              query: event.query,
              suggestions: const [],
              selectedLocation: null,
              errorMessage: failure.message.isEmpty
                  ? 'Failed to fetch locations'
                  : failure.message,
            ),
          );
        },
        (suggestions) {
          emit(
            state.copyWith(
              status: suggestions.isEmpty
                  ? LocationSearchStatus.empty
                  : LocationSearchStatus.success,
              query: event.query,
              suggestions: suggestions,
              selectedLocation: null,
              errorMessage: null,
            ),
          );
        },
      );
    } on Exception catch (error) {
      if (cancelToken.isCancelled) {
        return;
      }

      emit(
        state.copyWith(
          status: LocationSearchStatus.failure,
          query: event.query,
          suggestions: const [],
          selectedLocation: null,
          errorMessage: error.toString().trim().isEmpty
              ? 'Could not load locations.'
              : error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  void _onLocationSelected(
    final LocationSelected event,
    final Emitter<LocationSearchState> emit,
  ) {
    _debounce?.cancel();
    _cancelCurrentRequest();
    emit(
      state.copyWith(
        status: LocationSearchStatus.success,
        query: event.location.name,
        suggestions: const [],
        selectedLocation: event.location,
        errorMessage: null,
      ),
    );
  }

  void _onSearchCleared(
    final LocationSearchCleared event,
    final Emitter<LocationSearchState> emit,
  ) {
    _debounce?.cancel();
    _cancelCurrentRequest();
    emit(const LocationSearchState());
  }

  void _cancelCurrentRequest() {
    if (_cancelToken?.isCancelled == false) {
      _cancelToken?.cancel();
    }
    _cancelToken = null;
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    _cancelCurrentRequest();
    return super.close();
  }
}
