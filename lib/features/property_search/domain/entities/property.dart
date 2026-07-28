import 'package:equatable/equatable.dart';
import 'property_image.dart';

class Property extends Equatable {
  final int id;
  final String title;
  final String address;
  final num price;
  final num? offerPrice;
  final double? reviewsAvg;
  final int reviewsCount;
  final bool isHotel;
  final int bedroom;
  final int beds;
  final int bathroom;
  final int maxGuest;
  final List<PropertyImage> images;

  const Property({
    required this.id,
    required this.title,
    required this.address,
    required this.price,
    required this.reviewsCount,
    required this.isHotel,
    required this.bedroom,
    required this.beds,
    required this.bathroom,
    required this.maxGuest,
    required this.images,
    this.offerPrice,
    this.reviewsAvg,
  });

  String? get firstImageUrl => images.isEmpty ? null : images.first.url;
  num get displayPrice => offerPrice ?? price;

  @override
  List<Object?> get props => [
    id,
    title,
    address,
    price,
    offerPrice,
    reviewsAvg,
    reviewsCount,
    isHotel,
    bedroom,
    beds,
    bathroom,
    maxGuest,
    images,
  ];
}
