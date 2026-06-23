import 'package:course_catalog/data/datasources/course_data_source.dart';
import 'package:course_catalog/domain/entities/course.dart';
import 'package:course_catalog/domain/repositories/course_repository.dart';

import '../../domain/entities/course_level.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseDataSourse _dataSourse;
  final Set<int> _favoriteIds = {};
  CourseRepositoryImpl(this._dataSourse);

  @override
  Future<List<Course>> getCourses() async{
    final dtos = await _dataSourse.getCourses();
    return dtos.map((dto) {
      return dto.toEntity(isFavorite: _favoriteIds.contains(dto.id));
    }).toList();
  }

  @override
  Future<Course?> getCourseById(int id) async {
    final dto = await _dataSourse.getCourseById(id);
    if (dto == null) return null;
    return dto.toEntity(isFavorite: _favoriteIds.contains(dto.id));
  }

  @override
  Future<List<Course>> getFilteredCourses({CourseLevel? level, bool onlyFavorites = false}) async {
    final courses = await _dataSourse.getCourses();
    final allCourses = courses.map((dto) {
      return dto.toEntity(isFavorite: _favoriteIds.contains(dto.id));
    }).toList();
    return allCourses.where((course) {
      if (level != null && course.level != level) return false;
      if (onlyFavorites && !course.isFavorite) return false;
      return true;
    }).toList();
  }

  @override
  Future<void> toggleFavorite(int courseId) async{
    if (_favoriteIds.contains(courseId)) {
      _favoriteIds.remove(courseId);
    } else {
      _favoriteIds.add(courseId);
    }
  }
}