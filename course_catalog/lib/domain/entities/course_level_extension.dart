import 'package:flutter/material.dart';

import 'course_level.dart';

extension CourseLevelColor on CourseLevel {
  Color get color {
    switch (this) {
      case CourseLevel.beginner:
        return Colors.green;
      case CourseLevel.intermediate:
        return Colors.orange;
      case CourseLevel.advanced:
        return Colors.red;
    }
  }
}