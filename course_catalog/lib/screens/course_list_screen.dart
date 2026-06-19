import 'package:course_catalog/models/course_level.dart';
import 'package:course_catalog/providers/course_scope.dart';
import 'package:flutter/material.dart';
import '../models/course.dart';
import '../widgets/course_card.dart';

class CourseListScreen extends StatefulWidget{
  const CourseListScreen({super.key});
  
  @override
  State<CourseListScreen> createState() => _CourseListScreen();
}

class _CourseListScreen extends State<CourseListScreen>{
  CourseLevel? _selectedLevel;
  bool _onlyFavorites = false;

  List<Course> get _filteredCourses {
    return CourseScopeProvider.of(context).filterCourses(
      level: _selectedLevel,
      onlyFavorites: _onlyFavorites,
    );
  }

  void _toggleFavoritesFilter(){
    setState(() {
      _onlyFavorites = !_onlyFavorites;
    });
  }

  void _setLevelFilter(CourseLevel? level){
    setState(() {
      _selectedLevel = level;
    });
  }

  void _toggleIsFavorite(Course course){
    final provider = CourseScopeProvider.of(context);
    if (course.isFavorite) {
      provider.removeFromFavorites(course.id);
    } else {
      provider.addToFavorites(course.id);
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    final snackBar = SnackBar(
      content: Text(course.isFavorite ? "Удален из избранных" : "Добавлен в избранные"),
      duration: const Duration(seconds: 2),
      persist: false,
      action: SnackBarAction(
        label: "Отмена",
        onPressed: () {
          if (course.isFavorite) {
            provider.addToFavorites(course.id);
          } else {
            provider.removeFromFavorites(course.id);
          }
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Programming courses", style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.deepPurple,
        actions: [
          DropdownButton<CourseLevel>(
            value: _selectedLevel,
            hint: const Text("Все уровни"),
            items: [
              const DropdownMenuItem<CourseLevel>(
                value: null,
                child: Text("Все уровни")
                ),
              for (var level in CourseLevel.values)
                DropdownMenuItem<CourseLevel>(
                  value: level,
                  child: Text(level.courseLevelName),
                )
            ],
            onChanged: (level) => _setLevelFilter(level),
          ),
          IconButton(
            onPressed: _toggleFavoritesFilter, 
            icon: Icon(
              _onlyFavorites ? Icons.favorite : Icons.favorite_border,
              color: _onlyFavorites ? Colors.red : Colors.grey,
            ),
            tooltip: "Только избранные",
          )
        ],
      ),
      body: _filteredCourses.isEmpty 
      ? Center(child: Text("Нет курсов, соответствующих фильтру"))
      : ListView.builder(
        itemCount: _filteredCourses.length,
        itemBuilder: (context, index){
          final course = _filteredCourses[index];
          return CourseCard(course: course, onFavoriteToggle: () => _toggleIsFavorite(course));
        },
      ),
    );
  }
}