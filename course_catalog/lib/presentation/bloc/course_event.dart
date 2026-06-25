sealed class CourseEvent {
  const CourseEvent();
}

final class CourseLoadRequested extends CourseEvent{
  const CourseLoadRequested();
}

final class CourseRefreshRequested extends CourseEvent{
  const CourseRefreshRequested();
}

final class CourseFilterChange extends CourseEvent{
  final bool? onlyBeginners;
  const CourseFilterChange(this.onlyBeginners);
}

final class CourseFavoritesFilter extends CourseEvent{
  const CourseFavoritesFilter();
}

final class CourseFavoriteToggled extends CourseEvent{
  final String courseId;
  const CourseFavoriteToggled(this.courseId);
}