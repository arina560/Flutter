import '../models/course.dart';
import '../widgets/course_level_badge.dart';
import '../widgets/course_meta_row.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatefulWidget {
  final Course course;
  const CourseCard({super.key, required this.course});

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard>{
  bool _isHidden = true;

  void _toggleHidden() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.course.title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 3),
            CourseLevelBadge(level: widget.course.level),
            if (_isHidden) ...[
              const SizedBox(height: 3),
              CourseMetaRow(duration: widget.course.duration, numberOfLessons: widget.course.numberOfLessons),
              const SizedBox(height: 8),
              Text(widget.course.description),
            ],
            const SizedBox(height: 3),
            GestureDetector(
              onTap: _toggleHidden,
              child: Icon(
                _isHidden ? Icons.remove : Icons.add,
              ),
            )
          ],
        ),
      ),
    );
  }
}
