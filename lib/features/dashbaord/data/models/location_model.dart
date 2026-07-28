class LocationModel {
  final int id;
  final String name;
  final String? nameBn;
  final double lat;
  final double lng;
  final double within;
  final double tier1;
  final double tier2;

  const LocationModel({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.within,
    required this.tier1,
    required this.tier2,
    this.nameBn,
  });

  factory LocationModel.fromJson(final Map<String, dynamic> json) {
    return LocationModel(
      id: _readInt(json['id']),
      name: json['name']?.toString() ?? '',
      nameBn: json['name_bn']?.toString(),
      lat: _readDouble(json['lat']),
      lng: _readDouble(json['lng']),
      within: _readDouble(json['within']),
      tier1: _readDouble(json['tier_1']),
      tier2: _readDouble(json['tier_2']),
    );
  }

  String get latLng => '$lat,$lng';

  static int _readInt(final dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _readDouble(final dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
