import 'package:course_catalog/presentation/bloc/course_bloc.dart';
import 'package:course_catalog/presentation/bloc/course_event.dart';
import 'package:course_catalog/presentation/bloc/course_state.dart';
import 'package:course_catalog/presentation/widgets/course_level_badge.dart';
import 'package:course_catalog/presentation/widgets/course_meta_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/course.dart';

class CourseDetailScreen extends StatelessWidget {
  final int courseId;
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
                // ScaffoldMessenger.of(context).clearSnackBars();
                // final snackBar = SnackBar(
                //   content: Text(course.isFavorite ? "Удален из избранных" : "Добавлен в избранные"),
                //   duration: const Duration(seconds: 2),
                //   persist: false,
                //   action: SnackBarAction(
                //     label: "Отмена",
                //     onPressed: () {
                //       if (course.isFavorite) {
                //         provider.addToFavorites(widget.courseId);
                //       } else {
                //         provider.removeFromFavorites(widget.courseId);
                //       }
                //     },
                //   ),
                //ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
    );

    
  }
}