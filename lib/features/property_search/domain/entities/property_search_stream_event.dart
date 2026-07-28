import 'package:equatable/equatable.dart';
import 'property.dart';
import 'search_meta.dart';

sealed class PropertySearchStreamEvent extends Equatable {
  const PropertySearchStreamEvent();

  @override
  List<Object?> get props => [];
}

class PropertySearchMetaReceived extends PropertySearchStreamEvent {
  final SearchMeta meta;

  const PropertySearchMetaReceived(this.meta);

  @override
  List<Object?> get props => [meta];
}

class PropertySearchItemReceived extends PropertySearchStreamEvent {
  final Property property;

  const PropertySearchItemReceived(this.property);

  @override
  List<Object?> get props => [property];
}

class PropertySearchDoneReceived extends PropertySearchStreamEvent {
  const PropertySearchDoneReceived();
}

class PropertySearchErrorReceived extends PropertySearchStreamEvent {
  final String message;

  const PropertySearchErrorReceived(this.message);

  @override
  List<Object?> get props => [message];
}
