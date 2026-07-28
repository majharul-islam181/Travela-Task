import 'dart:async';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/copy_with_sentinel.dart';
import '../../domain/entities/property.dart';
import '../../domain/entities/property_search_params.dart';
import '../../domain/entities/property_search_stream_event.dart';
import '../../domain/entities/search_meta.dart';
import '../../domain/usecases/search_properties_stream.dart';

part 'property_search_event.dart';
part 'property_search_state.dart';

class PropertySearchBloc
    extends Bloc<PropertySearchEvent, PropertySearchState> {
  final SearchPropertiesStream _searchPropertiesStream;

  StreamSubscription? _subscription;
  CancelToken? _cancelToken;

  PropertySearchBloc(this._searchPropertiesStream)
    : super(const PropertySearchState()) {
    on<PropertySearchStarted>(_onStarted);
    on<PropertySearchRetryRequested>(_onRetryRequested);
    on<PropertySearchCancelled>(_onCancelled);
    on<_PropertySearchStreamEventReceived>(_onStreamEventReceived);
    on<_PropertySearchFailed>(_onFailed);
  }

  Future<void> _onStarted(
    final PropertySearchStarted event,
    final Emitter<PropertySearchState> emit,
  ) async {
    await _cancelActiveStream();
    final CancelToken cancelToken = CancelToken();
    _cancelToken = cancelToken;

    emit(
      PropertySearchState(
        status: PropertySearchStatus.loading,
        lastParams: event.params,
      ),
    );

    _subscription =
        _searchPropertiesStream(
          SearchPropertiesStreamParams(
            searchParams: event.params,
            cancelToken: cancelToken,
          ),
        ).listen((result) {
          result.fold(
            (failure) => add(
              _PropertySearchFailed(
                failure.message.trim().isEmpty
                    ? 'Search failed.'
                    : failure.message,
              ),
            ),
            (streamEvent) =>
                add(_PropertySearchStreamEventReceived(streamEvent)),
          );
        });
  }

  void _onRetryRequested(
    final PropertySearchRetryRequested event,
    final Emitter<PropertySearchState> emit,
  ) {
    final PropertySearchParams? lastParams = state.lastParams;
    if (lastParams == null) {
      return;
    }
    add(PropertySearchStarted(lastParams));
  }

  Future<void> _onCancelled(
    final PropertySearchCancelled event,
    final Emitter<PropertySearchState> emit,
  ) async {
    await _cancelActiveStream();
    emit(const PropertySearchState());
  }

  void _onStreamEventReceived(
    final _PropertySearchStreamEventReceived event,
    final Emitter<PropertySearchState> emit,
  ) {
    switch (event.event) {
      case PropertySearchMetaReceived(:final meta):
        emit(
          state.copyWith(
            status: PropertySearchStatus.streaming,
            meta: meta,
            errorMessage: null,
          ),
        );
      case PropertySearchItemReceived(:final property):
        emit(
          state.copyWith(
            status: PropertySearchStatus.streaming,
            properties: [...state.properties, property],
            errorMessage: null,
          ),
        );
      case PropertySearchDoneReceived():
        emit(
          state.copyWith(
            status: state.properties.isEmpty
                ? PropertySearchStatus.empty
                : PropertySearchStatus.done,
            errorMessage: null,
          ),
        );
      case PropertySearchErrorReceived(:final message):
        emit(
          state.copyWith(
            status: PropertySearchStatus.failure,
            errorMessage: message,
          ),
        );
    }
  }

  Future<void> _onFailed(
    final _PropertySearchFailed event,
    final Emitter<PropertySearchState> emit,
  ) async {
    await _cancelActiveStream();
    emit(
      state.copyWith(
        status: PropertySearchStatus.failure,
        errorMessage: event.message,
      ),
    );
  }

  Future<void> _cancelActiveStream() async {
    if (_cancelToken?.isCancelled == false) {
      _cancelToken?.cancel();
    }
    _cancelToken = null;
    await _subscription?.cancel();
    _subscription = null;
  }

  @override
  Future<void> close() async {
    await _cancelActiveStream();
    return super.close();
  }
}
