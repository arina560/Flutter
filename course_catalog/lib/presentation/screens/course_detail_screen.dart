import 'package:course_catalog/presentation/bloc/course_bloc.dart';
import 'package:course_catalog/presentation/bloc/course_event.dart';
import 'package:course_catalog/presentation/bloc/course_state.dart';
import 'package:course_catalog/presentation/widgets/course_level_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/app_constants.dart';
import '../../app/app_localizations.dart';
import '../../domain/entities/course.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseId;
  const CourseDetailScreen({super.key,required this.courseId});

  Course? _findCourse(CourseState state){
    return switch (state) {
      CourseLoaded() => state.courses.where((c) => c.id == courseId).firstOrNull,
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context){
    return BlocBuilder<CourseBloc,CourseState> (
      builder: (context, state) {
        final course = _findCourse(state);

        if (course == null){
          return Scaffold(
            body: Center(child: Text(context.courseNotFound)),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(context.courseDetails),
            actions: [
              IconButton(onPressed: (){
                context.read<CourseBloc>().add(CourseFavoriteToggled(courseId));
              }, icon: Icon(
                course.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: course.isFavorite ? Colors.red : Colors.grey,
              ))
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              spacing: AppConstants.paddingMedium,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(course.imageUrl, height: AppConstants.detailImageHeight, width: double.infinity, fit: BoxFit.cover),
                Text(course.title, style: AppTextStyles.headline1,),
                CourseLevelBadge(isBeginner: course.isBeginner),
                Text(context.descriptionLabel, style: AppTextStyles.headline2),
                Text(course.description, style: AppTextStyles.body)
              ],
            ),
          ),
        );
      }
    );

    
  }
}