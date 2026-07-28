import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/property_search_params.dart';
import '../../domain/entities/property_search_stream_event.dart';
import '../../domain/repositories/property_search_repository.dart';
import '../datasources/property_search_remote_data_source.dart';

class PropertySearchRepositoryImpl implements PropertySearchRepository {
  final PropertySearchRemoteDataSource _remoteDataSource;

  const PropertySearchRepositoryImpl(this._remoteDataSource);

  @override
  Stream<Either<Failure, PropertySearchStreamEvent>> searchProperties(
    final PropertySearchParams params, {
    final CancelToken? cancelToken,
  }) async* {
    try {
      await for (final event in _remoteDataSource.searchProperties(
        params,
        cancelToken: cancelToken,
      )) {
        yield Right(event);
      }
    } on NetworkException catch (error) {
      yield Left(NetworkFailure(error.message));
    } on ServerException catch (error) {
      yield Left(ServerFailure(error.message, statusCode: error.statusCode));
    } on FormatException catch (error) {
      yield Left(ServerFailure('Could not parse search stream: $error'));
    } on Exception catch (error) {
      if (cancelToken?.isCancelled == true) {
        return;
      }
      yield Left(UnknownFailure(error.toString()));
    }
  }
}
