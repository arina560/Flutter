import '../../domain/entities/course.dart';

sealed class CourseState {
  const CourseState();
}

final class CourseInitial extends CourseState{
  const CourseInitial();
}

final class CourseLoading extends CourseState{
  const CourseLoading();
}

final class CourseRefreshing extends CourseState{
  final List<Course> courses;
  final bool? onlyBeginners;
  final bool onlyFavorites;
  const CourseRefreshing({required this.courses, this.onlyBeginners, this.onlyFavorites = false});
}

final class CourseLoaded extends CourseState{
  final List<Course> courses;
  final bool? onlyBeginners;
  final bool onlyFavorites;
  CourseLoaded({required this.courses, this.onlyBeginners, this.onlyFavorites = false});
  
  CourseLoaded copyWith({
    List<Course>? courses,
    bool? onlyBeginners,
    bool clearLevel = false,
    bool? onlyFavorites,
  }) {
    return CourseLoaded(
      courses: courses ?? this.courses,
      onlyBeginners: clearLevel ? null : onlyBeginners ?? this.onlyBeginners,
      onlyFavorites: onlyFavorites ?? this.onlyFavorites,
    );
  }
}

final class CourseError extends CourseState {
  final String message;
  const CourseError(this.message);
}

final class CourseAddedToFavorites extends CourseState{
  final String courseId;
  const CourseAddedToFavorites(this.courseId);
}

final class CourseRemoveFromFavorites extends CourseState{
  final String courseId;
  const CourseRemoveFromFavorites(this.courseId);
}