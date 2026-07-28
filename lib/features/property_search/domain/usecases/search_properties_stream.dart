import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/property_search_params.dart';
import '../entities/property_search_stream_event.dart';
import '../repositories/property_search_repository.dart';

class SearchPropertiesStream {
  final PropertySearchRepository _repository;

  const SearchPropertiesStream(this._repository);

  Stream<Either<Failure, PropertySearchStreamEvent>> call(
    final SearchPropertiesStreamParams params,
  ) {
    return _repository.searchProperties(
      params.searchParams,
      cancelToken: params.cancelToken,
    );
  }
}

class SearchPropertiesStreamParams extends Equatable {
  final PropertySearchParams searchParams;
  final CancelToken? cancelToken;

  const SearchPropertiesStreamParams({
    required this.searchParams,
    this.cancelToken,
  });

  @override
  List<Object?> get props => [searchParams, cancelToken];
}
