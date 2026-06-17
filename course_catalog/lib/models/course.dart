import 'course_level.dart';

class Course{
  final int id;
  final String title;
  final CourseLevel level;
  final String duration;
  final int numberOfLessons;
  final String shortDescription;
  final String fullDescription;
  bool isFavorite;
  Course({
    required this.id,
    required this.title, 
    required this.level, 
    required this.duration, 
    required this.numberOfLessons, 
    required this.shortDescription,
    required this.fullDescription,
    this.isFavorite = false,
    });
}