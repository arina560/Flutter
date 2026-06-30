import 'package:dio/dio.dart';
import 'package:course_catalog/data/datasources/course_data_source.dart';
import '../models/course_dto.dart';

class ApiCourseDataCourse implements CourseDataSourse{
  static const _baseUrl = 'https://6a3bdbbce4a07f202e160ec3.mockapi.io/api/v1';
  final Dio _dio;
  ApiCourseDataCourse({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: _baseUrl));

  @override
  Future<List<CourseDto>> getCourses() async {
    try {
      final response = await _dio.get('/courses');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data; 
        return jsonList.cast<Map<String, dynamic>>().map(CourseDto.fromJson).toList();
      } else {
        throw Exception('load_error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('network_error: ${e.message}');
    }
  }
  @override
  Future<CourseDto?> getCourseById(String id) async {
    try {
      final response = await _dio.get('/courses/$id');
      if (response.statusCode == 200) {
        return CourseDto.fromJson(response.data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('load_error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('network_error: ${e.message}');
    }
  }
}