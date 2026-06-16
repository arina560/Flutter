import 'package:course_catalog/widgets/course_level_badge.dart';
import 'package:course_catalog/widgets/course_meta_row.dart';
import 'package:flutter/material.dart';

import '../models/course.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;
  const CourseDetailScreen({super.key,required this.course});
  
  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreen();
}

class _CourseDetailScreen extends State<CourseDetailScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Course details", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: (){
            setState(() {
              widget.course.isFavorite = !widget.course.isFavorite;
            });
          }, icon: Icon(
            widget.course.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: widget.course.isFavorite ? Colors.red : Colors.grey,
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
            Text(widget.course.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            CourseLevelBadge(level: widget.course.level),
            CourseMetaRow(duration: widget.course.duration, numberOfLessons: widget.course.numberOfLessons),
            Text('Описание курса', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(widget.course.fullDescription, style: TextStyle(fontSize: 16))
          ],
        ),
      ),
    );
  }
}