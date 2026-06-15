import 'package:flutter/material.dart';
import '../models/course_level.dart';

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