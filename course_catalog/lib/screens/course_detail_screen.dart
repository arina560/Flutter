import 'package:course_catalog/widgets/course_level_badge.dart';
import 'package:course_catalog/widgets/course_meta_row.dart';
import 'package:course_catalog/providers/course_scope.dart';
import 'package:flutter/material.dart';

import '../models/course.dart';

class CourseDetailScreen extends StatefulWidget {
  final int courseId;
  const CourseDetailScreen({super.key,required this.courseId});
  
  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreen();
}

class _CourseDetailScreen extends State<CourseDetailScreen>{
  Course? _course;

  @override
  void didChangeDependencies() {
    _course = CourseScopeProvider.of(context).getCourseById(widget.courseId);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context){
    if (_course == null){
      return const Scaffold(
        body: Center(child: Text('Курс не найден')),
      );
    }
    final course = _course!;
    return Scaffold(
      appBar: AppBar(
        title: Text("Course details", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: (){
            final provider = CourseScopeProvider.of(context);
            if (course.isFavorite) {
              provider.removeFromFavorites(widget.courseId);
            } else {
              provider.addToFavorites(widget.courseId);
            }

            ScaffoldMessenger.of(context).clearSnackBars();
            final snackBar = SnackBar(
              content: Text(course.isFavorite ? "Удален из избранных" : "Добавлен в избранные"),
              duration: const Duration(seconds: 2),
              persist: false,
              action: SnackBarAction(
                label: "Отмена",
                onPressed: () {
                  if (course.isFavorite) {
                    provider.addToFavorites(widget.courseId);
                  } else {
                    provider.removeFromFavorites(widget.courseId);
                  }
                },
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }, icon: Icon(
            course.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: course.isFavorite ? Colors.red : Colors.grey,
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