import 'package:course_catalog/data/datasources/course_data_source.dart';
import 'package:course_catalog/data/datasources/local_course_data_source.dart';
import 'package:course_catalog/domain/entities/course.dart';
import 'package:course_catalog/domain/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseDataSourse _dataSourse;
  final LocalCourseDataSource _localDataSource;
  CourseRepositoryImpl(this._dataSourse, this._localDataSource);

  @override
  Future<List<Course>> getCourses() async{
    final dtos = await _dataSourse.getCourses();
    final favorites = _localDataSource.getFavoriteIds();
    return dtos.map((dto) {
      return dto.toEntity(isFavorite: favorites.contains(dto.id));
    }).toList();
  }

  @override
  Future<Course?> getCourseById(String id) async {
    final dto = await _dataSourse.getCourseById(id);
    if (dto == null) return null;
    return dto.toEntity(isFavorite: _localDataSource.isFavorite(dto.id));
  }

  @override
  Future<List<Course>> getFilteredCourses({bool? onlyBeginners, bool onlyFavorites = false}) async {
    final courses = await getCourses();
    return courses.where((course) {
      if (onlyBeginners != null && course.isBeginner != onlyBeginners) return false;
      if (onlyFavorites && !course.isFavorite) return false;
      return true;
    }).toList();
  }

  @override
  Future<void> toggleFavorite(String courseId) async{
    await _localDataSource.toggleFavorite(courseId);
  }
}