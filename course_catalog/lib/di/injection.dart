import 'package:course_catalog/data/datasources/api_course_data_course.dart';
import 'package:course_catalog/data/datasources/local_course_data_source.dart';
import 'package:course_catalog/data/repositories/course_repository_impl.dart';
import 'package:course_catalog/presentation/bloc/course_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/usecases/filter_courses.dart';
import '../domain/usecases/get_courses.dart';
import '../domain/usecases/toggle_favorite.dart';

final GetIt getit = GetIt.instance;

Future<void> setupDependencies() async {
  final preferences = await SharedPreferences.getInstance();
  getit.registerSingleton<SharedPreferences>(preferences);
  getit.registerLazySingleton<LocalCourseDataSource>(() => LocalCourseDataSource(getit<SharedPreferences>()));
  getit.registerLazySingleton<ApiCourseDataCourse>(() => ApiCourseDataCourse());
  getit.registerLazySingleton<CourseRepositoryImpl>(() => CourseRepositoryImpl(getit<ApiCourseDataCourse>(), getit<LocalCourseDataSource>()));
  getit.registerLazySingleton<GetCoursesUseCase>(() => GetCoursesUseCase(getit<CourseRepositoryImpl>()));
  getit.registerLazySingleton<FilterCourses>(() => FilterCourses(getit<CourseRepositoryImpl>()));
  getit.registerLazySingleton<ToggleFavorite>(() => ToggleFavorite(getit<CourseRepositoryImpl>()));
  getit.registerFactory<CourseBloc>(() => CourseBloc(getCourses: getit<GetCoursesUseCase>(), filterCourses: getit<FilterCourses>(), toggleFavorite: getit<ToggleFavorite>()));
}