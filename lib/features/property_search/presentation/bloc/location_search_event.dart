part of 'location_search_bloc.dart';

sealed class LocationSearchEvent extends Equatable {
  const LocationSearchEvent();

  @override
  List<Object?> get props => [];
}

class LocationQueryChanged extends LocationSearchEvent {
  final String value;

  const LocationQueryChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class LocationSelected extends LocationSearchEvent {
  final Location location;

  const LocationSelected(this.location);

  @override
  List<Object?> get props => [location];
}

class LocationSearchCleared extends LocationSearchEvent {
  const LocationSearchCleared();
}

class LocationSearchRequested extends LocationSearchEvent {
  final String query;

  const LocationSearchRequested(this.query);

  @override
  List<Object?> get props => [query];
}
