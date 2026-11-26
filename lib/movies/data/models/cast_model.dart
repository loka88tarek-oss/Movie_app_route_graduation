import 'package:movies_app/movies/domain/entities/movie_entity.dart';

class CastModel {
  final String name;
  final String characterName;
  final String? imageUrl;

  const CastModel({
    required this.name,
    required this.characterName,
    this.imageUrl,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    final image = json['url_small_image'] as String?;
    return CastModel(
      name: json['name'] as String? ?? '',
      characterName: json['character_name'] as String? ?? '',
      imageUrl: (image == null || image.isEmpty) ? null : image,
    );
  }

  CastEntity toEntity() =>
      CastEntity(name: name, characterName: characterName, imageUrl: imageUrl);
}
