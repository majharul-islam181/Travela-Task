import '../../../../core/utils/json_readers.dart';
import '../../domain/entities/location.dart';

class LocationModel extends Location {
  const LocationModel({
    required super.id,
    required super.name,
    required super.lat,
    required super.lng,
    required super.within,
    required super.tier1,
    required super.tier2,
  });

  factory LocationModel.fromJson(final Map<String, dynamic> json) {
    return LocationModel(
      id: JsonReaders.readInt(json['id']),
      name: json['name']?.toString() ?? '',
      lat: JsonReaders.readDouble(json['lat']),
      lng: JsonReaders.readDouble(json['lng']),
      within: JsonReaders.readDouble(json['within']),
      tier1: JsonReaders.readDouble(json['tier_1']),
      tier2: JsonReaders.readDouble(json['tier_2']),
    );
  }
}
