import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/property_search_params.dart';
import '../../domain/entities/property_search_stream_event.dart';
import '../models/property_model.dart';
import '../models/search_meta_model.dart';

class PropertySearchRemoteDataSource {
  final DioClient _client;

  const PropertySearchRemoteDataSource(this._client);

  Stream<PropertySearchStreamEvent> searchProperties(
    final PropertySearchParams params, {
    final CancelToken? cancelToken,
  }) async* {
    final response = await _client.getStream(
      ApiConstants.propertySearchStreamEndpoint,
      queryParameters: params.toQueryParameters(),
      options: Options(headers: {'Accept': 'text/event-stream'}),
      cancelToken: cancelToken,
    );

    final ResponseBody? body = response.data;
    if (body == null) {
      throw const ServerException(message: 'Empty search stream.');
    }

    String? eventName;
    final List<String> dataLines = [];

    await for (final String line
        in body.stream
            .cast<List<int>>()
            .transform(utf8.decoder)
            .transform(const LineSplitter())) {
      if (cancelToken?.isCancelled == true) {
        return;
      }

      if (line.trim().isEmpty) {
        final PropertySearchStreamEvent? event = _parseFrame(
          eventName: eventName,
          data: dataLines.join('\n'),
        );
        eventName = null;
        dataLines.clear();

        if (event != null) {
          yield event;
        }
        continue;
      }

      if (line.startsWith('event:')) {
        eventName = line.substring('event:'.length).trim();
      } else if (line.startsWith('data:')) {
        dataLines.add(line.substring('data:'.length).trim());
      }
    }

    final PropertySearchStreamEvent? event = _parseFrame(
      eventName: eventName,
      data: dataLines.join('\n'),
    );
    if (event != null) {
      yield event;
    }
  }

  PropertySearchStreamEvent? _parseFrame({
    required final String? eventName,
    required final String data,
  }) {
    if (eventName == null || eventName.isEmpty) {
      return null;
    }

    final Map<String, dynamic> json = _decodeData(data);
    _logSearchEvent(eventName, json);

    switch (eventName) {
      case 'meta':
        return PropertySearchMetaReceived(SearchMetaModel.fromJson(json));
      case 'item':
        return PropertySearchItemReceived(PropertyModel.fromJson(json));
      case 'done':
        return const PropertySearchDoneReceived();
      case 'error':
        return PropertySearchErrorReceived(
          json['message']?.toString() ??
              json['error']?.toString() ??
              'Search failed.',
        );
      default:
        return null;
    }
  }

  Map<String, dynamic> _decodeData(final String data) {
    if (data.trim().isEmpty) {
      return const {};
    }

    final dynamic decoded = jsonDecode(data);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return const {};
  }

  void _logSearchEvent(
    final String eventName,
    final Map<String, dynamic> json,
  ) {
    if (!kDebugMode) {
      return;
    }

    switch (eventName) {
      case 'meta':
        debugPrint(
          'SSE meta -> total_count: ${json['total_count']}, '
          'pagination: ${json['pagination']}',
        );
      case 'item':
        debugPrint(
          'SSE item -> id: ${json['id']}, '
          'title: ${json['title']}, '
          'address: ${json['address']}, '
          'price: ${json['price']}, '
          'offer_price: ${json['offer_price']}, '
          'reviews_avg: ${json['reviews_avg']}',
        );
      case 'done':
        debugPrint('SSE done -> search stream finished');
      case 'error':
        debugPrint('SSE error -> $json');
      default:
        debugPrint('SSE $eventName -> $json');
    }
  }
}
