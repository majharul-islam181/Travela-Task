import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_remote_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource _remoteDataSource;

  const LocationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Location>>> searchLocations(
    final String query, {
    final CancelToken? cancelToken,
  }) async {
    try {
      final locations = await _remoteDataSource.searchLocations(
        query,
        cancelToken: cancelToken,
      );
      return Right(locations);
    } on NetworkException catch (error) {
      return Left(NetworkFailure(error.message));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message, statusCode: error.statusCode));
    } on UnauthorizedException catch (error) {
      return Left(UnauthorizedFailure(error.message));
    } on ValidationException catch (error) {
      return Left(ValidationFailure(error.message, errors: error.errors));
    } on Exception catch (error) {
      return Left(UnknownFailure(error.toString()));
    }
  }
}
