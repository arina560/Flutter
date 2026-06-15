import 'package:flutter/material.dart';

enum CourseLevel{
  beginner('Начинающий', Colors.green),
  intermediate('Средний', Colors.orange),
  advanced('Продвинутый', Colors.red);

  final String courseLevelName;
  final Color color;

  const CourseLevel(this.courseLevelName, this.color);
}