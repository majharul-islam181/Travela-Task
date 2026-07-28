import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final int id;
  final String name;
  final double lat;
  final double lng;
  final double within;
  final double tier1;
  final double tier2;

  const Location({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.within,
    required this.tier1,
    required this.tier2,
  });

  String get latLng => '$lat,$lng';

  @override
  List<Object?> get props => [id, name, lat, lng, within, tier1, tier2];
}
