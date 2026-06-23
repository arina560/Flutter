import 'package:course_catalog/presentation/screens/course_detail_screen.dart';

import '../../domain/entities/course.dart';
import 'course_level_badge.dart';
import 'course_meta_row.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatefulWidget {
  final Course course;
  final VoidCallback onFavoriteToggle;
  const CourseCard({super.key, required this.course, required this.onFavoriteToggle});

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
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CourseDetailScreen(courseId: widget.course.id)));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.course.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onFavoriteToggle,
                    icon: Icon(
                      widget.course.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: widget.course.isFavorite ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
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
                Text(widget.course.shortDescription),
              ],
              const SizedBox(height: 3),
              GestureDetector(
                onTap: _toggleHidden,
                child: Icon(
                  _isHidden ? Icons.remove : Icons.add,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
