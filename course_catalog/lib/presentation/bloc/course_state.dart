import '../../domain/entities/course.dart';

sealed class CourseState {
  const CourseState();
}

final class CourseInitial extends CourseState{
  const CourseInitial();
}

class CourseLoaded extends CourseState{
  final List<Course> courses;
  final bool? onlyBeginners;
  final bool onlyFavorites;
  final String? snackbarMessage;
  final String? toggledCourseId;
  CourseLoaded({required this.courses, this.onlyBeginners, this.onlyFavorites = false, this.snackbarMessage, this.toggledCourseId});
  
  CourseLoaded copyWith({
    List<Course>? courses,
    bool? onlyBeginners,
    bool clearLevel = false,
    String? snackbarMessage,
    bool? onlyFavorites,
    bool clearSnackbar = false,
    String? toggledCourseId,
    bool clearToggled = false,
  }) {
    return CourseLoaded(
      courses: courses ?? this.courses,
      onlyBeginners: clearLevel ? null : onlyBeginners ?? this.onlyBeginners,
      onlyFavorites: onlyFavorites ?? this.onlyFavorites,
      snackbarMessage: clearSnackbar ? null : snackbarMessage ?? this.snackbarMessage, 
      toggledCourseId: clearToggled ? null : toggledCourseId ?? this.toggledCourseId,
    );
  }
}

final class CourseRefreshing extends CourseLoaded{
  CourseRefreshing({required super.courses, super.onlyBeginners, super.onlyFavorites = false});
}

final class CourseError extends CourseState {
  final String message;
  const CourseError(this.message);
}