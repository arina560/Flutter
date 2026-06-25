import '../entities/course.dart';

abstract class CourseRepository {
  Future<List<Course>> getCourses();
  Future<Course?> getCourseById(String id);
  Future<List<Course>> getFilteredCourses({bool? onlyBeginners, bool onlyFavorites = false});
  Future<void> toggleFavorite(String id);
}