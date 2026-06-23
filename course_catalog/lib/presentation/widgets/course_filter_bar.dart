import 'package:course_catalog/domain/entities/course_level.dart';
import 'package:course_catalog/presentation/bloc/course_bloc.dart';
import 'package:course_catalog/presentation/bloc/course_event.dart';
import 'package:course_catalog/presentation/bloc/course_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseFilterBar extends StatelessWidget{
  const CourseFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBloc,CourseState>(
      buildWhen: (previous, current) => current is CourseLoaded || current is CourseRefreshing,
      builder: (context, state) {
        final CourseLevel? selectedLevel;
        final bool onlyFavorites;

        switch (state) {
          case CourseLoaded():
            selectedLevel = state.selectedLevel;
            onlyFavorites = state.onlyFavorites;
          case CourseRefreshing():
            selectedLevel = state.selectedLevel;
            onlyFavorites = state.onlyFavorites;
          default:
            selectedLevel = null;
            onlyFavorites = false;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            children: [
              DropdownButton<CourseLevel>(
                value: selectedLevel,
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
                onChanged: (level) => context.read<CourseBloc>().add(CourseFilterChange(level)),
              ),
              IconButton(
                onPressed:() => context.read<CourseBloc>().add(CourseFavoritesFilter()), 
                icon: Icon(
                  onlyFavorites ? Icons.favorite : Icons.favorite_border,
                  color: onlyFavorites ? Colors.red : Colors.grey,
                ),
                tooltip: "Только избранные",
              )
            ],
          ),
        );
      },
    );
  }
}