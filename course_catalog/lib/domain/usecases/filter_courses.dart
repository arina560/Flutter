import 'package:course_catalog/domain/repositories/course_repository.dart';
import '../entities/course.dart';
import '../entities/course_level.dart';

class FilterCoursesParams {
  final CourseLevel? level;
  final bool onlyFavorites;
 
  const FilterCoursesParams({
    this.level,
    this.onlyFavorites = false,
  });
 
  FilterCoursesParams copyWith({
    CourseLevel? level,
    bool clearLevel = false,
    bool? onlyFavorites,
  }) {
    return FilterCoursesParams(
      level: clearLevel ? null : level ?? this.level,
      onlyFavorites: onlyFavorites ?? this.onlyFavorites,
    );
  }
}

class FilterCourses {
  final CourseRepository _repository;
 
  const FilterCourses(this._repository);
 
  Future<List<Course>> call(FilterCoursesParams params) {
    return _repository.getFilteredCourses( level: params.level, onlyFavorites: params.onlyFavorites);
  }
}