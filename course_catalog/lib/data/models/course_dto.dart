// data/models/course_dto.dart
import '../../domain/entities/course.dart';
import '../../domain/entities/course_level.dart';

class CourseDto {
  final int id;
  final String title;
  final String level; 
  final String duration;
  final int numberOfLessons;
  final String shortDescription;
  final String fullDescription;

  const CourseDto({
    required this.id, 
    required this.title, 
    required this.level, 
    required this.duration, 
    required this.numberOfLessons, 
    required this.shortDescription, 
    required this.fullDescription
    });

  factory CourseDto.fromJson(Map<String, dynamic> json) {
    return CourseDto(
      id: json['id'],
      title: json['title'],
      level: json['level'],
      duration: json['duration'],
      numberOfLessons: json['numberOfLessons'],
      shortDescription: json['shortDescription'],
      fullDescription: json['fullDescription'],
    );
  }

  Course toEntity({bool isFavorite = false}) {
    return Course(
      id: id,
      title: title,
      level: _parseLevel(level),
      duration: duration,
      numberOfLessons: numberOfLessons,
      shortDescription: shortDescription,
      fullDescription: fullDescription,
      isFavorite: isFavorite
    );
  }

  CourseLevel _parseLevel(String value) {
    switch (value) {
    case 'beginner': return CourseLevel.beginner;
    case 'intermediate': return CourseLevel.intermediate;
    case 'advanced': return CourseLevel.advanced;
    default: return CourseLevel.beginner;
    }
  }
}