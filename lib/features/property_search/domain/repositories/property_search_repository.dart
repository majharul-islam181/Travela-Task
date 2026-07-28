import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failure.dart';
import '../entities/property_search_params.dart';
import '../entities/property_search_stream_event.dart';

abstract class PropertySearchRepository {
  Stream<Either<Failure, PropertySearchStreamEvent>> searchProperties(
    PropertySearchParams params, {
    CancelToken? cancelToken,
  });
}
