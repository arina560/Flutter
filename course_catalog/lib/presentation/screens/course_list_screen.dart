import 'package:course_catalog/presentation/widgets/course_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/course.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
import '../widgets/course_card.dart';

class CourseListScreen extends StatelessWidget{
  const CourseListScreen({super.key});

    // ScaffoldMessenger.of(context).clearSnackBars();
    // final snackBar = SnackBar(
    //   content: Text(course.isFavorite ? "Удален из избранных" : "Добавлен в избранные"),
    //   duration: const Duration(seconds: 2),
    //   persist: false,
    //   action: SnackBarAction(
    //     label: "Отмена",
    //     onPressed: () {
    //       if (course.isFavorite) {
    //         provider.addToFavorites(course.id);
    //       } else {
    //         provider.removeFromFavorites(course.id);
    //       }
    //     },
    //   ),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Programming courses", style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.deepPurple,
        bottom: const PreferredSize(preferredSize: Size.fromHeight(35), child: CourseFilterBar()),
      ),
      body: BlocConsumer<CourseBloc,CourseState>(
        listenWhen: (previous, current) => current is CourseAddedToFavorites || current is CourseRemoveFromFavorites || current is CourseError,
        listener: (context, state) {
          switch (state){
            case CourseAddedToFavorites():
            _showSnackBar(context, message: "Добавлен в изранные", onUndo: () => context.read<CourseBloc>().add(CourseFavoriteToggled(state.courseId)));
            case CourseRemoveFromFavorites(): 
            _showSnackBar(context, message: "Удален из избранных", onUndo: () => context.read<CourseBloc>().add(CourseFavoriteToggled(state.courseId)));
            case CourseError():
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Expanded(child: Text(state.message))));
            default: break;
          }
        },
        buildWhen: (_, current) =>
          current is CourseInitial ||
          current is CourseLoading ||
          current is CourseLoaded ||
          current is CourseRefreshing,
        builder: (context, state) {
          return switch (state) {
            CourseInitial() => const SizedBox.shrink(),
            CourseLoading() => const Center(child: CircularProgressIndicator()),
            CourseError(:final message) => _buildErrorView(context, message),
            CourseRefreshing(:final courses) => _buildCourseList(context, courses),
            CourseLoaded(:final courses) => _buildCourseList(context, courses),
            _ => const SizedBox.shrink()
          };
        },
      )
    );
  }

  Widget _buildErrorView(BuildContext context, String message){
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<CourseBloc>().add(const CourseLoadRequested()),
            child: const Text('Попробовать снова'),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList(BuildContext context, List<Course> courses){
    return Column(
      children: [
        if (courses.isEmpty)
          const Expanded(
            child: Center(child: Text('Нет курсов, соответствующих фильтру')),
          )
        else 
          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return CourseCard(
                  course: course,
                  onFavoriteToggle: () => context
                      .read<CourseBloc>()
                      .add(CourseFavoriteToggled(course.id)),
                );
              },
            ),
          ),
      ],
    );
  }

  void _showSnackBar(BuildContext context,{required String message, required VoidCallback onUndo}){
    ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(
      content: Text(message), 
      duration: const Duration(seconds: 2),
      action: SnackBarAction(label: "Отмена", onPressed: onUndo),
     ));
  }
}