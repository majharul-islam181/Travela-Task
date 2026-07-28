import 'package:equatable/equatable.dart';

class PropertyImage extends Equatable {
  final int id;
  final String url;

  const PropertyImage({required this.id, required this.url});

  @override
  List<Object?> get props => [id, url];
}
