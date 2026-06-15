import 'package:course_catalog/widgets/course_level_badge.dart';
import 'package:course_catalog/widgets/course_meta_row.dart';
import 'package:flutter/material.dart';

import '../models/course.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;
  const CourseDetailScreen({super.key,required this.course});
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Course details", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            CourseLevelBadge(level: course.level),
            CourseMetaRow(duration: course.duration, numberOfLessons: course.numberOfLessons),
            Text('Описание курса', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(course.fullDescription, style: TextStyle(fontSize: 16))
          ],
        ),
      ),
    );
  }
}