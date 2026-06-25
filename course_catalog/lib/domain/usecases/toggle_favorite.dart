import 'package:course_catalog/domain/repositories/course_repository.dart';

class ToggleFavorite {
  final CourseRepository _repository;
  const ToggleFavorite(this._repository);
  Future<void> call(String courseId){
    return _repository.toggleFavorite(courseId);
  }
}