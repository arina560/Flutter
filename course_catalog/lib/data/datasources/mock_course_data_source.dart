import 'package:course_catalog/data/datasources/course_data_source.dart';

import '../models/course_dto.dart';

class MockCourseDataSource implements CourseDataSourse {
  static const _mockData = [
    {
      'id': 1,
      'title': 'Программирование на Python с Нуля + Работа с SQL',
      'level': 'beginner',
      'duration': '8 недель',
      'numberOfLessons': 48,
      'shortDescription': '...',
      'fullDescription': '...',
    },
  ];
  
  @override
  Future<List<CourseDto>> getCourses() async {
    // Имитируем задержку сети
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockData.map(CourseDto.fromJson).toList();
  }

  @override
  Future<CourseDto?> getCourseById(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final json = _mockData.where((m) => m['id'] == id).firstOrNull;
    return json != null ? CourseDto.fromJson(json) : null;
  }
}