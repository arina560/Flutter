import 'package:flutter/material.dart';

class CourseMetaRow extends StatelessWidget{
  final String duration;
  final int numberOfLessons;
  const CourseMetaRow({super.key, required this.duration, required this.numberOfLessons});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(duration, style: TextStyle(fontSize: 13),),
        const SizedBox(width: 16),
        Text("$numberOfLessons уроков", style: TextStyle(fontSize: 13)),
      ],
    );
  }
}