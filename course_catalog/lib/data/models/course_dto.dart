// data/models/course_dto.dart
import '../../domain/entities/course.dart';

class CourseDto {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final bool isBeginner;

  const CourseDto({
    required this.id, 
    required this.title, 
    required this.description, 
    required this.imageUrl,
    required this.isBeginner
    });

  factory CourseDto.fromJson(Map<String, dynamic> json) {
    return CourseDto(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      isBeginner: json['isBeginner']
    );
  }

  Course toEntity({bool isFavorite = false}) {
    return Course(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      isBeginner: isBeginner,
      isFavorite: isFavorite
    );
  }
}