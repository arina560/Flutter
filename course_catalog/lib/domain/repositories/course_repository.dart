import '../entities/course.dart';
import '../entities/course_level.dart';

abstract class CourseRepository {
  Future<List<Course>> getCourses();
  Future<Course?> getCourseById(int id);
  Future<List<Course>> getFilteredCourses({CourseLevel? level, bool onlyFavorites = false});
  Future<void> toggleFavorite(int courseId);
}