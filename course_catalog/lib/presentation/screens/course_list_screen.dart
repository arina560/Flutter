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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseBloc, CourseState>(
      listenWhen: (_, current) =>
          current is CourseAddedToFavorites ||
          current is CourseRemoveFromFavorites ||
          current is CourseError,
      listener: (context, state) {
        switch (state) {
          case CourseAddedToFavorites():
          _showSnackBar(context, message: "Добавлен в изранные", onUndo: () => context.read<CourseBloc>().add(CourseFavoriteToggled(state.courseId)));
          case CourseRemoveFromFavorites(): 
          _showSnackBar(context, message: "Удален из избранных", onUndo: () => context.read<CourseBloc>().add(CourseFavoriteToggled(state.courseId)));
          case CourseError():
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Expanded(child: Text(state.message))));
          default: break;
        }
      },
      builder: (context, state) {
        final (onlyBeginners, onlyFavorites) = switch (state) {
          CourseLoaded(:final onlyBeginners, :final onlyFavorites) =>
            (onlyBeginners, onlyFavorites),
          CourseRefreshing(:final onlyBeginners, :final onlyFavorites) =>
            (onlyBeginners, onlyFavorites),
          _ => (null, false),
        };
        return Scaffold(
          appBar: AppBar(
            title: const Text("Courses", style: TextStyle(fontWeight: FontWeight.bold),),
            backgroundColor: Colors.greenAccent,
            foregroundColor: Colors.deepPurple,
            bottom: PreferredSize(preferredSize: Size.fromHeight(35), 
              child: CourseFilterBar(
                onlyBeginners: onlyBeginners,
                onlyFavorites: onlyFavorites,
                onLevelFilterChange: (c) => context.read<CourseBloc>().add(CourseFilterChange(c)),
                onFavoritesFilterToggle: () => context.read<CourseBloc>().add(const CourseFavoritesFilter()),
              )),
          ),
          body: switch (state) {
            CourseInitial() || CourseLoading() =>
              const Center(child: CircularProgressIndicator()),
            CourseError(:final message) =>
              _buildError(context, message),
            CourseLoaded(:final courses) ||
            CourseRefreshing(:final courses) =>
              _buildCourseList(context, courses),
            _ => const SizedBox.shrink(),
          },
        );
      }
    );
  }

  Widget _buildError(BuildContext context, String message){
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
    if (courses.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async { context.read<CourseBloc>().add(const CourseRefreshRequested());},
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 300, child: Center(child: Text('Нет курсов'))),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async { context.read<CourseBloc>().add(const CourseRefreshRequested()); },
      child: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return CourseCard(
            course: course,
            onFavoriteToggle: () => context.read<CourseBloc>().add(CourseFavoriteToggled(course.id)),
          );
        },
      ),
    );
  }

  void _showSnackBar(BuildContext context,{required String message, required VoidCallback onUndo}){
    ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(
      content: Text(message), 
      duration: const Duration(seconds: 2),
      persist: false,
      action: SnackBarAction(label: "Отмена", onPressed: onUndo),
     ));
  }
}