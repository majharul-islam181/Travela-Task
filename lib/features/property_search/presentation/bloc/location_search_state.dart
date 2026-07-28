part of 'location_search_bloc.dart';

enum LocationSearchStatus { initial, loading, success, empty, failure }

class LocationSearchState extends Equatable {
  final LocationSearchStatus status;
  final String query;
  final List<Location> suggestions;
  final Location? selectedLocation;
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
    final List<Location>? suggestions,
    final Object? selectedLocation = copyWithSentinel,
    final Object? errorMessage = copyWithSentinel,
  }) {
    return LocationSearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      suggestions: suggestions ?? this.suggestions,
      selectedLocation: selectedLocation == copyWithSentinel
          ? this.selectedLocation
          : selectedLocation as Location?,
      errorMessage: errorMessage == copyWithSentinel
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
