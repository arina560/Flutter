import 'package:course_catalog/app/app_constants.dart';
import 'package:course_catalog/data/datasources/course_data_source.dart';

import '../models/course_dto.dart';

class MockCourseDataSource implements CourseDataSourse {
  static const _mockData = <Map<String, dynamic>>[
    {
      'id': '1',
      'title': 'Программирование на Python с Нуля',
      'description': 'Изучите Python с нуля, освоите работу с базами данных SQL.',
      'imageUrl': '',
      'isBeginner': true,
    },
    {
      'id': '2',
      'title': 'PRO C#. Backend разработчик',
      'description': 'Глубокое погружение в C#, ASP.NET Core, микросервисы.',
      'imageUrl': '',
      'isBeginner': false,
    },
    {
      'id': '3',
      'title': 'Java-разработчик',
      'description': 'Java Core, OOP, многопоточность, коллекции.',
      'imageUrl': '',
      'isBeginner': false,
    },
  ];
 
  @override
  Future<List<CourseDto>> getCourses() async {
    await Future.delayed(AppConstants.mockDelay);
    return _mockData.map(CourseDto.fromJson).toList();
  }
 
  @override
  Future<CourseDto?> getCourseById(String id) async {
    await Future.delayed(AppConstants.mockDetailDelay);
    final json = _mockData.where((m) => m['id'] == id).firstOrNull;
    return json != null ? CourseDto.fromJson(json) : null;
  }
}