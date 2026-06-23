import '../models/course_dto.dart';

abstract class CourseDataSourse{
  Future<List<CourseDto>> getCourses();
  Future<CourseDto?> getCourseById(int id);
}