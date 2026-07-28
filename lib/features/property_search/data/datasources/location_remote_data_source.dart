import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/location_model.dart';

class LocationRemoteDataSource {
  final DioClient _client;

  const LocationRemoteDataSource(this._client);

  Future<List<LocationModel>> searchLocations(
    final String query, {
    final CancelToken? cancelToken,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.popularLocationsEndpoint,
      queryParameters: {'q': query},
      cancelToken: cancelToken,
    );

    final dynamic rawData = response.data?['data'];
    if (rawData is! List) {
      return const [];
    }

    return rawData
        .whereType<Map<String, dynamic>>()
        .map(LocationModel.fromJson)
        .where((final location) => location.id != 0 && location.name.isNotEmpty)
        .toList();
  }
}
