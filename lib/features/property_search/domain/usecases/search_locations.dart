import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/location.dart';
import '../repositories/location_repository.dart';

class SearchLocations implements UseCase<List<Location>, SearchLocationsParams> {
  final LocationRepository _repository;

  const SearchLocations(this._repository);

  @override
  Future<Either<Failure, List<Location>>> call(
    final SearchLocationsParams params,
  ) {
    return _repository.searchLocations(
      params.query,
      cancelToken: params.cancelToken,
    );
  }
}

class SearchLocationsParams extends Equatable {
  final String query;
  final CancelToken? cancelToken;

  const SearchLocationsParams({required this.query, this.cancelToken});

  @override
  List<Object?> get props => [query, cancelToken];
}
