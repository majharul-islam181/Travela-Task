import 'package:equatable/equatable.dart';
import 'location.dart';

class PropertySearchParams extends Equatable {
  final Location location;
  final String from;
  final String to;
  final int guests;
  final String price;
  final int rooms;
  final int page;
  final int perPage;

  const PropertySearchParams({
    required this.location,
    required this.from,
    required this.to,
    required this.guests,
    required this.price,
    this.rooms = 1,
    this.page = 1,
    this.perPage = 20,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      'location_id': location.id,
      'location': location.latLng,
      'address_name': location.name,
      'within': location.within,
      'tier_1': location.tier1,
      'tier_2': location.tier2,
      'from': from,
      'to': to,
      'guest': guests,
      'rooms': rooms,
      'price': price,
      'page': page,
      'per_page': perPage,
    };
  }

  @override
  List<Object?> get props => [
    location,
    from,
    to,
    guests,
    price,
    rooms,
    page,
    perPage,
  ];
}
