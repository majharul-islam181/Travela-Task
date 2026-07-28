import '../../../../core/utils/json_readers.dart';
import '../../domain/entities/property.dart';
import 'property_image_model.dart';

class PropertyModel extends Property {
  const PropertyModel({
    required super.id,
    required super.title,
    required super.address,
    required super.price,
    required super.reviewsCount,
    required super.isHotel,
    required super.bedroom,
    required super.beds,
    required super.bathroom,
    required super.maxGuest,
    required super.images,
    super.offerPrice,
    super.reviewsAvg,
  });

  factory PropertyModel.fromJson(final Map<String, dynamic> json) {
    final dynamic rawImages = json['images'];
    final List<PropertyImageModel> images = rawImages is List
        ? rawImages
              .whereType<Map<String, dynamic>>()
              .map(PropertyImageModel.fromJson)
              .where((final image) => image.url.isNotEmpty)
              .toList()
        : const <PropertyImageModel>[];

    return PropertyModel(
      id: JsonReaders.readInt(json['id']),
      title: json['title']?.toString() ?? 'Untitled stay',
      address: json['address']?.toString() ?? '',
      price: JsonReaders.readNum(json['price']),
      offerPrice: JsonReaders.readNullableNum(json['offer_price']),
      reviewsAvg: JsonReaders.readNullableDouble(json['reviews_avg']),
      reviewsCount: JsonReaders.readInt(json['reviews_count']),
      isHotel: json['is_hotel'] == true,
      bedroom: JsonReaders.readInt(json['bedroom']),
      beds: JsonReaders.readInt(json['beds']),
      bathroom: JsonReaders.readInt(json['bathroom']),
      maxGuest: JsonReaders.readInt(json['max_guest']),
      images: images,
    );
  }
}
