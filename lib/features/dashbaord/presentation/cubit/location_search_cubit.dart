import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/location_remote_data_source.dart';
import '../../data/models/location_model.dart';

enum LocationSearchStatus { initial, loading, success, empty, failure }

class LocationSearchState extends Equatable {
  final LocationSearchStatus status;
  final String query;
  final List<LocationModel> suggestions;
  final LocationModel? selectedLocation;
  final String? errorMessage;

  const LocationSearchState({
    this.status = LocationSearchStatus.initial,
    this.query = '',
    this.suggestions = const [],
    this.selectedLocation,
    this.errorMessage,
  });

  bool get hasSelectedLocation => selectedLocation != null;

  LocationSearchState copyWith({
    final LocationSearchStatus? status,
    final String? query,
    final List<LocationModel>? suggestions,
    final Object? selectedLocation = _unchanged,
    final Object? errorMessage = _unchanged,
  }) {
    return LocationSearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      suggestions: suggestions ?? this.suggestions,
      selectedLocation: selectedLocation == _unchanged
          ? this.selectedLocation
          : selectedLocation as LocationModel?,
      errorMessage: errorMessage == _unchanged
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    query,
    suggestions,
    selectedLocation,
    errorMessage,
  ];
}

const Object _unchanged = Object();

class LocationSearchCubit extends Cubit<LocationSearchState> {
  final LocationRemoteDataSource _remoteDataSource;

  Timer? _debounce;
  CancelToken? _cancelToken;

  LocationSearchCubit(this._remoteDataSource)
    : super(const LocationSearchState());

  void queryChanged(final String value) {
    final String query = value.trim();
    _debounce?.cancel();

    if (query.isEmpty) {
      _cancelInFlightRequest();
      emit(const LocationSearchState(status: LocationSearchStatus.initial));
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
      _search(query);
    });
  }

  void selectLocation(final LocationModel location) {
    _debounce?.cancel();
    _cancelInFlightRequest();
    emit(
      state.copyWith(
        status: LocationSearchStatus.success,
        query: location.name,
        suggestions: const [],
        selectedLocation: location,
        errorMessage: null,
      ),
    );
  }

  void clear() {
    _debounce?.cancel();
    _cancelInFlightRequest();
    emit(const LocationSearchState());
  }

  Future<void> _search(final String query) async {
    _cancelInFlightRequest();
    final CancelToken cancelToken = CancelToken();
    _cancelToken = cancelToken;

    try {
      final List<LocationModel> suggestions = await _remoteDataSource
          .searchLocations(query, cancelToken: cancelToken);

      if (cancelToken.isCancelled) {
        return;
      }

      emit(
        state.copyWith(
          status: suggestions.isEmpty
              ? LocationSearchStatus.empty
              : LocationSearchStatus.success,
          query: query,
          suggestions: suggestions,
          selectedLocation: null,
          errorMessage: null,
        ),
      );
    } on Exception catch (error) {
      if (cancelToken.isCancelled) {
        return;
      }

      emit(
        state.copyWith(
          status: LocationSearchStatus.failure,
          query: query,
          suggestions: const [],
          selectedLocation: null,
          errorMessage: _messageFromError(error),
        ),
      );
    }
  }

  String _messageFromError(final Object error) {
    final String message = error.toString();
    if (message.trim().isEmpty) {
      return 'Could not load locations.';
    }
    return message.replaceFirst('Exception: ', '');
  }

  void _cancelInFlightRequest() {
    if (_cancelToken?.isCancelled == false) {
      _cancelToken?.cancel();
    }
    _cancelToken = null;
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    _cancelInFlightRequest();
    return super.close();
  }
}
