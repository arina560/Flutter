import 'package:course_catalog/domain/repositories/course_repository.dart';
import '../entities/course.dart';

class GetCoursesUseCase {
  final CourseRepository repository;
  GetCoursesUseCase(this.repository);
  Future<List<Course>> call(){
    return repository.getCourses();
  }
}