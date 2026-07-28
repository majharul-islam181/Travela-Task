part of 'property_search_bloc.dart';

enum PropertySearchStatus { initial, loading, streaming, empty, failure, done }

class PropertySearchState extends Equatable {
  final PropertySearchStatus status;
  final SearchMeta? meta;
  final List<Property> properties;
  final String? errorMessage;
  final PropertySearchParams? lastParams;

  const PropertySearchState({
    this.status = PropertySearchStatus.initial,
    this.meta,
    this.properties = const [],
    this.errorMessage,
    this.lastParams,
  });

  bool get isReceiving =>
      status == PropertySearchStatus.loading ||
      status == PropertySearchStatus.streaming;

  PropertySearchState copyWith({
    final PropertySearchStatus? status,
    final Object? meta = copyWithSentinel,
    final List<Property>? properties,
    final Object? errorMessage = copyWithSentinel,
    final Object? lastParams = copyWithSentinel,
  }) {
    return PropertySearchState(
      status: status ?? this.status,
      meta: meta == copyWithSentinel ? this.meta : meta as SearchMeta?,
      properties: properties ?? this.properties,
      errorMessage: errorMessage == copyWithSentinel
          ? this.errorMessage
          : errorMessage as String?,
      lastParams: lastParams == copyWithSentinel
          ? this.lastParams
          : lastParams as PropertySearchParams?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    meta,
    properties,
    errorMessage,
    lastParams,
  ];
}
