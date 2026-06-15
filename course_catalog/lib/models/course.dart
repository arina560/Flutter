import 'course_level.dart';

class Course{
  final String title;
  final CourseLevel level;
  final String duration;
  final int numberOfLessons;
  final String shortDescription;
  final String fullDescription;
  const Course({
    required this.title, 
    required this.level, 
    required this.duration, 
    required this.numberOfLessons, 
    required this.shortDescription,
    required this.fullDescription
    });
}