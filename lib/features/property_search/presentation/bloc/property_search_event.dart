part of 'property_search_bloc.dart';

sealed class PropertySearchEvent extends Equatable {
  const PropertySearchEvent();

  @override
  List<Object?> get props => [];
}

class PropertySearchStarted extends PropertySearchEvent {
  final PropertySearchParams params;

  const PropertySearchStarted(this.params);

  @override
  List<Object?> get props => [params];
}

class PropertySearchRetryRequested extends PropertySearchEvent {
  const PropertySearchRetryRequested();
}

class PropertySearchCancelled extends PropertySearchEvent {
  const PropertySearchCancelled();
}

class _PropertySearchStreamEventReceived extends PropertySearchEvent {
  final PropertySearchStreamEvent event;

  const _PropertySearchStreamEventReceived(this.event);

  @override
  List<Object?> get props => [event];
}

class _PropertySearchFailed extends PropertySearchEvent {
  final String message;

  const _PropertySearchFailed(this.message);

  @override
  List<Object?> get props => [message];
}
