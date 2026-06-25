import 'dart:convert';
import 'dart:io';
import 'package:course_catalog/data/datasources/course_data_source.dart';
import '../models/course_dto.dart';

class ApiCourseDataCourse implements CourseDataSourse{
  static const _baseUrl = 'https://6a3bdbbce4a07f202e160ec3.mockapi.io/api/v1';
  final HttpClient _client;
  ApiCourseDataCourse({HttpClient? client}) : _client = client ?? HttpClient();

  @override
  Future<List<CourseDto>> getCourses() async {
    final uri = Uri.parse('$_baseUrl/courses');
    final json = await _getJson(uri) as List<dynamic>;
    return json
        .cast<Map<String, dynamic>>()
        .map(CourseDto.fromJson)
        .toList();
  }
 
  @override
  Future<CourseDto?> getCourseById(String id) async {
    final uri = Uri.parse('$_baseUrl/courses/$id');
    try {
      final json = await _getJson(uri) as Map<String, dynamic>;
      return CourseDto.fromJson(json);
    } on HttpException catch (_) {
      return null;
    }
  }

  Future<dynamic> _getJson(Uri uri) async {
    final request = await _client.getUrl(uri);
    final response = await request.close();
 
    if (response.statusCode == 404) {
      throw HttpException('Not found: $uri');
    }
    if (response.statusCode != 200) {
      throw HttpException(
        'HTTP ${response.statusCode} for $uri',
      );
    }
 
    final body = await response.transform(utf8.decoder).join();
    return jsonDecode(body);
  }
}