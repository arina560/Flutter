import 'package:course_catalog/domain/usecases/get_courses.dart';
import 'package:course_catalog/presentation/bloc/course_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/datasources/mock_course_data_source.dart';
import 'data/repositories/course_repository_impl.dart';
import 'domain/usecases/filter_courses.dart';
import 'domain/usecases/toggle_favorite.dart';
import 'presentation/screens/course_list_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

final dataSource = MockCourseDataSource();
final repository = CourseRepositoryImpl(dataSource);
final getCourses = GetCoursesUseCase(repository);
final filterCourses = FilterCourses(repository);
final toggleFavorite = ToggleFavorite(repository);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseBloc(getCourses: getCourses, filterCourses: filterCourses, toggleFavorite: toggleFavorite),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        home: CourseListScreen(),
      ),
    );
  }
}
