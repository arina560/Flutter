import 'package:course_catalog/domain/usecases/filter_courses.dart';
import 'package:course_catalog/domain/usecases/get_courses.dart';
import 'package:course_catalog/domain/usecases/toggle_favorite.dart';
import 'package:course_catalog/presentation/bloc/course_event.dart';
import 'package:course_catalog/presentation/bloc/course_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCoursesUseCase _getCourses;
  final FilterCourses _filterCourses;
  final ToggleFavorite _toggleFavorite;
  CourseBloc({
    required GetCoursesUseCase getCourses,
    required FilterCourses filterCourses,
    required ToggleFavorite toggleFavorite,
  })  : _getCourses = getCourses,
        _filterCourses = filterCourses,
        _toggleFavorite = toggleFavorite,
        super(const CourseInitial()) {
        on<CourseLoadRequested>(_onLoadRequeted);
        on<CourseRefreshRequested>(_onRefreshRequested);
        on<CourseFilterChange>(_onFilterChange);
        on<CourseFavoritesFilter>(_onFavoritesFilter);
        on<CourseFavoriteToggled>(_onCourseFavoriteToggled);
        on<ClearSnackbar>(_onClearSnackBar);
      
  }

  Future<void> _onLoadRequeted(CourseLoadRequested event, Emitter<CourseState> emit) async{
    emit(const CourseInitial());
    try {
      final courses = await _getCourses();
      emit(CourseLoaded(courses: courses));
    } catch (e){
      emit(CourseError(_formatError(e)));
    }
  }

  Future<void> _onRefreshRequested(CourseRefreshRequested event, Emitter<CourseState> emit) async{
    final current = state;
    if (current is! CourseLoaded) {
      add(const CourseLoadRequested());
      return;
    }
    emit(CourseRefreshing(courses: current.courses, onlyBeginners: current.onlyBeginners, onlyFavorites: current.onlyFavorites));
    try{
      final courses = await _filterCourses(FilterCoursesParams(onlyBeginners: current.onlyBeginners, onlyFavorites: current.onlyFavorites));
      emit(current.copyWith(courses: courses));
    } catch (e){
      emit(current);
    }
  }

  Future<void> _onFilterChange(CourseFilterChange event, Emitter<CourseState> emit) async {
    final current = state;
    if (current is! CourseLoaded) return;
    if (current.onlyBeginners == event.onlyBeginners) return;
    try {
      final courses = await _filterCourses(FilterCoursesParams(onlyBeginners: event.onlyBeginners, onlyFavorites: current.onlyFavorites));
      emit(current.copyWith(courses: courses, onlyBeginners: event.onlyBeginners, clearLevel: event.onlyBeginners == null));
    } catch (e) {
      emit(CourseError(_formatError(e)));
    }
  }

  Future<void> _onFavoritesFilter(CourseFavoritesFilter event, Emitter<CourseState> emit) async {
    final current = state;
    if (current is! CourseLoaded) return;
    final newOnlyFavorites = !current.onlyFavorites;
    try {
      final courses = await _filterCourses(FilterCoursesParams( onlyBeginners: current.onlyBeginners, onlyFavorites: newOnlyFavorites));
      emit(current.copyWith( courses: courses, onlyFavorites: newOnlyFavorites));
    } catch (e) {
      emit(CourseError(_formatError(e)));
    }
  }

  Future<void> _onCourseFavoriteToggled(CourseFavoriteToggled event, Emitter<CourseState> emit) async {
    final current = state;
    if (current is! CourseLoaded) return;
    final course = current.courses.where((c) => c.id == event.courseId).firstOrNull;
    if (course == null) return;
    try {
      await _toggleFavorite(event.courseId);
      final courses = await _filterCourses(FilterCoursesParams( onlyBeginners: current.onlyBeginners, onlyFavorites: current.onlyFavorites));
      final message = course.isFavorite ? 'Удален из избранных' : 'Добавлен в избранные';
      emit(current.copyWith(
      courses: courses,
      snackbarMessage: message,
      toggledCourseId: event.courseId,
    ));
    } catch (e){
      emit(CourseError(_formatError(e)));
    }
  }

  Future<void> _onClearSnackBar(ClearSnackbar event, Emitter<CourseState> emit) async {
    if (state is CourseLoaded) {
      final loadedState = state as CourseLoaded;
      emit(loadedState.copyWith(
        clearSnackbar: true,
        clearToggled: true,
      ));
    }
  }

  String _formatError(Object error) {
    return error.toString();
  }
}