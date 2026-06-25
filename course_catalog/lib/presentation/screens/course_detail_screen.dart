import 'package:course_catalog/presentation/bloc/course_bloc.dart';
import 'package:course_catalog/presentation/bloc/course_event.dart';
import 'package:course_catalog/presentation/bloc/course_state.dart';
import 'package:course_catalog/presentation/widgets/course_level_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/course.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseId;
  const CourseDetailScreen({super.key,required this.courseId});

  Course? _findCourse(CourseState state){
    return switch (state) {
      CourseLoaded() => state.courses.where((c) => c.id == courseId).firstOrNull,
      CourseRefreshing() => state.courses.where((c) => c.id == courseId).firstOrNull,
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context){
    return BlocBuilder<CourseBloc,CourseState> (
      builder: (context, state) {
        final course = _findCourse(state);

        if (course == null){
          return const Scaffold(
            body: Center(child: Text('Курс не найден')),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("Course details", style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(onPressed: (){
                context.read<CourseBloc>().add(CourseFavoriteToggled(courseId));
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
                Image.network(course.imageUrl, height: 300, width: double.infinity, fit: BoxFit.cover),
                Text(course.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                CourseLevelBadge(isBeginner: course.isBeginner),
                Text('Описание курса', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(course.description, style: TextStyle(fontSize: 16))
              ],
            ),
          ),
        );
      }
    );

    
  }
}