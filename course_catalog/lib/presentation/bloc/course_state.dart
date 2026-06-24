import '../../domain/entities/course.dart';
import '../../domain/entities/course_level.dart';

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
  final CourseLevel? selectedLevel;
  final bool onlyFavorites;
  const CourseRefreshing({required this.courses, this.selectedLevel, this.onlyFavorites = false});
}

final class CourseLoaded extends CourseState{
  final List<Course> courses;
  final CourseLevel? selectedLevel;
  final bool onlyFavorites;
  CourseLoaded({required this.courses, this.selectedLevel, this.onlyFavorites = false});
  
  CourseLoaded copyWith({
    List<Course>? courses,
    CourseLevel? selectedLevel,
    bool clearLevel = false,
    bool? onlyFavorites,
  }) {
    return CourseLoaded(
      courses: courses ?? this.courses,
      selectedLevel: clearLevel ? null : selectedLevel ?? this.selectedLevel,
      onlyFavorites: onlyFavorites ?? this.onlyFavorites,
    );
  }
}

final class CourseError extends CourseState {
  final String message;
  const CourseError(this.message);
}

final class CourseAddedToFavorites extends CourseState{
  final int courseId;
  const CourseAddedToFavorites(this.courseId);
}

final class CourseRemoveFromFavorites extends CourseState{
  final int courseId;
  const CourseRemoveFromFavorites(this.courseId);
}