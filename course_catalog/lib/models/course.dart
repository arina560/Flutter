import 'course_level.dart';

class Course{
  final int id;
  final String title;
  final CourseLevel level;
  final String duration;
  final int numberOfLessons;
  final String shortDescription;
  final String fullDescription;
  final bool isFavorite;

  const Course({
    required this.id,
    required this.title,
    required this.level,
    required this.duration,
    required this.numberOfLessons,
    required this.shortDescription,
    required this.fullDescription,
    this.isFavorite = false,
  });

  Course copyWith({bool? isFavorite}) {
    return Course(
      id: id,
      title: title,
      level: level,
      duration: duration,
      numberOfLessons: numberOfLessons,
      shortDescription: shortDescription,
      fullDescription: fullDescription,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}