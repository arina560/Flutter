import 'package:course_catalog/widgets/course_level_badge.dart';
import 'package:course_catalog/widgets/course_meta_row.dart';
import 'package:course_catalog/widgets/course_scope.dart';
import 'package:flutter/material.dart';

import '../models/course.dart';

class CourseDetailScreen extends StatefulWidget {
  final int courseId;
  const CourseDetailScreen({super.key,required this.courseId});
  
  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreen();
}

class _CourseDetailScreen extends State<CourseDetailScreen>{
  Course get _course => CourseScopeProvider.of(context).getCourseById(widget.courseId)!;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Course details", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: (){
            CourseScopeProvider.of(context).toggleFavorite(widget.courseId);
          }, icon: Icon(
            _course.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _course.isFavorite ? Colors.red : Colors.grey,
          ))
        ],
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_course.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            CourseLevelBadge(level: _course.level),
            CourseMetaRow(duration: _course.duration, numberOfLessons: _course.numberOfLessons),
            Text('Описание курса', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(_course.fullDescription, style: TextStyle(fontSize: 16))
          ],
        ),
      ),
    );
  }
}