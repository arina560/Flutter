import 'package:course_catalog/domain/repositories/course_repository.dart';
import '../entities/course.dart';

class FilterCoursesParams {
  final bool? onlyBeginners;
  final bool onlyFavorites;
 
  const FilterCoursesParams({
    this.onlyBeginners,
    this.onlyFavorites = false,
  });
 
  FilterCoursesParams copyWith({
    bool? onlyBeginners,
    bool clearLevel = false,
    bool? onlyFavorites,
  }) {
    return FilterCoursesParams(
      onlyBeginners: clearLevel ? null : onlyBeginners ?? this.onlyBeginners,
      onlyFavorites: onlyFavorites ?? this.onlyFavorites,
    );
  }
}

class FilterCourses {
  final CourseRepository _repository;
 
  const FilterCourses(this._repository);
 
  Future<List<Course>> call(FilterCoursesParams params) {
    return _repository.getFilteredCourses( onlyBeginners: params.onlyBeginners, onlyFavorites: params.onlyFavorites);
  }
}