import '../../../../core/utils/json_readers.dart';
import '../../domain/entities/property_image.dart';

class PropertyImageModel extends PropertyImage {
  const PropertyImageModel({required super.id, required super.url});

  factory PropertyImageModel.fromJson(final Map<String, dynamic> json) {
    return PropertyImageModel(
      id: JsonReaders.readInt(json['id']),
      url: json['url']?.toString() ?? '',
    );
  }
}
