import 'package:flutter/material.dart';
import '../../domain/entities/course_level.dart';
import '../../domain/entities/course_level_extension.dart';

class CourseLevelBadge extends StatelessWidget{
  final CourseLevel level;
  const CourseLevelBadge({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: level.color, width: 2),
      ),
      child: Text(
        level.courseLevelName,
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}