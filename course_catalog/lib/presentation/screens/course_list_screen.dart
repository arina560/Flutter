import 'package:course_catalog/app/app_constants.dart';
import 'package:course_catalog/presentation/widgets/course_filter_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/app_localizations.dart';
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
       listenWhen: (previos, current) {
        if (current is CourseLoaded && current.snackbarMessage != null) return true;
        if (current is CourseError) return true;
        return false;
      },
      listener: (context, state) {
       if (state is CourseLoaded && state.snackbarMessage != null) {
          _showSnackBar(
            context,
            message: state.snackbarMessage!,
            onUndo: state.toggledCourseId != null ? () => context.read<CourseBloc>().add(CourseFavoriteToggled(state.toggledCourseId!)) : null,
          );
          context.read<CourseBloc>().add(ClearSnackbar());
        } else if (state is CourseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message),  duration: AppConstants.snackbarDuration, persist: false,),
          );
        }
      },
      builder: (context, state) {
        final (onlyBeginners, onlyFavorites) = switch (state) {
          CourseLoaded(:final onlyBeginners, :final onlyFavorites) =>
            (onlyBeginners, onlyFavorites),
          _ => (null, false),
        };
        return Scaffold(
          appBar: AppBar(
            title: Text(context.appTitle, style: AppTextStyles.appBarTitle),
            bottom: PreferredSize(preferredSize: Size.fromHeight(AppConstants.filterBarHeight), 
              child: CourseFilterBar(
                onlyBeginners: onlyBeginners,
                onlyFavorites: onlyFavorites,
                onLevelFilterChange: (c) => context.read<CourseBloc>().add(CourseFilterChange(c)),
                onFavoritesFilterToggle: () => context.read<CourseBloc>().add(const CourseFavoritesFilter()),
              )),
          ),
          body: switch (state) {
            CourseInitial() =>
              const Center(child: CircularProgressIndicator()),
            CourseError(:final message) => _CourseErrorView(
              message: message,
              onRetry: () =>
                  context.read<CourseBloc>().add(const CourseLoadRequested()),
            ),
            CourseLoaded(:final courses) => _CourseListView(
              courses: courses,
              onRefresh: () async =>
                  context.read<CourseBloc>().add(const CourseRefreshRequested()),
              onFavoriteToggle: (id) =>
                  context.read<CourseBloc>().add(CourseFavoriteToggled(id)),
            ),
          },
        );
      }
    );
  }

  void _showSnackBar(BuildContext context,{required String message, required VoidCallback? onUndo}){
    ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(
      content: Text(context.tr(message)), 
      duration: AppConstants.snackbarDuration,
      persist: false,
      action: onUndo != null ? SnackBarAction(label: context.undoAction, onPressed: onUndo) : null,
     ));
  }
}

class _CourseErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CourseErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: AppConstants.errorIconSize, color: Colors.red),
          SizedBox(height: AppConstants.paddingMedium),
          Text(message, textAlign: TextAlign.center, style: AppTextStyles.errorMessage),
          SizedBox(height: AppConstants.paddingMedium),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(context.retryButton),
          ),
        ],
      ),
    );
  }
}

class _CourseListView extends StatelessWidget {
  final List<Course> courses;
  final Future<void> Function() onRefresh;
  final void Function(String courseId) onFavoriteToggle;

  const _CourseListView({
    required this.courses,
    required this.onRefresh,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: AppConstants.detailImageHeight, child: Center(child: Text(context.noCourses))),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return CourseCard(
            course: course,
            onFavoriteToggle: () => onFavoriteToggle(course.id),
          );
        },
      ),
    );
  }
}
